package com.webstare.backend.ai;

import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import cn.hutool.json.JSONUtil;
import com.webstare.backend.dto.AiRequest;
import com.webstare.backend.dto.AiResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class AiServiceClientImpl implements AiServiceClient {

    @Value("${webstare.ai.service.url}")
    private String aiServiceUrl;

    @Override
    public AiResponse profileChat(AiRequest request) {
        return post("/api/ai/profile-chat", request);
    }

    @Override
    public AiResponse generateSkillTree(AiRequest request) {
        return post("/api/ai/generate-skill-tree", request);
    }

    @Override
    public AiResponse generateResources(AiRequest request) {
        return post("/api/ai/generate-resources", request);
    }

    @Override
    public AiResponse tutorAsk(AiRequest request) {
        return post("/api/ai/tutor-ask", request);
    }

    @Override
    public AiResponse evaluate(AiRequest request) {
        return post("/api/ai/evaluate", request);
    }

    private AiResponse post(String path, AiRequest request) {
        try {
            HttpResponse response = HttpRequest.post(aiServiceUrl + path)
                    .contentType("application/json")
                    .body(JSONUtil.toJsonStr(request))
                    .timeout(30000)
                    .execute();
            return JSONUtil.toBean(response.body(), AiResponse.class);
        } catch (Exception e) {
            throw new RuntimeException("调用AI服务失败: " + e.getMessage(), e);
        }
    }
}
