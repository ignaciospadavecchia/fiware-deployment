
-- Create the schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS pamplona;

-- Create the table for parking spot data
CREATE TABLE pamplona.parkings_parkingspot_parking_spot_001_parkingspot (
    recvTime TIMESTAMP,
    fiwareServicePath TEXT,
    entityId TEXT,
    entityType TEXT,
    length FLOAT,
    length_md TEXT,
    width FLOAT,
    width_md TEXT,
    category TEXT,
    category_md TEXT,
    TimeInstant TIMESTAMP,
    TimeInstant_md TEXT,
    status TEXT,
    status_md TEXT
);