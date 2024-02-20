package main

import (
	"context"
	"os"

	log "log/slog"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/mkoukal/sqlc-demo.git/db"
)

func DBMiddleware(conn *db.Queries) gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Set("db", conn)
		c.Next()
	}
}

func getPerson(c *gin.Context) {
	postgres := c.MustGet("db").(*db.Queries)
	id := c.Param("id")
	uuid, err := uuid.Parse(id)
	if err != nil {
		log.Error("Failed to parse uuid! %s", "error", err)
		c.JSON(400, gin.H{"error": "Bad request"})
		return
	}
	person, err := postgres.GetPerson(context.Background(), uuid)
	if err != nil {
		log.Error("Failed to execute query! %s", "error", err)
		c.JSON(404, gin.H{"error": "Not found"})
		return
	}

	c.JSON(200, person)
}

func getClasses(c *gin.Context) {
	postgres := c.MustGet("db").(*db.Queries)
	id := c.Param("id")
	var dbParams db.GetClassesByPersonParams
	err := dbParams.ID.Scan(id)
	errRole := dbParams.Role.Scan(c.Param("role"))
	if err != nil || errRole != nil {
		log.Error("Failed to parse uuid! or role %s", "error", err)
		c.JSON(400, gin.H{"error": "Bad request"})
		return
	}
	classes, err := postgres.GetClassesByPerson(context.Background(), dbParams)
	if err != nil {
		log.Error("Failed to execute query! %s", "error", err)
		c.JSON(404, gin.H{"error": "Not found"})
		return
	}

	c.JSON(200, classes)
}

func deletePerson(c *gin.Context) {
	postgres := c.MustGet("db").(*db.Queries)
	id := c.Param("id")
	uuid, err := uuid.Parse(id)
	if err != nil {
		log.Error("Failed to parse uuid! %s", "error", err)
		c.JSON(400, gin.H{"error": "Bad request"})
		return
	}
	err = postgres.DeletePerson(context.Background(), uuid)
	if err != nil {
		log.Error("Failed to execute query! %s", "error", err)
		c.JSON(404, gin.H{"error": err.Error()})
		return
	}
	c.JSON(200, gin.H{"message": "Person deleted"})
}

func getPeople(c *gin.Context) {
	postgres := c.MustGet("db").(*db.Queries)
	people, err := postgres.ListPeople(context.Background())
	if err != nil {
		log.Error("Failed to execute query! %s", "error", err)
		c.JSON(404, gin.H{"error": "Not found"})
		return
	}

	c.JSON(200, people)
}

func main() {
	connection_params := "host=localhost port=5444 user=postgres password=postgres dbname=sqlc sslmode=disable"
	database, err := pgxpool.New(context.Background(), connection_params)
	if err != nil {
		log.Error("Failed verifying database parameters! %s", "connection string", connection_params)
		os.Exit(1)
	}
	queries := db.New(database)

	r := gin.Default()
	r.Use(DBMiddleware(queries))

	r.GET("/person/:id", getPerson)
	r.GET("/person/:id/classes/:role", getClasses)
	r.DELETE("/person/:id", deletePerson)
	r.GET("/person", getPeople)

	r.Run("localhost:8080")
}
