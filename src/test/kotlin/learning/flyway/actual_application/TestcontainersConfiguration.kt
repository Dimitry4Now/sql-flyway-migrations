package learning.flyway.actual_application

import org.springframework.boot.test.context.TestConfiguration
import org.springframework.boot.testcontainers.service.connection.ServiceConnection
import org.springframework.context.annotation.Bean
import org.testcontainers.postgresql.PostgreSQLContainer

/**
 * A PostgreSQL for the tests, started in Docker and wired into the app in
 * place of the one from docker-compose, so the tests need nothing running.
 * The same image as docker/docker-compose.db.yml.
 */
@TestConfiguration(proxyBeanMethods = false)
class TestcontainersConfiguration {

	@Bean
	@ServiceConnection
	fun postgres(): PostgreSQLContainer = PostgreSQLContainer("postgres:16-alpine")
}
