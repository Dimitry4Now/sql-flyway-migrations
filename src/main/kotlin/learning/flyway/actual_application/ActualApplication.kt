package learning.flyway.actual_application

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class ActualApplication

fun main(args: Array<String>) {
	runApplication<ActualApplication>(*args)
}
