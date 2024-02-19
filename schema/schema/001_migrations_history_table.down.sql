BEGIN;

DROP TRIGGER track_applied_migrations ON public.schema_migrations;
DROP FUNCTION track_applied_migration;
DROP TABLE public.schema_migrations_history;

COMMIT;
