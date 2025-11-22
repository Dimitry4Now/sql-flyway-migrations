package learning.flyway.actual_application.controller

import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

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
        // Validate table/view and schema names to prevent SQL injection
        if (!isValidIdentifier(nameOfTableOrView) || !isValidIdentifier(schema)) {
            throw IllegalArgumentException("Invalid table/view or schema name")
        }

        return try {
            jdbcTemplate.queryForList("SELECT * FROM $schema.$nameOfTableOrView")
        } catch (e: Exception) {
            throw RuntimeException("Error fetching data from $schema.$nameOfTableOrView: ${e.message}", e)
        }
    }

    @GetMapping("/tables")
    fun listAllTables(
        @RequestParam(defaultValue = DEFAULT_SCHEMA) schema: String
    ): Map<String, Any> {
        if (!isValidIdentifier(schema)) {
            throw IllegalArgumentException("Invalid schema name")
        }

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
            WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
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
}