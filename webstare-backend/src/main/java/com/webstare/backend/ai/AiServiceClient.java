package com.webstare.backend.ai;

import com.webstare.backend.dto.AiRequest;
import com.webstare.backend.dto.AiResponse;

// AI服务客户端接口 - 预留，后续可用 RestTemplate/WebClient 实现
public interface AiServiceClient {

    AiResponse profileChat(AiRequest request);

    AiResponse generateSkillTree(AiRequest request);

    AiResponse generateResources(AiRequest request);

    AiResponse tutorAsk(AiRequest request);

    AiResponse evaluate(AiRequest request);
}
