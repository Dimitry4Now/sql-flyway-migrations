package learning.flyway.actual_application

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc
import org.springframework.context.annotation.Import
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.get

@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration::class)
class PublicControllerTests {

	@Autowired
	lateinit var mvc: MockMvc

	@Test
	fun `lists the tables and views of the dime schema`() {
		mvc.get("/api/public/v1/tables").andExpect {
			status { isOk() }
			jsonPath("$.tables") { value(org.hamcrest.Matchers.hasItem("users")) }
			jsonPath("$.views") { value(org.hamcrest.Matchers.hasItem("user_stats")) }
		}
	}

	@Test
	fun `shows the rows of a table`() {
		mvc.get("/api/public/v1/show/users").andExpect {
			status { isOk() }
			jsonPath("$[0].username") { exists() }
		}
	}

	@Test
	fun `refuses PostgreSQL's own catalogs`() {
		// pg_authid holds password hashes, and the Docker user is a superuser.
		mvc.get("/api/public/v1/show/pg_authid?schema=pg_catalog").andExpect { status { isBadRequest() } }
		mvc.get("/api/public/v1/tables?schema=information_schema").andExpect { status { isBadRequest() } }
	}

	@Test
	fun `a table that doesn't exist is not found`() {
		mvc.get("/api/public/v1/show/no_such_table").andExpect { status { isNotFound() } }
	}

	@Test
	fun `names that aren't plain identifiers are refused`() {
		// (Spring drops anything after ";" in a path segment before it gets here.)
		mvc.get("/api/public/v1/show/bad-name").andExpect { status { isBadRequest() } }
		mvc.get("/api/public/v1/show/users?schema=dime.users").andExpect { status { isBadRequest() } }
	}

	@Test
	fun `the schema list leaves out the system schemas`() {
		mvc.get("/api/public/v1/schemas").andExpect {
			status { isOk() }
			jsonPath("$.schemas") { value(org.hamcrest.Matchers.hasItem("dime")) }
			jsonPath("$.schemas") { value(org.hamcrest.Matchers.not(org.hamcrest.Matchers.hasItem("pg_catalog"))) }
		}
	}
}
