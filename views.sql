-- RacingClubDB - VIEWS

USE RacingClubDB;


-- View 1: Race outcomes
-- Every race with its track and the 1st-place finisher.

DROP VIEW IF EXISTS vw_RaceOutcomes;
CREATE VIEW vw_RaceOutcomes AS
SELECT
    r.raceid,
    r.rname              AS race_name,
    r.race_start,
    r.race_end,
    t.trname             AS track_name,
    t.trcity             AS city,
    t.trcountry          AS country,
    rr.driverid          AS winner_driverid,
    rr.resplace          AS winning_place
FROM Races r
LEFT JOIN Tracks t       ON r.trackid = t.trackid
LEFT JOIN RaceResults rr ON r.raceid  = rr.raceid AND rr.resplace = 1;



-- View 2: Track race history
-- Per-track race count and date range.

DROP VIEW IF EXISTS vw_TrackRaceHistory;
CREATE VIEW vw_TrackRaceHistory AS
SELECT
    t.trackid,
    t.trname             AS track_name,
    t.trcity             AS city,
    t.trcountry          AS country,
    COUNT(r.raceid)      AS total_races,
    MIN(r.race_start)    AS first_race,
    MAX(r.race_start)    AS most_recent_race
FROM Tracks t
LEFT JOIN Races r ON t.trackid = r.trackid
GROUP BY t.trackid, t.trname, t.trcity, t.trcountry;