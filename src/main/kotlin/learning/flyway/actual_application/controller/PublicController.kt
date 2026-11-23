package learning.flyway.actual_application.controller

import org.springframework.http.HttpStatus
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.server.ResponseStatusException

@RestController
@RequestMapping("/api/public/v1")
class PublicController(
    private val jdbcTemplate: JdbcTemplate
) {

    companion object {
        const val DEFAULT_SCHEMA = "dime"
    }

    @GetMapping("/show/{nameOfTableOrView}")
    fun showTableOrView(
        @PathVariable nameOfTableOrView: String,
        @RequestParam(defaultValue = DEFAULT_SCHEMA) schema: String
    ): List<Map<String, Any?>> {
        // The names go into the SQL, so they must be plain identifiers.
        if (!isValidIdentifier(nameOfTableOrView) || !isValidIdentifier(schema)) {
            throw ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid table/view or schema name")
        }
        requireOwnSchema(schema)
        // Only tables and views that exist, so a typo is a 404 rather than an SQL error.
        val exists = jdbcTemplate.queryForObject(
            "SELECT count(*) FROM information_schema.tables WHERE table_schema = ? AND table_name = ?",
            Int::class.java,
            schema,
            nameOfTableOrView
        ) ?: 0
        if (exists == 0) {
            throw ResponseStatusException(HttpStatus.NOT_FOUND, "No table or view $schema.$nameOfTableOrView")
        }

        return jdbcTemplate.queryForList("SELECT * FROM $schema.$nameOfTableOrView")
    }

    @GetMapping("/tables")
    fun listAllTables(
        @RequestParam(defaultValue = DEFAULT_SCHEMA) schema: String
    ): Map<String, Any> {
        if (!isValidIdentifier(schema)) {
            throw ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid schema name")
        }
        requireOwnSchema(schema)

        val tables = jdbcTemplate.queryForList(
            """
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = ? 
            AND table_type = 'BASE TABLE'
            ORDER BY table_name
            """,
            String::class.java,
            schema
        )

        val views = jdbcTemplate.queryForList(
            """
            SELECT table_name 
            FROM information_schema.views 
            WHERE table_schema = ?
            ORDER BY table_name
            """,
            String::class.java,
            schema
        )

        return mapOf(
            "schema" to schema,
            "tables" to tables,
            "views" to views
        )
    }

    @GetMapping("/schemas")
    fun listAllSchemas(): Map<String, List<String>> {
        val schemas = jdbcTemplate.queryForList(
            """
            SELECT schema_name 
            FROM information_schema.schemata 
            WHERE schema_name <> 'information_schema' AND schema_name NOT LIKE 'pg\_%'
            ORDER BY schema_name
            """,
            String::class.java
        )

        return mapOf(
            "schemas" to schemas
        )
    }

    private fun isValidIdentifier(name: String): Boolean {
        // Allow alphanumeric, underscore only (removed hyphen for schema safety)
        return name.matches(Regex("^[a-zA-Z0-9_]+$"))
    }

    /**
     * PostgreSQL's own catalogs are off limits: the database user in Docker is
     * a superuser, so pg_catalog.pg_authid, for one, holds password hashes.
     */
    private fun requireOwnSchema(schema: String) {
        val lower = schema.lowercase()
        if (lower == "information_schema" || lower.startsWith("pg_")) {
            throw ResponseStatusException(HttpStatus.BAD_REQUEST, "System schemas are not shown")
        }
    }
}