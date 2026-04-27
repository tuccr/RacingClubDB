-- 
-- RacingClubDB - queries

USE RacingClubDB;

-- INSERT examples

-- Add a new driver
INSERT INTO Drivers (driverid, ranking, salary, dwins, dlosses)
VALUES ('D101', 12, 250000.00, 0, 0);

-- Sign that driver to a team
INSERT INTO Contracts (driverid, teamid, start_date, end_date)
VALUES ('D101', 'T01', '2026-01-01', NULL);

-- Record a race result (the triggers will auto-update Drivers + Teams stats)
INSERT INTO RaceResults (raceid, driverid, resplace)
VALUES ('R005', 'D101', 1);


-- UPDATE examples

-- Give a driver a raise
UPDATE Drivers
SET salary = salary * 1.10
WHERE driverid = 'D101';

-- Correct a finishing place (triggers cascade the win/loss adjustment)
UPDATE RaceResults
SET resplace = 2
WHERE raceid = 'R005' AND driverid = 'D101';

-- Close out an existing contract
UPDATE Contracts
SET end_date = '2026-06-30'
WHERE driverid = 'D101' AND teamid = 'T01';


-- DELETE examples

-- Remove a race result (triggers roll back driver + team counters)
DELETE FROM RaceResults
WHERE raceid = 'R005' AND driverid = 'D101';

-- Remove a driver only after their contract is closed (trigger enforces this)
DELETE FROM Drivers
WHERE driverid = 'D101';


-- SEARCH examples

-- All drivers currently signed to a specific team
SELECT d.driverid, d.ranking, d.salary, c.start_date
FROM Drivers d
JOIN Contracts c ON d.driverid = c.driverid
WHERE c.teamid = 'T01'
  AND (c.end_date IS NULL OR c.end_date >= CURDATE());

-- All races held in a specific country
SELECT r.raceid, r.rname, r.race_start, t.trname, t.trcity
FROM Races r
JOIN Tracks t ON r.trackid = t.trackid
WHERE t.trcountry = 'USA'
ORDER BY r.race_start DESC;

-- All vehicles currently driven by a specific driver
SELECT v.vid, v.brand, v.model, v.license_num
FROM Vehicles v
WHERE v.driverid = 'D101';

-- Drivers with a win rate above 50%
SELECT driverid, dwins, dlosses,
       ROUND(dwins / NULLIF(dwins + dlosses, 0) * 100, 2) AS win_pct
FROM Drivers
WHERE (dwins + dlosses) > 0
  AND (dwins / (dwins + dlosses)) > 0.5
ORDER BY win_pct DESC;



-- Top 5 drivers by total wins
SELECT driverid, dwins, dlosses
FROM Drivers
ORDER BY dwins DESC
LIMIT 5;

-- Team leaderboard - wins, losses, win %, total payroll
SELECT
    tm.teamid,
    tm.tname,
    tm.twins,
    tm.tlosses,
    ROUND(tm.twins / NULLIF(tm.twins + tm.tlosses, 0) * 100, 2) AS win_pct,
    SUM(d.salary) AS total_payroll
FROM Teams tm
LEFT JOIN Contracts c
       ON tm.teamid = c.teamid
      AND (c.end_date IS NULL OR c.end_date >= CURDATE())
LEFT JOIN Drivers d ON c.driverid = d.driverid
GROUP BY tm.teamid, tm.tname, tm.twins, tm.tlosses
ORDER BY win_pct DESC;

-- Most-used tracks (by race count) with average capacity
SELECT
    t.trackid,
    t.trname,
    t.trcity,
    t.trcapacity,
    COUNT(r.raceid) AS races_held
FROM Tracks t
LEFT JOIN Races r ON t.trackid = r.trackid
GROUP BY t.trackid, t.trname, t.trcity, t.trcapacity
ORDER BY races_held DESC;

-- Race winners report - driver, team at the time, track, date
SELECT
    r.raceid,
    r.rname               AS race_name,
    DATE(r.race_start)    AS race_date,
    t.trname              AS track,
    rr.driverid           AS winner,
    c.teamid              AS team_at_time
FROM RaceResults rr
JOIN Races r              ON rr.raceid = r.raceid
JOIN Tracks t             ON r.trackid = t.trackid
LEFT JOIN Contracts c     ON c.driverid = rr.driverid
                         AND c.start_date <= DATE(r.race_start)
                         AND (c.end_date IS NULL OR c.end_date >= DATE(r.race_start))
WHERE rr.resplace = 1
ORDER BY r.race_start DESC;

-- Free agents - drivers with no active contract
SELECT d.driverid, d.ranking, d.salary
FROM Drivers d
LEFT JOIN Contracts c
       ON d.driverid = c.driverid
      AND (c.end_date IS NULL OR c.end_date >= CURDATE())
WHERE c.driverid IS NULL;

-- Per-driver, per-track performance breakdown
SELECT
    rr.driverid,
    t.trname,
    COUNT(*)                                      AS races_run,
    SUM(CASE WHEN rr.resplace = 1 THEN 1 ELSE 0 END) AS wins,
    ROUND(AVG(rr.resplace), 2)                    AS avg_finish
FROM RaceResults rr
JOIN Races r  ON rr.raceid = r.raceid
JOIN Tracks t ON r.trackid = t.trackid
GROUP BY rr.driverid, t.trname
ORDER BY rr.driverid, wins DESC;