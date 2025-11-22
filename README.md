# Flyway Migrations Learning Project

A Spring Boot application designed to learn and practice Flyway database migrations with PostgreSQL, featuring custom schema support and organized migration structure.

## Project Structure

```
.
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.db.yml      # Database only
│   └── docker-compose.dev.yml     # Full stack
├── src/
│   ├── main/
│   │   ├── kotlin/
│   │   │   └── learning/flyway/actual_application/
│   │   │       └── controller/
│   │   │           └── PublicController.kt
│   │   └── resources/
│   │       ├── application.properties
│   │       └── db/
│   │           └── migration/
│   │               ├── versioned/
│   │               │   ├── V1__init_schema.sql
│   │               │   ├── V2__insert_initial_data.sql
│   │               │   ├── V3__add_comments_table.sql
│   │               │   └── V4__create_user_stats_view.sql
│   │               ├── repeatable/
│   │               │   └── R__refresh_user_stats_view.sql
│   │               └── undo/
│   │                   └── U3__undo_comments_table.sql
│   └── test/
├── build.gradle.kts
└── README.md
```

## Flyway Migration Naming Convention

### Versioned Migrations (V)
- **Format**: `V{VERSION}__{DESCRIPTION}.sql`
- **Location**: `src/main/resources/db/migration/versioned/`
- **Example**: `V1__init_schema.sql`, `V2__insert_initial_data.sql`
- **Purpose**: Run once, in order, for schema changes and data updates
- **Use for**: Creating tables, altering schemas, adding columns, inserting reference data

### Repeatable Migrations (R)
- **Format**: `R__{DESCRIPTION}.sql`
- **Location**: `src/main/resources/db/migration/repeatable/`
- **Example**: `R__refresh_user_stats_view.sql`
- **Purpose**: Run whenever checksum changes (after all versioned migrations)
- **Use for**: Views, stored procedures, functions that need to be recreated

### Undo Migrations (U)
- **Format**: `U{VERSION}__{DESCRIPTION}.sql`
- **Location**: `src/main/resources/db/migration/undo/`
- **Example**: `U3__undo_comments_table.sql`
- **Purpose**: Revert specific versioned migrations (requires Flyway Teams or manual execution)
- **Note**: Best practice is to create new versioned migrations instead

## Database Schema

This project uses a custom schema named **`dime`** instead of the default `public` schema. All tables and views are created within the `dime` schema.

## Getting Started

### Prerequisites
- Docker & Docker Compose
- Java 21 (or compatible JDK)
- Kotlin 2.2.21

## Development Workflow

### Initial Setup

After cloning the repository, run the setup script:
```bash
./scripts/setup-git-hooks.sh
```

This configures your local Git to use the project's commit message template.

### Commit Message Format

All commits **must** follow this format to pass CI validation:
```
Subject line (max 50 characters)

Files changed:
* src/main/kotlin/controller/PublicController.kt
* src/main/resources/db/migration/versioned/V5__add_tags.sql

Purpose of the change: (minimum 50 characters)
Added tags functionality to allow categorization of posts. This was requested
to improve content organization and user experience.

How does it affect the application: (minimum 50 characters)
Introduces a new tags table and migration. The PublicController can now
display tag data. This is a non-breaking change and existing data is preserved.
```

**Required sections:**
1. **Subject line** - Brief description (max 50 characters)
2. **Files changed** - List of modified files
3. **Purpose of the change** - Why the change was made (min 50 characters)
4. **How does it affect the application** - Impact description (min 50 characters)

### Creating Pull Requests

1. **Create feature branch from develop:**
```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
```

2. **Make changes and commit with proper format:**
```bash
   git add .
   git commit  # Opens editor with template
```

3. **Push and create PR:**
```bash
   git push -u origin feature/your-feature-name
```

4. **On GitHub:**
    - Open Pull Request targeting `develop` branch
    - Fill out the PR template
    - Wait for commit message validation to pass
    - Request review

### Branch Strategy

- **`main`** - Production-ready code (protected)
- **`develop`** - Integration branch (protected, default)
- **`feature/*`** - Feature branches (created from `develop`)

