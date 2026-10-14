
package com.autocommerce.api.controller;

import java.time.Instant;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/system")
public class SystemController {

    private final JdbcTemplate jdbcTemplate;

    public SystemController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> status() {

        Integer databaseCheck = jdbcTemplate.queryForObject(
            "SELECT 1",
            Integer.class
        );

        boolean databaseConnected =
            databaseCheck != null && databaseCheck == 1;

        return ResponseEntity.ok(
            Map.of(
                "application", "AutoCommerce AI",
                "status", "RUNNING",
                "database", databaseConnected
                    ? "CONNECTED"
                    : "DISCONNECTED",
                "timestamp", Instant.now().toString()
            )
        );
    }
}
