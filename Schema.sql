-- Active: 1774295241483@@127.0.0.1@3306@mysql
CREATE DATABASE RacingClubDB;
USE RacingClubDB;

-- TABLES

CREATE TABLE Drivers (
    driverid VARCHAR(25) PRIMARY KEY,
    ranking INT,
    salary REAL,
    dwins INT,
    dlosses INT
);

CREATE TABLE Teams (
    teamid VARCHAR(25) PRIMARY KEY,
    tname VARCHAR(255),
    twins INT,
    tlosses INT,
    earnings REAL 
);
-- might remove earnings

CREATE TABLE Vehicles (
    vid VARCHAR(25) PRIMARY KEY,
    brand VARCHAR(255),
    model VARCHAR(255),
    license_num VARCHAR(255),
    driverid VARCHAR(25),
    FOREIGN KEY (driverid) REFERENCES Drivers(driverid)
);

CREATE TABLE VehicleOwnership (
    vid VARCHAR(25),
    teamid VARCHAR(25),
    own_start_date DATE,
    own_end_date DATE,
    PRIMARY KEY (vid, teamid),
    FOREIGN KEY (vid) REFERENCES Vehicles(vid),
    FOREIGN KEY (teamid) REFERENCES Teams(teamid)
);
-- might remove table, might set an fkey in Vehicles for ownership instead
-- start and end date in case trading between teams, own_end_date can be left NULL but own_start_date should not

CREATE TABLE Tracks (
    trackid VARCHAR(25) PRIMARY KEY,
    trcity VARCHAR(128),
    trcountry VARCHAR(128),
    trstate_prov VARCHAR(128),
    trname VARCHAR(255),
    trcapacity INT,
    open_date DATE
);
-- might remove open_date

CREATE TABLE Races (
    raceid VARCHAR(25) PRIMARY KEY,
    race_start DATETIME,
    race_end DATETIME,
    rname VARCHAR(255),
    trackid VARCHAR(25),
    FOREIGN KEY (trackid) REFERENCES Tracks(trackid)
);

CREATE TABLE RaceResults (
    raceid VARCHAR(25),
    driverid VARCHAR(25),
    resplace INT,
    PRIMARY KEY (raceid, driverid),
    FOREIGN KEY (raceid) REFERENCES Races(raceid),
    FOREIGN KEY (driverid) REFERENCES Drivers(driverid)
);

CREATE TABLE Contracts (
    driverid VARCHAR(25), 
    teamid VARCHAR(25),
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (driverid, teamid),
    FOREIGN KEY (driverid) REFERENCES Drivers(driverid),
    FOREIGN KEY (teamid) REFERENCES Teams(teamid)
);

-- TRIGGERS, VIEWS, CURSORS, ETC.
-- required to have at least 2 views representing summaries or reports (probably one for race outcomes and another for a track's race history)

-- MOCKDATA