All PRs must:
- Target the `develop` branch
- Pass commit message validation
- Be approved by repository owner
- Have all commits following the commit format
---

## Example Commit Message for the Above Changes

When you run `git commit`, fill in the template like this:

```
Add commit message enforcement and PR template

Files changed:
* .github/workflows/commit-lint.yml
* .github/PULL_REQUEST_TEMPLATE.md
* .gitmessage
* scripts/setup-git-hooks.sh
* README.md

Purpose of the change: (minimum 50 characters)
Implemented commit message standardization to ensure all team members follow
consistent commit conventions. This improves code history readability and
makes it easier to understand the purpose and impact of changes.

How does it affect the application: (minimum 50 characters)
This does not affect the application runtime but establishes development
workflow standards. GitHub Actions will now validate all PR commits and
reject those not following the format. Team members must run the setup script.
```

### Option 1: Database Only (Learning Mode) 🎓

This mode starts only PostgreSQL, allowing you to run the Spring Boot app locally with full control over migrations.

#### Start Database
```bash
./gradlew dbUp
```

#### Run Application Locally
```bash
./gradlew bootRun
```

#### View Migration Status
Check the console output when the app starts, or query the database:
```bash
./gradlew dbShell
```
Then in psql:
```sql
SELECT * FROM flyway_schema_history;
SELECT * FROM dime.users;
```

#### Stop Database
```bash
./gradlew dbDown
```

#### Clean Slate (Delete all data)
```bash
./gradlew dbDestroy
```

#### View Database Logs
```bash
./gradlew dbLogs
```

### Option 2: Full Stack (Production-like Mode) 🚀

This mode starts both PostgreSQL and the Spring Boot application in Docker containers.

#### Start Full Stack
```bash
./gradlew devUp
```

#### Stop Full Stack
```bash
./gradlew devDown
```

#### Complete Reset (Delete containers and volumes)
```bash
./gradlew devDestroy
```

#### View All Logs
```bash
./gradlew devLogs
```

## API Endpoints

### List All Available Schemas
```bash
curl http://localhost:8080/api/public/v1/schemas
```

Response:
```json
{
  "schemas": ["public", "dime"]
}
```

### List All Tables and Views (Default: dime schema)
```bash
curl http://localhost:8080/api/public/v1/tables
```

Response:
```json
{
  "schema": "dime",
  "tables": ["users", "posts", "comments"],
  "views": ["user_stats"]
}
```

### List Tables in Specific Schema
```bash
curl "http://localhost:8080/api/public/v1/tables?schema=dime"
curl "http://localhost:8080/api/public/v1/tables?schema=public"
```

### Show Table/View Data (Default: dime schema)
```bash
curl http://localhost:8080/api/public/v1/show/users
curl http://localhost:8080/api/public/v1/show/posts
curl http://localhost:8080/api/public/v1/show/user_stats
```

### Show Data from Specific Schema
```bash
curl "http://localhost:8080/api/public/v1/show/users?schema=dime"
curl "http://localhost:8080/api/public/v1/show/flyway_schema_history?schema=public"
```

## Testing Migrations

### Scenario 1: Fresh Database Setup
```bash
# Clean slate
./gradlew dbDestroy

# Start database
./gradlew dbUp

# Run app (migrations will execute)
./gradlew bootRun

# Check what was created
curl http://localhost:8080/api/public/v1/schemas
curl http://localhost:8080/api/public/v1/tables
curl http://localhost:8080/api/public/v1/show/users
```

### Scenario 2: Adding New Migration
1. Create new migration file in `versioned/`: `V5__add_tags_table.sql`
```sql
CREATE TABLE dime.tags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```
2. Restart the application
3. Flyway will detect and run the new migration
4. Check migration status:
```bash
curl http://localhost:8080/api/public/v1/tables
./gradlew dbShell
# Then: SELECT * FROM flyway_schema_history;
```

