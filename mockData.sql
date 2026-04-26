-- RacingClubDB - MOCK DATA
-- MockData was created using AI to help with the diversity of the data and also
-- facilitating the testing of our database


USE RacingClubDB;

-- ------------------------------------------------------------
-- DRIVERS  
-- ------------------------------------------------------------
INSERT INTO Drivers (driverid, ranking, salary, dwins, dlosses) VALUES
('D001',  1, 525000.00, 0, 0),
('D002',  2, 480000.00, 0, 0),
('D003',  3, 410000.00, 0, 0),
('D004',  4, 395000.00, 0, 0),
('D005',  5, 360000.00, 0, 0),
('D006',  6, 330000.00, 0, 0),
('D007',  7, 305000.00, 0, 0),
('D008',  8, 285000.00, 0, 0),
('D009',  9, 255000.00, 0, 0),
('D010', 10, 225000.00, 0, 0),
('D011', 11, 200000.00, 0, 0);   -- free agent, no contract

-- ------------------------------------------------------------
-- TEAMS 
-- ------------------------------------------------------------
INSERT INTO Teams (teamid, tname, twins, tlosses, earnings) VALUES
('T01', 'Apex Racing',          3,  7, 1850000.00),
('T02', 'Velocity Motorsports', 2,  6, 1420000.00),
('T03', 'Thunder Bay Racing',   1,  6, 1100000.00),
('T04', 'Redline Racing',       1,  6,  980000.00),
('T05', 'Phoenix Speed Co',     1,  7,  860000.00);

-- ------------------------------------------------------------
-- TRACKS
-- ------------------------------------------------------------
INSERT INTO Tracks (trackid, trcity, trcountry, trstate_prov, trname, trcapacity, open_date) VALUES
('TR01', 'Daytona Beach',  'USA',    'FL',     'Daytona International Speedway', 101500, '1959-02-22'),
('TR02', 'Indianapolis',   'USA',    'IN',     'Indianapolis Motor Speedway',    257000, '1909-08-19'),
('TR03', 'Monte Carlo',    'Monaco', 'Monaco', 'Circuit de Monaco',               37000, '1929-04-14'),
('TR04', 'Silverstone',    'UK',     'England','Silverstone Circuit',            150000, '1948-10-02'),
('TR05', 'Suzuka',         'Japan',  'Mie',    'Suzuka International Racing',    155000, '1962-09-20'),
('TR06', 'Talladega',      'USA',    'AL',     'Talladega Superspeedway',         80000, '1969-09-13');

-- ------------------------------------------------------------
-- VEHICLES 
-- ------------------------------------------------------------
INSERT INTO Vehicles (vid, brand, model, license_num, driverid) VALUES
('V001', 'Ferrari',  'SF-24',         'APX-001', 'D001'),
('V002', 'Mercedes', 'W15',           'VEL-002', 'D002'),
('V003', 'Ferrari',  'SF-24',         'APX-003', 'D003'),
('V004', 'McLaren',  'MCL38',         'TBR-004', 'D004'),
('V005', 'Red Bull', 'RB20',          'RED-005', 'D005'),
('V006', 'Aston Martin', 'AMR24',     'PHX-006', 'D006'),
('V007', 'Mercedes', 'W15',           'VEL-007', 'D007'),
('V008', 'McLaren',  'MCL38',         'TBR-008', 'D008'),
('V009', 'Red Bull', 'RB20',          'RED-009', 'D009'),
('V010', 'Aston Martin', 'AMR24',     'PHX-010', 'D010');

-- ------------------------------------------------------------
-- VEHICLE OWNERSHIP
-- ------------------------------------------------------------
INSERT INTO VehicleOwnership (vid, teamid, own_start_date, own_end_date) VALUES
('V001', 'T03', '2024-01-01', '2025-06-30'),  -- historical
('V001', 'T01', '2025-07-01', NULL),
('V002', 'T02', '2024-01-01', NULL),
('V003', 'T01', '2024-03-15', NULL),
('V004', 'T03', '2025-01-01', NULL),
('V005', 'T04', '2024-06-01', NULL),
('V006', 'T05', '2025-02-15', NULL),
('V007', 'T02', '2025-04-01', NULL),
('V008', 'T03', '2024-09-01', NULL),
('V009', 'T04', '2025-03-01', NULL),
('V010', 'T05', '2024-11-01', NULL);

