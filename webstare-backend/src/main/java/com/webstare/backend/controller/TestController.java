package com.webstare.backend.controller;

import com.webstare.backend.common.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/test")
public class TestController {

    @GetMapping("/hello")
    public Result<Map<String, Object>> hello() {
        Map<String, Object> data = new HashMap<>();
        data.put("message", "WebStare Backend is running!");
        data.put("version", "1.0.0");
        data.put("timestamp", System.currentTimeMillis());
        return Result.success(data);
    }
}
