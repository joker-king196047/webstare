package com.webstare.backend;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.webstare.backend.mapper")
public class WebstareBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(WebstareBackendApplication.class, args);
        System.out.println("========================================");
        System.out.println("  WebStare Backend Started Successfully!");
        System.out.println("  Access: http://localhost:8080");
        System.out.println("========================================");
    }
}