-- ------------------------------------------------------------
-- RACES
-- ------------------------------------------------------------
INSERT INTO Races (raceid, race_start, race_end, rname, trackid) VALUES
('R001', '2025-03-15 13:00:00', '2025-03-15 16:30:00', 'Daytona 500',           'TR01'),
('R002', '2025-04-20 12:00:00', '2025-04-20 15:00:00', 'Indy Spring Classic',   'TR02'),
('R003', '2025-05-25 14:00:00', '2025-05-25 16:30:00', 'Monaco Grand Prix',     'TR03'),
('R004', '2025-07-12 13:30:00', '2025-07-12 16:00:00', 'British Grand Prix',    'TR04'),
('R005', '2025-09-08 13:00:00', '2025-09-08 15:30:00', 'Japanese Grand Prix',   'TR05'),
('R006', '2025-10-19 13:00:00', '2025-10-19 16:00:00', 'Talladega 500',         'TR06'),
('R007', '2026-02-14 13:00:00', '2026-02-14 16:30:00', 'Daytona Winter Cup',    'TR01'),
('R008', '2026-04-05 12:00:00', '2026-04-05 15:00:00', 'Indy Brickyard 400',    'TR02');

-- ------------------------------------------------------------
-- CONTRACTS  (D011 left out on purpose - free agent)
-- ------------------------------------------------------------
INSERT INTO Contracts (driverid, teamid, start_date, end_date) VALUES
('D001', 'T01', '2024-01-01', NULL),
('D002', 'T02', '2024-01-01', NULL),
('D003', 'T01', '2024-03-15', NULL),
('D004', 'T03', '2025-01-01', NULL),
('D005', 'T04', '2024-06-01', NULL),
('D006', 'T05', '2025-02-15', NULL),
('D007', 'T02', '2025-04-01', NULL),
('D008', 'T03', '2024-09-01', NULL),
('D009', 'T04', '2025-03-01', NULL),
('D010', 'T05', '2024-11-01', NULL);

-- ------------------------------------------------------------
-- RACE RESULTS
-- Triggers will auto-populate Drivers.dwins / Drivers.dlosses.
-- ------------------------------------------------------------
-- R001 - Daytona 500
INSERT INTO RaceResults VALUES ('R001', 'D001', 1);
INSERT INTO RaceResults VALUES ('R001', 'D002', 2);
INSERT INTO RaceResults VALUES ('R001', 'D003', 3);
INSERT INTO RaceResults VALUES ('R001', 'D005', 4);
INSERT INTO RaceResults VALUES ('R001', 'D006', 5);

-- R002 - Indy Spring Classic
INSERT INTO RaceResults VALUES ('R002', 'D002', 1);
INSERT INTO RaceResults VALUES ('R002', 'D001', 2);
INSERT INTO RaceResults VALUES ('R002', 'D004', 3);
INSERT INTO RaceResults VALUES ('R002', 'D007', 4);
INSERT INTO RaceResults VALUES ('R002', 'D008', 5);

-- R003 - Monaco Grand Prix
INSERT INTO RaceResults VALUES ('R003', 'D001', 1);
INSERT INTO RaceResults VALUES ('R003', 'D003', 2);
INSERT INTO RaceResults VALUES ('R003', 'D005', 3);
INSERT INTO RaceResults VALUES ('R003', 'D009', 4);
INSERT INTO RaceResults VALUES ('R003', 'D010', 5);

-- R004 - British Grand Prix
INSERT INTO RaceResults VALUES ('R004', 'D004', 1);
INSERT INTO RaceResults VALUES ('R004', 'D006', 2);
INSERT INTO RaceResults VALUES ('R004', 'D008', 3);
INSERT INTO RaceResults VALUES ('R004', 'D002', 4);
INSERT INTO RaceResults VALUES ('R004', 'D001', 5);

-- R005 - Japanese Grand Prix
INSERT INTO RaceResults VALUES ('R005', 'D005', 1);
INSERT INTO RaceResults VALUES ('R005', 'D007', 2);
INSERT INTO RaceResults VALUES ('R005', 'D009', 3);
INSERT INTO RaceResults VALUES ('R005', 'D003', 4);
INSERT INTO RaceResults VALUES ('R005', 'D004', 5);

-- R006 - Talladega 500
INSERT INTO RaceResults VALUES ('R006', 'D001', 1);
INSERT INTO RaceResults VALUES ('R006', 'D006', 2);
INSERT INTO RaceResults VALUES ('R006', 'D010', 3);
INSERT INTO RaceResults VALUES ('R006', 'D008', 4);
INSERT INTO RaceResults VALUES ('R006', 'D002', 5);

-- R007 - Daytona Winter Cup
INSERT INTO RaceResults VALUES ('R007', 'D002', 1);
INSERT INTO RaceResults VALUES ('R007', 'D003', 2);
INSERT INTO RaceResults VALUES ('R007', 'D006', 3);
INSERT INTO RaceResults VALUES ('R007', 'D008', 4);
INSERT INTO RaceResults VALUES ('R007', 'D010', 5);

-- R008 - Indy Brickyard 400
INSERT INTO RaceResults VALUES ('R008', 'D006', 1);
INSERT INTO RaceResults VALUES ('R008', 'D001', 2);
INSERT INTO RaceResults VALUES ('R008', 'D005', 3);
INSERT INTO RaceResults VALUES ('R008', 'D007', 4);
INSERT INTO RaceResults VALUES ('R008', 'D009', 5);