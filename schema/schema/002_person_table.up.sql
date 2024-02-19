BEGIN;

-- Extension
CREATE EXTENSION "uuid-ossp";

-- Table
CREATE TABLE public.person (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

COMMIT;