### Scenario 3: Testing Repeatable Migrations
1. Modify `repeatable/R__refresh_user_stats_view.sql`
2. Add a new column to the view
3. Restart application
4. Flyway detects checksum change and re-runs it
5. Verify: `curl http://localhost:8080/api/public/v1/show/user_stats`

### Scenario 4: Manual Rollback
```bash
# Connect to database
./gradlew dbShell

# Check current state
SELECT * FROM flyway_schema_history ORDER BY installed_rank;

# Manually execute undo migration
\i src/main/resources/db/migration/undo/U3__undo_comments_table.sql

# Or run SQL directly
DROP TABLE IF EXISTS dime.comments CASCADE;

# Delete from flyway history
DELETE FROM flyway_schema_history WHERE version = '3';

# Verify
\dt dime.*
```

### Scenario 5: Testing with Different Schemas
```bash
# Start fresh
./gradlew dbDestroy && ./gradlew dbUp && ./gradlew bootRun

# Check schemas
curl http://localhost:8080/api/public/v1/schemas

# Compare tables in different schemas
curl "http://localhost:8080/api/public/v1/tables?schema=dime"
curl "http://localhost:8080/api/public/v1/tables?schema=public"
```

## Database Connection

### Option 1 (Database Only):
- **Host**: localhost
- **Port**: 5432
- **Database**: flyway_db
- **User**: flyway_user
- **Password**: flyway_pass
- **Default Schema**: dime

### Option 2 (Full Stack):
- **Host**: localhost
- **Port**: 5433 (different to avoid conflicts)
- **Database**: flyway_db
- **User**: flyway_user
- **Password**: flyway_pass
- **Default Schema**: dime

### Connection String
```
jdbc:postgresql://localhost:5432/flyway_db?currentSchema=dime
```

## Common Gradle Tasks
### Local Development while testing out the migrations
| Task | Description |
|------|-------------|
| `./gradlew dbUp` | Start PostgreSQL only |
| `./gradlew dbDown` | Stop PostgreSQL |
| `./gradlew dbDestroy` | Stop and delete PostgreSQL data |
| `./gradlew dbLogs` | Show PostgreSQL logs |
| `./gradlew dbShell` | Open PostgreSQL shell |


### Local sanity check
| Task | Description |
|------|-------------|
| `./gradlew devUp` | Start full stack (DB + App) |
| `./gradlew devDown` | Stop full stack |
| `./gradlew devDestroy` | Stop and delete all data |
| `./gradlew devLogs` | Show all service logs |


### Built in Gradle tasks
| Task | Description |
|------|-------------|
| `./gradlew bootRun` | Run app locally |
| `./gradlew bootJar` | Build executable JAR |
| `./gradlew build` | Build project |
| `./gradlew clean` | Clean build directory |

## Useful Database Commands

### Connect to PostgreSQL
```bash
./gradlew dbShell
```

### Inside psql:
```sql
-- List all schemas
\dn

-- List tables in dime schema
\dt dime.*

-- List all tables (all schemas)
\dt *.*

-- Switch to dime schema
SET search_path TO dime;

-- View migration history
SELECT version, description, type, installed_on, success 
FROM flyway_schema_history 
ORDER BY installed_rank;

-- View table structure
\d dime.users
\d dime.posts

-- Query data
SELECT * FROM dime.users;
SELECT * FROM dime.user_stats;

-- Exit
\q
```

## Configuration Files

### application.properties
Key configurations:
```properties
# Default schema
spring.flyway.locations=classpath:db/migration/versioned,classpath:db/migration/repeatable,classpath:db/migration/undo

# Enable Flyway
spring.flyway.enabled=true
spring.flyway.baseline-on-migrate=true

# Hibernate validation only (Flyway handles schema)
spring.jpa.hibernate.ddl-auto=validate
```

## Tips for Learning Flyway

