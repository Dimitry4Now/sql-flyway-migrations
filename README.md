# Flyway migrations, learned by doing

A small Spring Boot and Kotlin app I built to learn Flyway: how versioned and repeatable migrations work, how a schema grows one script at a time, and what happens when you change a script that has already run. The database is PostgreSQL in Docker, and a tiny API lets you look at what the migrations created.

## How the migrations are organised

Everything lives in its own schema, `dime`, and every script names it (`dime.users`, not `users`).

- **Versioned** (`db/migration/versioned/V1__init_schema.sql` and on) run once each, in order: tables, constraints, seed data. Once one has run, it's never edited again; a change is a new script with the next number. The next one here would be `V7__...`.
- **Repeatable** (`db/migration/repeatable/R__refresh_user_stats_view.sql`) run again whenever the file changes, which suits views and functions.
- **Undo** (`db/migration/undo/U3__undo_comments_table.sql`) is kept as an example only. Undo migrations need Flyway's paid Teams edition, so the free one would skip it, and the app doesn't scan that folder. Rolling back by hand is described below.

Flyway records what it ran in `public.flyway_schema_history`.

## Running it

You need Docker and Java 21. Gradle and Kotlin come with the project (`gradlew`; on Windows use `gradlew.bat`).

The usual way is to run only the database in Docker and the app from your machine:

```bash
./gradlew dbUp        # PostgreSQL on localhost:5432
./gradlew bootRun     # the app on localhost:8080; migrations run on start
./gradlew dbShell     # psql, if you want to look around
./gradlew dbDown      # stop it, keeping the data
./gradlew dbDestroy   # stop it and delete the data, for a fresh start
```

Or run both in Docker with `./gradlew devUp` (`devDown`, `devDestroy` to stop). The database is then on port 5433. Either way it's `flyway_db`, user `flyway_user`, password `flyway_pass`.

## Looking at the result

```
GET /api/public/v1/schemas           the app's schemas
GET /api/public/v1/tables            tables and views in dime (?schema= for another)
GET /api/public/v1/show/user_stats   the rows of a table or view
```

PostgreSQL's own schemas (`pg_catalog`, `information_schema`) are off limits: the Docker user is a superuser, and those hold things like password hashes.

## Things to try

- **Start over:** `./gradlew dbDestroy dbUp`, then `bootRun`, and watch every migration run in the log.
- **Add a table:** create `V7__add_tags_table.sql`, restart the app, and it runs once.
- **Change a view:** edit the repeatable script and restart; it runs again because its checksum changed.
- **Break a checksum:** edit a versioned script that already ran and restart; Flyway refuses to start. The right fix is a new script. While learning, you can also delete its row from `public.flyway_schema_history`.
- **Roll back by hand:** in `dbShell`, `DROP TABLE dime.comments CASCADE;` then `DELETE FROM public.flyway_schema_history WHERE version = '3';`, and the next start runs V3 again.

Useful in psql: `\dn` lists schemas, `\dt dime.*` the tables, and `SELECT * FROM public.flyway_schema_history;` what Flyway has done.

## Tests

`./gradlew test` starts its own PostgreSQL with Testcontainers (Docker has to be running, nothing else), applies every migration to it and checks the API. GitHub runs the same on every pull request.

## Working on it

Work goes on `feature/*` branches into `develop`, and `main` holds what is stable. Commit messages follow `.gitmessage` (`git config commit.template .gitmessage`): a subject of at most 50 characters, then "Purpose of the change" and "How does it affect the application", at least 50 characters each. A check on every pull request makes sure.
