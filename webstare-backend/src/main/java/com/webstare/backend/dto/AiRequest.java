package com.webstare.backend.dto;

import lombok.Data;
import java.util.Map;

@Data
public class AiRequest {
    private String userId;
    private String type;
    private Map<String, Object> payload;
}
