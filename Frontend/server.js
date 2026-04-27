const express = require("express");
const cors = require("cors");
const path = require("path");
const mysql = require("mysql2/promise");
require("dotenv").config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

const pool = mysql.createPool({
    host: process.env.DB_HOST || "localhost",
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD || "",
    database: process.env.DB_NAME || "RacingClubDB",
    port: process.env.DB_PORT || 3306,
    waitForConnections: true,
    connectionLimit: 10
});

function sendError(res, error) {
    console.error(error);
    res.status(500).json({ error: error.sqlMessage || error.message || "Database error" });
}

app.get("/api/health", async function(req, res) {
    try {
        await pool.query("SELECT 1");
        res.json({ status: "connected" });
    } catch (error) {
        sendError(res, error);
    }
});

app.get("/api/drivers", async function(req, res) {
    try {
        const search = req.query.search || "";
        const sql = "SELECT driverid, ranking, salary, dwins, dlosses FROM Drivers WHERE driverid LIKE ? ORDER BY ranking";
        const [rows] = await pool.query(sql, ["%" + search + "%"]);
        res.json(rows);
    } catch (error) {
        sendError(res, error);
    }
});

app.post("/api/drivers", async function(req, res) {
    try {
        const body = req.body;
        const sql = "INSERT INTO Drivers (driverid, ranking, salary, dwins, dlosses) VALUES (?, ?, ?, ?, ?)";
        await pool.query(sql, [body.driverid, body.ranking, body.salary, body.dwins || 0, body.dlosses || 0]);
        res.json({ message: "Driver inserted successfully" });
    } catch (error) {
        sendError(res, error);
    }
});

app.put("/api/drivers/:id", async function(req, res) {
    try {
        const body = req.body;
        const sql = "UPDATE Drivers SET ranking = ?, salary = ?, dwins = ?, dlosses = ? WHERE driverid = ?";
        await pool.query(sql, [body.ranking, body.salary, body.dwins, body.dlosses, req.params.id]);
        res.json({ message: "Driver updated successfully" });
    } catch (error) {
        sendError(res, error);
    }
});

app.delete("/api/drivers/:id", async function(req, res) {
    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();
        await conn.query("DELETE FROM RaceResults WHERE driverid = ?", [req.params.id]);
        await conn.query("DELETE FROM Contracts WHERE driverid = ?", [req.params.id]);
        await conn.query("DELETE FROM Vehicles WHERE driverid = ?", [req.params.id]);
        await conn.query("DELETE FROM Drivers WHERE driverid = ?", [req.params.id]);
        await conn.commit();
        res.json({ message: "Driver and related records deleted successfully" });
    } catch (error) {
        await conn.rollback();
        sendError(res, error);
    } finally {
        conn.release();
    }
});

app.get("/api/teams", async function(req, res) {
    try {
        const [rows] = await pool.query("SELECT teamid, tname FROM Teams ORDER BY tname");
        res.json(rows);
    } catch (error) {
        sendError(res, error);
    }
});

app.get("/api/races", async function(req, res) {
    try {
        const [rows] = await pool.query("SELECT raceid, rname FROM Races ORDER BY race_start DESC");
        res.json(rows);
    } catch (error) {
        sendError(res, error);
    }
});

app.post("/api/contracts", async function(req, res) {
    try {
        const body = req.body;
        const sql = "INSERT INTO Contracts (driverid, teamid, start_date, end_date) VALUES (?, ?, ?, ?)";
        await pool.query(sql, [body.driverid, body.teamid, body.start_date, body.end_date || null]);
        res.json({ message: "Contract inserted successfully" });
    } catch (error) {
        sendError(res, error);
    }
});

app.post("/api/race-results", async function(req, res) {
    try {
        const body = req.body;
        const sql = "INSERT INTO RaceResults (raceid, driverid, resplace) VALUES (?, ?, ?)";
        await pool.query(sql, [body.raceid, body.driverid, body.resplace]);
        res.json({ message: "Race result inserted successfully. Trigger updates driver stats." });
    } catch (error) {
        sendError(res, error);
    }
});

app.get("/api/report/team-leaderboard", async function(req, res) {
    try {
        const sql = `
            SELECT tm.teamid, tm.tname, tm.twins, tm.tlosses,
                   ROUND(tm.twins / NULLIF(tm.twins + tm.tlosses, 0) * 100, 2) AS win_pct,
                   SUM(d.salary) AS total_payroll
            FROM Teams tm
            LEFT JOIN Contracts c ON tm.teamid = c.teamid
                 AND (c.end_date IS NULL OR c.end_date >= CURDATE())
            LEFT JOIN Drivers d ON c.driverid = d.driverid
            GROUP BY tm.teamid, tm.tname, tm.twins, tm.tlosses
            ORDER BY win_pct DESC`;
        const [rows] = await pool.query(sql);
        res.json(rows);
    } catch (error) {
        sendError(res, error);
    }
});

app.get("/api/report/free-agents", async function(req, res) {
    try {
        const sql = `
            SELECT d.driverid, d.ranking, d.salary
            FROM Drivers d
            LEFT JOIN Contracts c ON d.driverid = c.driverid
                 AND (c.end_date IS NULL OR c.end_date >= CURDATE())
            WHERE c.driverid IS NULL
            ORDER BY d.ranking`;
        const [rows] = await pool.query(sql);
        res.json(rows);
    } catch (error) {
        sendError(res, error);
    }
});

app.get("/api/views/race-outcomes", async function(req, res) {
    try {
        const [rows] = await pool.query("SELECT * FROM vw_RaceOutcomes ORDER BY race_start DESC");
        res.json(rows);
    } catch (error) {
        sendError(res, error);
    }
});

app.get("/api/views/track-history", async function(req, res) {
    try {
        const [rows] = await pool.query("SELECT * FROM vw_TrackRaceHistory ORDER BY total_races DESC");
        res.json(rows);
    } catch (error) {
        sendError(res, error);
    }
});

app.listen(port, function() {
    console.log("Racing Club frontend running at http://localhost:" + port);
});
