-- ============================================================
-- RacingClubDB - TRIGGERS
-- ============================================================

USE RacingClubDB;

DELIMITER $$

-- 1) Cascading update: when a race result is recorded, automatically
--    update the driver's win/loss counters.  1st place = win, else loss.
DROP TRIGGER IF EXISTS trg_raceresults_after_insert$$
CREATE TRIGGER trg_raceresults_after_insert
AFTER INSERT ON RaceResults
FOR EACH ROW
BEGIN
    IF NEW.resplace = 1 THEN
        UPDATE Drivers SET dwins   = IFNULL(dwins, 0)   + 1 WHERE driverid = NEW.driverid;
    ELSE
        UPDATE Drivers SET dlosses = IFNULL(dlosses, 0) + 1 WHERE driverid = NEW.driverid;
    END IF;
END$$

-- 2) Validation: reject contracts where end_date is before start_date.
DROP TRIGGER IF EXISTS trg_contracts_before_insert$$
CREATE TRIGGER trg_contracts_before_insert
BEFORE INSERT ON Contracts
FOR EACH ROW
BEGIN
    IF NEW.end_date IS NOT NULL AND NEW.end_date < NEW.start_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Contract end_date cannot be before start_date.';
    END IF;
END$$

-- 3) Validation: reject race results where the place value is invalid (< 1).
DROP TRIGGER IF EXISTS trg_raceresults_before_insert$$
CREATE TRIGGER trg_raceresults_before_insert
BEFORE INSERT ON RaceResults
FOR EACH ROW
BEGIN
    IF NEW.resplace < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'resplace must be >= 1.';
    END IF;
END$$

DELIMITER ;