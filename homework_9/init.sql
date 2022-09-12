CREATE USER IF NOT EXISTS 'creator'@'%' IDENTIFIED BY 'password';
CREATE USER IF NOT EXISTS 'reader'@'%' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON *.* TO 'creator'@'%' WITH GRANT OPTION;

CREATE DATABASE IF NOT EXISTS sensors;
USE sensors;


CREATE TABLE IF NOT EXISTS sensors.house
(
    id         INT AUTO_INCREMENT primary key,
    place_name VARCHAR(255) NOT NULL,
    address_id INT          NOT NULL
);


ALTER TABLE sensors.house
    ADD INDEX (id);

CREATE TABLE IF NOT EXISTS sensors.zone
(
    id          INT AUTO_INCREMENT primary key,
    house_id    INT          NOT NULL,
    title       VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL
);

ALTER TABLE zone
    ADD INDEX (id);

CREATE TABLE IF NOT EXISTS sensors.device
(
    id      INT AUTO_INCREMENT primary key,
    zone_id INT          NOT NULL,
    type_id INT          NOT NULL,
    title   VARCHAR(255) NOT NULL
);

ALTER TABLE device
    ADD INDEX (id);

CREATE TABLE IF NOT EXISTS sensors.device_type
(
    id          INT AUTO_INCREMENT primary key,
    title       VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS sensors.event
(
    id            INT AUTO_INCREMENT primary key,
    event_type_id INT          NOT NULL,
    zone_id       INT          NOT NULL,
    device_id     INT          NOT NULL,
    msg           JSON         NOT NULL,
    created_at    TIMESTAMP(0) NOT NULL
);

ALTER TABLE event
    ADD INDEX (id, device_id);

CREATE TABLE IF NOT EXISTS sensors.user
(
    id       INT AUTO_INCREMENT primary key,
    name     VARCHAR(255) NOT NULL,
    house_id INT          NOT NULL
);


CREATE TABLE IF NOT EXISTS sensors.address
(
    id      INT AUTO_INCREMENT primary key,
    country VARCHAR(255) NOT NULL,
    city    VARCHAR(255) NOT NULL,
    street  VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS sensors.critical_event
(
    event_id      INT NOT NULL UNIQUE,
    event_type_id INT NOT NULL
);


CREATE TABLE IF NOT EXISTS sensors.event_type
(
    id          INT AUTO_INCREMENT primary key,
    type        VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL
);



ALTER TABLE
    sensors.zone
    ADD FOREIGN KEY (house_id) REFERENCES sensors.house (id);

ALTER TABLE
    sensors.device
    ADD FOREIGN KEY (type_id) REFERENCES sensors.device_type (id);


ALTER TABLE
    sensors.device
    ADD FOREIGN KEY (zone_id) REFERENCES sensors.zone (id);


ALTER TABLE
    sensors.event
    ADD FOREIGN KEY (device_id) REFERENCES sensors.device (id);

ALTER TABLE
    sensors.event
    ADD FOREIGN KEY (zone_id) REFERENCES sensors.zone (id);


ALTER TABLE
    sensors.event
    ADD FOREIGN KEY (event_type_id) REFERENCES sensors.event_type (id);



ALTER TABLE
    sensors.user
    ADD FOREIGN KEY (house_id) REFERENCES sensors.house (id);


ALTER TABLE
    sensors.house
    ADD FOREIGN KEY (address_id) REFERENCES sensors.address (id);


ALTER TABLE
    sensors.critical_event
    ADD FOREIGN KEY (event_type_id) REFERENCES sensors.event_type (id);
