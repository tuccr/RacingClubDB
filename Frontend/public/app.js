async function api(path, options) {
    const response = await fetch(path, options);
    const data = await response.json();
    if (!response.ok) {
        throw new Error(data.error || "Request failed");
    }
    return data;
}

function showMessage(text) {
    const box = document.getElementById("message");
    box.textContent = text;
    box.style.display = "block";
    setTimeout(function() {
        box.style.display = "none";
    }, 3500);
}

function money(value) {
    if (value === null || value === undefined) {
        return "";
    }
    return "$" + Number(value).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

async function checkHealth() {
    const status = document.getElementById("status");
    try {
        await api("/api/health");
        status.textContent = "Database connected";
        status.style.background = "#15803d";
    } catch (error) {
        status.textContent = "Database not connected: " + error.message;
        status.style.background = "#b91c1c";
    }
}

async function loadDrivers() {
    try {
        const search = document.getElementById("searchDriver").value;
        const rows = await api("/api/drivers?search=" + encodeURIComponent(search));
        const table = document.getElementById("driversTable");
        table.innerHTML = "";

        rows.forEach(function(driver) {
            const tr = document.createElement("tr");
            tr.innerHTML =
                "<td>" + driver.driverid + "</td>" +
                "<td><input type='number' value='" + driver.ranking + "' id='rank-" + driver.driverid + "'></td>" +
                "<td><input type='number' step='0.01' value='" + driver.salary + "' id='salary-" + driver.driverid + "'></td>" +
                "<td><input type='number' value='" + driver.dwins + "' id='wins-" + driver.driverid + "'></td>" +
                "<td><input type='number' value='" + driver.dlosses + "' id='losses-" + driver.driverid + "'></td>" +
                "<td>" +
                    "<button class='small' onclick=\"updateDriver('" + driver.driverid + "')\">Update</button> " +
                    "<button class='small delete' onclick=\"deleteDriver('" + driver.driverid + "')\">Delete</button>" +
                "</td>";
            table.appendChild(tr);
        });
    } catch (error) {
        showMessage(error.message);
    }
}

async function updateDriver(id) {
    try {
        const body = {
            ranking: document.getElementById("rank-" + id).value,
            salary: document.getElementById("salary-" + id).value,
            dwins: document.getElementById("wins-" + id).value,
            dlosses: document.getElementById("losses-" + id).value
        };
        const result = await api("/api/drivers/" + id, {
            method: "PUT",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(body)
        });
        showMessage(result.message);
        loadDrivers();
    } catch (error) {
        showMessage(error.message);
    }
}

async function deleteDriver(id) {
    if (!confirm("Delete driver " + id + " and related contract/race records?")) {
        return;
    }
    try {
        const result = await api("/api/drivers/" + id, { method: "DELETE" });
        showMessage(result.message);
        loadDrivers();
    } catch (error) {
        showMessage(error.message);
    }
}

function objectToTable(rows, tableId) {
    const table = document.getElementById(tableId);
    table.innerHTML = "";

    if (!rows || rows.length === 0) {
        table.innerHTML = "<tr><td>No results found</td></tr>";
        return;
    }

    const keys = Object.keys(rows[0]);
    const thead = document.createElement("thead");
    const headRow = document.createElement("tr");

    keys.forEach(function(key) {
        const th = document.createElement("th");
        th.textContent = key;
        headRow.appendChild(th);
    });

    thead.appendChild(headRow);
    table.appendChild(thead);

    const tbody = document.createElement("tbody");
    rows.forEach(function(row) {
        const tr = document.createElement("tr");
        keys.forEach(function(key) {
            const td = document.createElement("td");
            if (key.toLowerCase().includes("salary") || key.toLowerCase().includes("payroll")) {
                td.textContent = money(row[key]);
            } else {
                td.textContent = row[key] === null ? "" : row[key];
            }
            tr.appendChild(td);
        });
        tbody.appendChild(tr);
    });
    table.appendChild(tbody);
}

async function loadEndpoint(path, titleId, tableId, title) {
    try {
        const rows = await api(path);
        document.getElementById(titleId).textContent = title;
        objectToTable(rows, tableId);
    } catch (error) {
        showMessage(error.message);
    }
}

async function loadDropdowns() {
    try {
        const teams = await api("/api/teams");
        const teamSelect = document.getElementById("teamSelect");
        teamSelect.innerHTML = "";
        teams.forEach(function(team) {
            const option = document.createElement("option");
            option.value = team.teamid;
            option.textContent = team.teamid + " - " + team.tname;
            teamSelect.appendChild(option);
        });

        const races = await api("/api/races");
        const raceSelect = document.getElementById("raceSelect");
        raceSelect.innerHTML = "";
        races.forEach(function(race) {
            const option = document.createElement("option");
            option.value = race.raceid;
            option.textContent = race.raceid + " - " + race.rname;
            raceSelect.appendChild(option);
        });
    } catch (error) {
        showMessage(error.message);
    }
}

document.getElementById("driverForm").addEventListener("submit", async function(event) {
    event.preventDefault();
    try {
        const form = new FormData(event.target);
        const body = Object.fromEntries(form.entries());
        const result = await api("/api/drivers", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(body)
        });
        showMessage(result.message);
        event.target.reset();
        loadDrivers();
    } catch (error) {
        showMessage(error.message);
    }
});

document.getElementById("contractForm").addEventListener("submit", async function(event) {
    event.preventDefault();
    try {
        const form = new FormData(event.target);
        const body = Object.fromEntries(form.entries());
        const result = await api("/api/contracts", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(body)
        });
        showMessage(result.message);
        event.target.reset();
    } catch (error) {
        showMessage(error.message);
    }
});

document.getElementById("raceResultForm").addEventListener("submit", async function(event) {
    event.preventDefault();
    try {
        const form = new FormData(event.target);
        const body = Object.fromEntries(form.entries());
        const result = await api("/api/race-results", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(body)
        });
        showMessage(result.message);
        event.target.reset();
        loadDrivers();
    } catch (error) {
        showMessage(error.message);
    }
});

checkHealth();
loadDropdowns();
loadDrivers();
