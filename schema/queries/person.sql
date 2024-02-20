-- name: GetPerson :one
SELECT *
FROM public.person
WHERE id = $1
LIMIT 1;

-- name: DeletePerson :exec
DELETE 
FROM public.person 
WHERE id = $1;

-- name: ListPeople :many
SELECT *
FROM public.person;
