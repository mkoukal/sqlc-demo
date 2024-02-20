BEGIN;

-- Create relations table
CREATE TABLE public.relations (
    uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role role_type NOT NULL,
    person_id UUID NOT NULL,
    class_code VARCHAR(5) NOT NULL,
    FOREIGN KEY (person_id) REFERENCES public.person(id),
    FOREIGN KEY (class_code) REFERENCES public.class(code)
);


COMMIT;
