package com.webstare.backend.dto;

import lombok.Data;
import java.util.Map;

@Data
public class AiResponse {
    private Integer code;
    private String message;
    private Map<String, Object> data;
}
