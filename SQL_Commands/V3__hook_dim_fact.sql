CREATE TABLE IF NOT EXISTS dwreporting.dim_continent (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_subregion (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    continent_id INT REFERENCES dwreporting.dim_continent(id),
    subregion_id INT REFERENCES dwreporting.dim_subregion(id),
    population INT,
    code VARCHAR(255),
    capital VARCHAR(255)
 );

CREATE TABLE IF NOT EXISTS dwreporting.dim_city (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    population INT,
    country_id INT REFERENCES dwreporting.dim_country(id)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_disaster (
    id INT PRIMARY KEY,
    disaster_name VARCHAR(255),
    disaster_subgroup VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_magnitude_scale (
    id INT PRIMARY KEY,
    type VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS dwreporting.fct_disaster_magnitude (
    id INT PRIMARY KEY,
    disaster_id INT REFERENCES dwreporting.dim_disaster(id),
    magnitude_scale_id INT REFERENCES dwreporting.dim_magnitude_scale(id)
);


CREATE TABLE IF NOT EXISTS dwreporting.fct_subregion (
    id INT PRIMARY KEY,
    subregion_id INT REFERENCES dwreporting.dim_subregion(id),
    year INT,
    perc_malnourishment NUMERIC(10,4),
    perc_pop_without_water NUMERIC(10,4),
    population DECIMAL(20, 2)
);

--
CREATE TABLE IF NOT EXISTS dwreporting.fct_country_details (
    id SERIAL PRIMARY KEY,
    country_id INT REFERENCES dwreporting.dim_country(id),
    subregion_id INT REFERENCES dwreporting.fct_subregion(id),
    year INT,
    perc_malnourishment NUMERIC(10,4),
    population DECIMAL(20, 2),     --mush am tezbat l insert
    GDP_per_year NUMERIC(5,4),
    perc_pop_without_water NUMERIC(10,4),
    avg_temp NUMERIC(10,4)

);

--
CREATE TABLE IF NOT EXISTS dwreporting.fct_disasters (
    id SERIAL PRIMARY KEY,
    disaster_id INT REFERENCES dwreporting.dim_disaster(id), --disaster 
    country_id INT REFERENCES dwreporting.dim_country(id),
    city_id INT REFERENCES dwreporting.dim_city(id),--probably mush lah tezbat
    subregion_id INT REFERENCES dwreporting.dim_subregion(id),
    month INT,
    year INT,
    OFDA BOOLEAN,
    magnitude_value VARCHAR(255),
    magnitude_scale_id INT REFERENCES dwreporting.dim_magnitude_scale(id),
    total_affected INT
);