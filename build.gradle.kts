plugins {
	kotlin("jvm") version "2.2.21"
	kotlin("plugin.spring") version "2.2.21"
	id("org.springframework.boot") version "4.0.0"
	id("io.spring.dependency-management") version "1.1.7"
	kotlin("plugin.jpa") version "2.2.21"
}

group = "learning.flyway"
version = "0.0.1-SNAPSHOT"
description = "Application to learn Flyway Migrations"

java {
	toolchain {
		languageVersion = JavaLanguageVersion.of(21)
	}
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-data-jpa")
	implementation("org.springframework.boot:spring-boot-starter-flyway")
	implementation("org.springframework.boot:spring-boot-starter-webmvc")
	implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
	implementation("org.flywaydb:flyway-database-postgresql")
	implementation("org.jetbrains.kotlin:kotlin-reflect")
	runtimeOnly("org.postgresql:postgresql")
	testImplementation("org.springframework.boot:spring-boot-starter-data-jpa-test")
	testImplementation("org.springframework.boot:spring-boot-starter-flyway-test")
	testImplementation("org.springframework.boot:spring-boot-starter-webmvc-test")
	testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
	testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

kotlin {
	compilerOptions {
		freeCompilerArgs.addAll("-Xjsr305=strict", "-Xannotation-default-target=param-property")
	}
}

allOpen {
	annotation("jakarta.persistence.Entity")
	annotation("jakarta.persistence.MappedSuperclass")
	annotation("jakarta.persistence.Embeddable")
}

tasks.withType<Test> {
	useJUnitPlatform()
}

// Option 1: Start only PostgreSQL (for learning and testing migrations)
tasks.register<Exec>("dbUp") {
    group = "database"
    description = "Start PostgreSQL database only (persistent mode for migration learning)"
    commandLine("docker-compose", "-f", "docker/docker-compose.db.yml", "up", "-d")
}

tasks.register<Exec>("dbDown") {
    group = "database"
    description = "Stop PostgreSQL database"
    commandLine("docker-compose", "-f", "docker/docker-compose.db.yml", "down")
}

tasks.register<Exec>("dbDestroy") {
    group = "database"
    description = "Stop PostgreSQL and remove volumes (clean slate)"
    commandLine("docker-compose", "-f", "docker/docker-compose.db.yml", "down", "-v")
}

tasks.register<Exec>("dbLogs") {
    group = "database"
    description = "Show PostgreSQL logs"
    commandLine("docker-compose", "-f", "docker/docker-compose.db.yml", "logs", "-f")
}

tasks.register<Exec>("dbShell") {
    group = "database"
    description = "Open PostgreSQL shell"
    commandLine("docker-compose", "-f", "docker/docker-compose.db.yml", "exec", "postgres", "psql", "-U", "flyway_user", "-d", "flyway_db")
}

// Option 2: Start full application stack (app + database)
tasks.register<Exec>("devUp") {
    group = "development"
    description = "Start full stack (PostgreSQL + Spring Boot app with fresh migrations)"
    dependsOn("bootJar")
    commandLine("docker-compose", "-f", "docker/docker-compose.dev.yml", "up", "--build")
}

tasks.register<Exec>("devDown") {
    group = "development"
    description = "Stop full development stack"
    commandLine("docker-compose", "-f", "docker/docker-compose.dev.yml", "down")
}

tasks.register<Exec>("devDestroy") {
    group = "development"
    description = "Stop full stack and remove volumes (complete reset)"
    commandLine("docker-compose", "-f", "docker/docker-compose.dev.yml", "down", "-v")
}

tasks.register<Exec>("devLogs") {
    group = "development"
    description = "Show logs from all services"
    commandLine("docker-compose", "-f", "docker/docker-compose.dev.yml", "logs", "-f")
}

// Migration helper tasks
tasks.register("migrateInfo") {
    group = "migration"
    description = "Show migration status (run app locally with bootRun first)"
    doLast {
        println("Run './gradlew bootRun' and check the startup logs for Flyway migration info")
        println("Or connect to the database and query: SELECT * FROM flyway_schema_history;")
    }
}