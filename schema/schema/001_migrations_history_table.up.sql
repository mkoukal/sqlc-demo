BEGIN;

DO $schema_migrations_history$
BEGIN
-- Table
CREATE TABLE IF NOT EXISTS public.schema_migrations_history (
    id SERIAL PRIMARY KEY,
    version BIGINT NOT NULL,
    applied_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Trigger handler function
CREATE OR REPLACE FUNCTION track_applied_migration()
RETURNS TRIGGER AS $$
DECLARE _current_version integer;
BEGIN
    SELECT COALESCE(MAX(version),0) FROM public.schema_migrations_history INTO _current_version;
    IF new.dirty = 'false' AND new.version > _current_version THEN
        INSERT INTO public.schema_migrations_history(version) VALUES (new.version);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
END$schema_migrations_history$;

-- Trigger
CREATE OR REPLACE TRIGGER track_applied_migrations
AFTER INSERT ON schema_migrations
FOR EACH ROW
EXECUTE PROCEDURE track_applied_migration();

COMMIT;
