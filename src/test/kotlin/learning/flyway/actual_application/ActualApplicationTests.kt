package learning.flyway.actual_application

import org.flywaydb.core.Flyway
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Import
import org.springframework.jdbc.core.JdbcTemplate
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@SpringBootTest
@Import(TestcontainersConfiguration::class)
class ActualApplicationTests {

	@Autowired
	lateinit var flyway: Flyway

	@Autowired
	lateinit var jdbc: JdbcTemplate

	@Test
	fun `every migration applies on a fresh database`() {
		val applied = flyway.info().applied()
		assertTrue(applied.all { it.state.isApplied && !it.state.isFailed }, "a migration failed")
		assertEquals(6, applied.count { it.version != null }, "versioned migrations V1 to V6")
		assertTrue(applied.any { it.version == null && it.description == "refresh user stats view" })
	}

	@Test
	fun `the schema has the tables and views the migrations create`() {
		val names = jdbc.queryForList(
			"SELECT table_name FROM information_schema.tables WHERE table_schema = 'dime'",
			String::class.java
		)
		assertTrue(names.containsAll(listOf("users", "posts", "comments", "user_metadata", "vehicle_blackbox", "user_stats")))
		assertTrue(jdbc.queryForObject("SELECT count(*) FROM dime.users", Int::class.java)!! > 0, "V2 seeds users")
	}
}