1. **Start Simple**: Use Option 1 (database only) to understand each migration step
2. **Watch the Logs**: `logging.level.org.flywaydb=DEBUG` is enabled by default
3. **Check History**: Query `flyway_schema_history` table frequently
4. **Experiment**: Try breaking things! Create invalid migrations to see error handling
5. **Version Control**: Commit migrations incrementally to track your learning
6. **Use Full Stack**: Switch to Option 2 when you want to test complete deployments
7. **Schema Awareness**: Always specify schema in your SQL (`dime.table_name`)
8. **Organized Structure**: Keep migrations organized in `versioned/`, `repeatable/`, `undo/` folders

## Common Patterns

### Creating a New Table
```sql
-- versioned/V5__create_tags_table.sql
CREATE TABLE dime.tags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tags_name ON dime.tags(name);
```

### Adding a Column
```sql
-- versioned/V6__add_bio_to_users.sql
ALTER TABLE dime.users ADD COLUMN bio TEXT;
```

### Creating a View
```sql
-- versioned/V7__create_post_summary_view.sql
CREATE OR REPLACE VIEW dime.post_summary AS
SELECT 
    p.id,
    p.title,
    u.username as author,
    p.published,
    p.created_at
FROM dime.posts p
JOIN dime.users u ON p.user_id = u.id;
```

### Updating a View (Repeatable)
```sql
-- repeatable/R__refresh_post_summary_view.sql
CREATE OR REPLACE VIEW dime.post_summary AS
SELECT 
    p.id,
    p.title,
    u.username as author,
    u.email as author_email,  -- New column
    p.published,
    p.created_at
FROM dime.posts p
JOIN dime.users u ON p.user_id = u.id;
```

## Troubleshooting

### Port Already in Use
```bash
# Find process using port 5432
lsof -ti:5432
# Kill it
kill -9 <PID>

# Or use different port in docker-compose
```

### Migration Checksum Mismatch
If you modify an already-run migration:
```sql
-- Option 1: Repair (use carefully in development only!)
DELETE FROM flyway_schema_history WHERE version = 'X';

-- Option 2: Create new migration instead (recommended for production)
-- Create V6__fix_previous_issue.sql
```

### Schema Not Found Error
Make sure your migrations create the schema first:
```sql
CREATE SCHEMA IF NOT EXISTS dime;
```

### Foreign Key Reference Error
Always include schema in foreign key references:
```sql
-- Wrong
FOREIGN KEY (user_id) REFERENCES users(id)

-- Correct
FOREIGN KEY (user_id) REFERENCES dime.users(id)
```

### Clean Restart
```bash
./gradlew dbDestroy  # or devDestroy
./gradlew dbUp       # or devUp
./gradlew bootRun
```

### View Detailed Migration Logs
```bash
# When running locally
./gradlew bootRun --info

# When running in Docker
./gradlew devLogs
```

### Reset Everything
```bash
# Stop and remove everything
./gradlew dbDestroy
./gradlew devDestroy

# Clean build
./gradlew clean

# Fresh start
./gradlew dbUp
./gradlew bootRun
```

## Learning Path

### Week 1: Basics
- [ ] Set up project and run Option 1
- [ ] Create V1 migration (schema + tables)
- [ ] Create V2 migration (sample data)
- [ ] Query data via API
- [ ] Check `flyway_schema_history` table

### Week 2: Evolution
- [ ] Add new table with V3
- [ ] Alter existing table with V4
- [ ] Create database view with V5
- [ ] Test repeatable migrations
- [ ] Practice with Option 2 (full stack)

### Week 3: Advanced
- [ ] Test migration rollback
- [ ] Break a migration intentionally
- [ ] Fix with repair
- [ ] Create complex views
- [ ] Add indexes and constraints

### Week 4: Production Patterns
- [ ] Test with fresh database
- [ ] Practice deployment workflow
- [ ] Document your migrations
- [ ] Create migration checklist
- [ ] Build CI/CD understanding

## Resources

- [Flyway Documentation](https://flywaydb.org/documentation/)
- [Flyway SQL Migrations](https://flywaydb.org/documentation/concepts/migrations#sql-based-migrations)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Spring Boot Flyway Integration](https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.data-initialization.migration-tool.flyway)

## License

This is a learning project. Feel free to use and modify as needed.

< Test PR workflow -->

< Clean test -->
