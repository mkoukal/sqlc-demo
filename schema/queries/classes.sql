-- name: GetClassesByPerson :many
SELECT c.*
FROM public.class AS c
JOIN public.relations AS r ON c.code = r.class_code
JOIN public.person AS p ON r.person_id = p.id
WHERE p.id = $1
AND r.role = $2;
