# Racing Club Database Frontend

This is a simple frontend for the `RacingClubDB` MySQL database project.
It supports insert, update, delete, search/filtering, reports, and both required views.

## 1. Install Node.js
Download and install Node.js if it is not already installed.

## 2. Install dependencies
Open a terminal in this folder and run:

```bash
npm install
```

## 3. Create the database in MySQL Workbench
Run these SQL files in this order:

1. `Schema.sql`
2. `triggers.sql`
3. `views.sql`
4. `mockData.sql`

## 4. Add database login settings
Copy `.env.example` and rename it to `.env`.
Then edit the password to match your MySQL Workbench/root password.

Example:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=RacingClubDB
DB_PORT=3306
PORT=3000
```

## 5. Start the frontend
Run:

```bash
npm start
```

Then open:

```text
http://localhost:3000
```

## Demo Checklist
Show these in the project video:

- Database connection status says connected
- Search/refresh drivers
- Insert a new driver, such as `D101`
- Update the driver's ranking or salary
- Sign the driver to a team
- Insert a race result for that driver
- Delete the driver
- Open Team Leaderboard report
- Open Free Agents report
- Open View 1: Race Outcomes
- Open View 2: Track Race History

## AI Usage Statement
ChatGPT was used to assist with creating the frontend structure, backend API routes, and basic debugging support.
