CREATE SCHEMA IF NOT EXISTS sensors AUTHORIZATION creator;

CREATE TABLE IF NOT EXISTS sensors.house(
                        "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                        "place_name" VARCHAR(255) NOT NULL,
                        "address_id" INTEGER NOT NULL UNIQUE
);

CREATE INDEX IF NOT EXISTS house_id_index ON
    sensors.house("id");

CREATE TABLE IF NOT EXISTS sensors.zone(
                       "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                       "house_id" INTEGER NOT NULL,
                       "title" VARCHAR(255) NOT NULL,
                       "description" VARCHAR(255) NOT NULL
);

CREATE INDEX IF NOT EXISTS zone_id_index ON
    sensors.zone("id");


CREATE TABLE IF NOT EXISTS sensors.device(
                         "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                         "zone_id" INTEGER NOT NULL,
                         "type_id" INTEGER NOT NULL,
                         "title" VARCHAR(255) NOT NULL
);

CREATE INDEX IF NOT EXISTS device_id_index ON
    sensors.device("id");

CREATE TABLE IF NOT EXISTS sensors.device_type(
                              "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                              "title" VARCHAR(255) NOT NULL,
                              "description" VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS sensors.event(
                        "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                        "event_type_id" INTEGER NOT NULL,
                        "zone_id" INTEGER NOT NULL,
                        "device_id" INTEGER NOT NULL,
                        "msg" JSON NOT NULL,
                        "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
CREATE INDEX IF NOT EXISTS event_id_device_id_index ON
    sensors.event("id", "device_id");


CREATE TABLE IF NOT EXISTS sensors.user(
                       "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                       "name" VARCHAR(255) NOT NULL,
                       "house_id" INTEGER NOT NULL
);


CREATE TABLE IF NOT EXISTS sensors.address(
                          "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                          "country" VARCHAR(255) NOT NULL,
                          "city" VARCHAR(255) NOT NULL,
                          "street" VARCHAR(255) NOT NULL
                        -- ,"point_on_map" geography(POINT, 4326) NOT NULL //TODO NEED EXTENSION
);

CREATE TABLE IF NOT EXISTS sensors.critical_event(
                                 "event_id" INTEGER NOT NULL UNIQUE,
                                 "event_type_id" INTEGER NOT NULL
);


CREATE TABLE IF NOT EXISTS sensors.event_type(
                             "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                             "type" VARCHAR(255) NOT NULL UNIQUE,
                             "description" VARCHAR(255) NOT NULL
);








ALTER TABLE sensors.zone DROP CONSTRAINT IF EXISTS "zone_house_id_foreign";
ALTER TABLE
    sensors.zone ADD CONSTRAINT "zone_house_id_foreign" FOREIGN KEY("house_id") REFERENCES sensors.house("id");

ALTER TABLE sensors.device DROP CONSTRAINT IF EXISTS "device_type_id_foreign";
ALTER TABLE
    sensors.device ADD CONSTRAINT "device_type_id_foreign" FOREIGN KEY("type_id") REFERENCES sensors.device_type("id");

ALTER TABLE sensors.device DROP CONSTRAINT IF EXISTS "device_zone_id_foreign";

ALTER TABLE
    sensors.device ADD CONSTRAINT "device_zone_id_foreign" FOREIGN KEY("zone_id") REFERENCES sensors.zone("id");

ALTER TABLE sensors.event DROP CONSTRAINT IF EXISTS "event_device_id_foreign";

ALTER TABLE
    sensors.event ADD CONSTRAINT "event_device_id_foreign" FOREIGN KEY("device_id") REFERENCES sensors.device("id");

ALTER TABLE sensors.event DROP CONSTRAINT IF EXISTS "event_zone_id_foreign";

ALTER TABLE
    sensors.event ADD CONSTRAINT "event_zone_id_foreign" FOREIGN KEY("zone_id") REFERENCES sensors.zone("id");

ALTER TABLE sensors.event DROP CONSTRAINT IF EXISTS "event_event_type_id_foreign";

ALTER TABLE
    sensors.event ADD CONSTRAINT "event_event_type_id_foreign" FOREIGN KEY("event_type_id") REFERENCES sensors.event_type("id");

ALTER TABLE sensors.event DROP CONSTRAINT IF EXISTS "user_house_id_foreign";

ALTER TABLE
    sensors.user ADD CONSTRAINT "user_house_id_foreign" FOREIGN KEY("house_id") REFERENCES sensors.house("id");

ALTER TABLE sensors.event DROP CONSTRAINT IF EXISTS "house_address_id_foreign";

ALTER TABLE
    sensors.house ADD CONSTRAINT "house_address_id_foreign" FOREIGN KEY("address_id") REFERENCES sensors.address("id");

ALTER TABLE sensors.event DROP CONSTRAINT IF EXISTS "critical_event_event_type_id_foreign";

ALTER TABLE
    sensors.critical_event ADD CONSTRAINT "critical_event_event_type_id_foreign" FOREIGN KEY("event_type_id") REFERENCES sensors.event_type("id");