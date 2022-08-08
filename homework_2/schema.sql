CREATE TABLE "house"(
                        "id" UUID PRIMARY KEY,
                        "place_name" VARCHAR(255) NOT NULL,
                        "address_id" UUID UNIQUE NOT NULL
);

CREATE TABLE "zone"(
                       "id" UUID PRIMARY KEY,
                       "house_id" UUID NOT NULL UNIQUE,
                       "title" VARCHAR(255) NOT NULL,
                       "description" VARCHAR(255)
);

CREATE TABLE "device"(
                         "id" UUID PRIMARY KEY,
                         "type_id" UUID NOT NULL,
                         "title" INTEGER NOT NULL
);

CREATE TABLE "device_type"(
                              "id" UUID PRIMARY KEY,
                              "title" VARCHAR(255) NOT NULL,
                              "description" VARCHAR(255) NOT NULL
);

CREATE TABLE "event"(
                        "id" UUID PRIMARY KEY,
                        "device_id" UUID NOT NULL UNIQUE,
                        "msg" JSONB NOT NULL,
                        "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE "zone_events_link"(
                                   "event_id" UUID PRIMARY KEY,
                                   "zone_id" UUID NOT NULL
);
ALTER TABLE
    "zone" ADD CONSTRAINT "zone_house_id_foreign" FOREIGN KEY("house_id") REFERENCES "house"("id");
ALTER TABLE
    "zone_events_link" ADD CONSTRAINT "zone_events_link_zone_id_foreign" FOREIGN KEY("zone_id") REFERENCES "zone"("id");
ALTER TABLE
    "device" ADD CONSTRAINT "device_type_id_foreign" FOREIGN KEY("type_id") REFERENCES "device_type"("id");
ALTER TABLE
    "event" ADD CONSTRAINT "event_device_id_foreign" FOREIGN KEY("device_id") REFERENCES "device"("id");



