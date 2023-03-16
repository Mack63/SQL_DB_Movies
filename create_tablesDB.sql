-- Database: movies

--DROP DATABASE IF EXISTS movies;


DROP TABLE IF EXISTS public.film_person;
DROP TABLE IF EXISTS public.audience;
DROP TABLE IF EXISTS public.films;
DROP TABLE IF EXISTS public.person;
DROP TABLE IF EXISTS public.countries;



--CREATE DATABASE movies
--    WITH
--    OWNER = postgres
--    ENCODING = 'UTF8'
--    LC_COLLATE = 'Russian_Russia.1251'
--    LC_CTYPE = 'Russian_Russia.1251'
    --TABLESPACE = pg_default
--    CONNECTION LIMIT = -1
--    IS_TEMPLATE = False;
	
-- Table: public.countries

CREATE TABLE IF NOT EXISTS public.countries
(
    id serial NOT NULL,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT countries_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.countries
    OWNER to postgres;
	
-- Table: public.person

CREATE TABLE IF NOT EXISTS public.person
(
    id serial NOT NULL,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT person_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.person
    OWNER to postgres;
	
-- Table: public.films

CREATE TABLE IF NOT EXISTS public.films
(
    id serial NOT NULL,
    title character varying COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    year integer NOT NULL,
    country integer NOT NULL,
    director integer NOT NULL,
    screenwriter integer,
    producer integer,
    operator integer,
    budget integer,
    premiere_world date,
    CONSTRAINT films_pkey PRIMARY KEY (id),
    CONSTRAINT fk_country_id FOREIGN KEY (country)
        REFERENCES public.countries (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_director_id FOREIGN KEY (director)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_operator_id FOREIGN KEY (operator)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_produser_id FOREIGN KEY (producer)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_screenwriter_id FOREIGN KEY (screenwriter)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.films
    OWNER to postgres;
	
-- Table: public.audience

CREATE TABLE IF NOT EXISTS public.audience
(
    film_id integer NOT NULL,
    country_id integer NOT NULL,
    count integer NOT NULL,
    CONSTRAINT audience_pkey PRIMARY KEY (film_id, country_id),
    CONSTRAINT fk_country_id FOREIGN KEY (country_id)
        REFERENCES public.countries (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT fk_film_id FOREIGN KEY (film_id)
        REFERENCES public.films (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID
)
	
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.audience
    OWNER to postgres;
	
-- Table: public.film-person

CREATE TABLE IF NOT EXISTS public.film_person
(
    film_id integer NOT NULL,
    person_id integer NOT NULL,
    participation_type character(1) COLLATE pg_catalog."default",
    CONSTRAINT film_person_pkey PRIMARY KEY (film_id, person_id),
    CONSTRAINT fk_film_id FOREIGN KEY (film_id)
        REFERENCES public.films (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT fk_person_id FOREIGN KEY (person_id)
        REFERENCES public.person (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT check_participation_type CHECK (participation_type = ANY (ARRAY['A'::bpchar, 'D'::bpchar])) NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.film_person
    OWNER to postgres;