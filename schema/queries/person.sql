-- name: GetPerson :one
SELECT *
FROM public.person
WHERE id = $1
LIMIT 1;
