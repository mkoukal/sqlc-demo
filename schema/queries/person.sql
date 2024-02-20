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

-- name: GetStudents :many
WITH teacher_classes AS (
  SELECT r.class_code
  FROM public.relations r
  WHERE r.person_id = $1 AND r.role = 'teacher'
)
SELECT p.*
FROM public.person p
JOIN public.relations r ON p.id = r.person_id
WHERE r.class_code IN (SELECT class_code FROM teacher_classes)
  AND r.role = 'student';
