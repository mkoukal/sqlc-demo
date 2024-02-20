BEGIN;

-- Table
CREATE TABLE public.class (
    code VARCHAR(5) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    credits INTEGER NOT NULL
);

COMMIT;
