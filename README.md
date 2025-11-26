# Flyway Migrations Learning Project (Improved Documentation)

A clean, structured, and beginner-friendly guide for learning **Flyway
database migrations** using **Spring Boot**, **Kotlin**, and
**PostgreSQL**.\
This project emphasizes migration discipline, schema organization, and a
smooth local development workflow using Docker.

------------------------------------------------------------------------

## 🚀 Overview

This learning project demonstrates how to:

-   Use **versioned**, **repeatable**, and **undo** Flyway migrations\
-   Organize migrations in a clean folder structure\
-   Develop inside isolated containers or local mode\
-   Work with a **custom schema** (`dime`)\
-   Query database metadata through a simple API\
-   Enforce **strict commit message rules** and PR workflow\
-   Start/stop the DB or full stack using Gradle tasks

------------------------------------------------------------------------

## 📁 Project Structure

    .
    ├── docker/
    │   ├── Dockerfile
    │   ├── docker-compose.db.yml
    │   └── docker-compose.dev.yml
    ├── src/
    │   ├── main/
    │   │   ├── kotlin/
    │   │   │   └── learning/flyway/actual_application/controller/
    │   │   │       └── PublicController.kt
    │   │   └── resources/
    │   │       ├── application.properties
    │   │       └── db/
    │   │           ├── migration/
    │   │           │   ├── versioned/
    │   │           ├── repeatable/
    │   │           └── undo/
    ├── build.gradle.kts
    └── README.md

------------------------------------------------------------------------

## 🧭 Flyway Migration Types

### ✅ **Versioned Migrations** (`V{version}__description.sql`)

Location: `db/migration/versioned/`\
Run **exactly once**, in order.

Use for: - Creating/altering tables - Adding constraints/indexes -
Inserting reference data

Example:

``` sql
CREATE TABLE dime.users (...);
```

------------------------------------------------------------------------

### ♻️ **Repeatable Migrations** (`R__description.sql`)

Location: `db/migration/repeatable/`\
Executed whenever file checksum changes.

Use for: - Views - Functions - Stored procedures

Example:

``` sql
CREATE OR REPLACE VIEW dime.user_stats AS ...
```

------------------------------------------------------------------------

### ↩️ **Undo Migrations** (`U{version}__description.sql`)

Location: `db/migration/undo/`\
Available only in Flyway Teams but usable manually in learning mode.

Use for: - Experimenting with reversible migrations - Learning rollback
strategies

------------------------------------------------------------------------

## 🗃️ Custom Database Schema

All objects use the schema:

    dime

Example:

``` sql
CREATE TABLE dime.posts (...);
```

------------------------------------------------------------------------

## 🛠️ Development Setup

### 📌 Requirements

-   Docker & Docker Compose\
-   Java **21+**\
-   Kotlin **2.2+**

------------------------------------------------------------------------

## 🔧 Initial Setup

Enable commit message template:

``` bash
git config commit.template .gitmessage
```

------------------------------------------------------------------------

## 📝 Commit Message Format

Your commit must include:

    Subject line (max 50 chars)

    Files changed:(optional)
    * file1
    * file2

    Purpose of the change: (≥50 chars)
    Explain WHY.

    How does it affect the application: (≥50 chars)
    Explain WHAT changes.
    
    Additional note:(optional)

PRs require: - Correct commit format\
- Targeting `develop`\
- CI validation success

------------------------------------------------------------------------

## 🌿 Branch Strategy

Branch        Purpose
  ------------- --------------------
`main`        Production-ready
`develop`     Integration branch
`feature/*`   Work branches

------------------------------------------------------------------------
> Replace ./gradlew with .\gradlew.bat for Windows

## 🐳 Running the Project

### Option 1 --- **Database Only (Learning Mode)**

Start PostgreSQL:

``` bash
./gradlew dbUp
```

Run the app locally:

``` bash
./gradlew bootRun
```

Stop DB:

``` bash
./gradlew dbDown
```

Destroy DB (delete data):

``` bash
./gradlew dbDestroy
```

Open psql:

``` bash
./gradlew dbShell
```

------------------------------------------------------------------------

### Option 2 --- **Full Stack (Spring Boot + DB in Docker)**

Start everything:

``` bash
./gradlew devUp
```

Stop:

``` bash
./gradlew devDown
```

Destroy:

``` bash
./gradlew devDestroy
```

------------------------------------------------------------------------

## 🌐 API Documentation

### List schemas:

    GET /api/public/v1/schemas

### List tables (default schema = dime):

    GET /api/public/v1/tables

### Show table or view:

    GET /api/public/v1/show/{name}

Example:

    GET /api/public/v1/show/user_stats

------------------------------------------------------------------------

## 🧪 Learning Scenarios

### 1️⃣ Fresh Start

``` bash
./gradlew dbDestroy
./gradlew dbUp
./gradlew bootRun
```

### 2️⃣ Add a new migration

Create `V5__add_tags_table.sql` then restart the app.

### 3️⃣ Test repeatable migrations

Modify a `R__*.sql` file → checksum change → auto re-run.

### 4️⃣ Manual rollback

In psql:

``` sql
DROP TABLE dime.comments CASCADE;
DELETE FROM flyway_schema_history WHERE version='3';
```

### 5️⃣ Compare schemas

``` bash
curl /api/public/v1/tables?schema=dime
curl /api/public/v1/tables?schema=public
```

------------------------------------------------------------------------

## 🐘 Database Connection

### Local Mode

    jdbc:postgresql://localhost:5432/flyway_db?currentSchema=dime

### Full Stack Mode

    jdbc:postgresql://localhost:5433/flyway_db?currentSchema=dime

Credentials: - User: `flyway_user` - Pass: `flyway_pass`

------------------------------------------------------------------------

## 🔍 Migration Tips

-   Always include schema names (`dime.table`)\
-   Never modify existing versioned migrations---create new ones\
-   Use repeatables for views\
-   Watch Flyway logs for details\
-   Reset DB often while learning\
-   Foreign keys MUST include schema name\
-   Keep migrations atomic and readable

------------------------------------------------------------------------

## 🧰 Useful psql Commands

``` sql
\dn                 -- list schemas
\dt dime.*          -- list tables
SET search_path TO dime;
SELECT * FROM flyway_schema_history;
```

------------------------------------------------------------------------

## 🛠️ Common Patterns

### Create table

``` sql
CREATE TABLE dime.tags (...);
```

### Add column

``` sql
ALTER TABLE dime.users ADD COLUMN bio TEXT;
```

### Create view

``` sql
CREATE OR REPLACE VIEW dime.post_summary AS ...
```

------------------------------------------------------------------------

## 🧹 Troubleshooting

### Port Already Used

``` bash
lsof -ti:5432 | xargs kill -9
```

### Checksum Mismatch

Recommended: - Create a new migration fixing the old one

Dev only:

``` sql
DELETE FROM flyway_schema_history WHERE version='X';
```

### Reset Everything

``` bash
./gradlew dbDestroy
./gradlew clean
./gradlew dbUp
```

------------------------------------------------------------------------

## 📚 Recommended Learning Path

### Week 1 -- Basics

-   Create schema + tables\
-   Insert sample data\
-   Validate Flyway history\
-   Query API

### Week 2 -- Evolution

-   Add new tables (V3, V4...)\
-   Add repeatable views\
-   Use full-stack mode\
-   Test rollbacks

------------------------------------------------------------------------

Enjoy experimenting with Flyway and contributing! Happy coding!