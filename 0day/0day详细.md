# 第一阶段：项目结构搭建（第1-2天）- 详细执行手册

---

## 目录

- [第1天：项目初始化与数据库搭建](#第1天项目初始化与数据库搭建)
- [第2天：配置与接口预留](#第2天配置与接口预留)

---

## 第1天：项目初始化与数据库搭建

---

### 1.1 前置环境检查

请确保本地已安装以下环境：

| 软件 | 版本要求 | 验证命令 |
|------|----------|----------|
| Node.js | ≥18.x | `node -v` |
| npm / pnpm / yarn | ≥9.x | `npm -v` |
| JDK | ≥17 | `java -version` |
| Maven | ≥3.8 | `mvn -v` |
| Docker | ≥24.x | `docker -v` |
| Git | ≥2.40 | `git --version` |

---

### 1.2 后端项目初始化（SpringBoot）

#### 步骤1：创建 SpringBoot 项目
推荐使用 **Spring Initializr**（https://start.spring.io/）或 IDEA 直接创建：

**项目配置：**
- Group: `com.webstare`
- Artifact: `webstare-backend`
- Name: `webstare-backend`
- Package name: `com.webstare.backend`
- Packaging: `Jar`
- Java: `17`

**选择依赖：**
- Spring Web
- Spring Security
- Spring Data Redis
- Spring Data JPA (或 MyBatis-Plus)
- MySQL Driver
- Lombok
- Validation
- Spring Boot DevTools

#### 步骤2：项目目录结构
```
webstare-backend/
├── src/
│   ├── main/
│   │   ├── java/com/webstare/backend/
│   │   │   ├── common/          # 公共模块（常量、响应封装、异常处理）
│   │   │   ├── config/          # 配置类（Security、Redis、MyBatis等）
│   │   │   ├── controller/      # 控制器
│   │   │   ├── entity/          # 数据库实体
│   │   │   ├── dto/             # 数据传输对象（请求/响应）
│   │   │   ├── mapper/          # MyBatis Mapper
│   │   │   ├── service/         # 业务逻辑
│   │   │   ├── ai/              # AI 服务调用层
│   │   │   └── WebstareBackendApplication.java
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── mapper/          # MyBatis XML
│   │       └── db/              # SQL 脚本
│   └── test/
└── pom.xml
```

#### 步骤3：pom.xml 补充依赖（MyBatis-Plus）
```xml
<!-- MyBatis-Plus -->
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.5.5</version>
</dependency>
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-generator</artifactId>
    <version>3.5.5</version>
</dependency>

<!-- JWT -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.3</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.12.3</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.12.3</version>
    <scope>runtime</scope>
</dependency>

<!-- Hutool 工具类 -->
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>
    <version>5.8.26</version>
</dependency>
```

---

### 1.3 前端项目初始化（Vue3）

#### 步骤1：创建 Vite + Vue3 项目
```bash
npm create vite@latest webstare-frontend -- --template vue
cd webstare-frontend
npm install
```

#### 步骤2：安装核心依赖
```bash
# UI 组件库
npm install element-plus @element-plus/icons-vue

# 路由与状态管理
npm install vue-router@4 pinia

# HTTP 与 WebSocket
npm install axios

# Markdown 渲染
npm install marked highlight.js

# 思维导图（可选，后面再装）
# npm install @antv/g6

# 工具类
npm install lodash-es dayjs

# 类型定义
npm install -D @types/lodash-es
```

#### 步骤3：前端项目目录结构
```
webstare-frontend/
├── public/
├── src/
│   ├── assets/              # 静态资源
│   ├── components/          # 公共组件
│   ├── router/              # 路由配置
│   ├── stores/              # Pinia 状态管理
│   ├── views/               # 页面组件
│   ├── api/                 # API 接口封装
│   ├── utils/               # 工具函数
│   ├── styles/              # 全局样式
│   ├── App.vue
│   └── main.js
├── .env
├── .env.development
├── vite.config.js
└── package.json
```

---

### 1.4 数据库搭建（MySQL + Redis）

#### 方案A：Docker 快速启动（推荐）
在项目根目录创建 `docker-compose.yml`：
```yaml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    container_name: webstare-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root123456
      MYSQL_DATABASE: webstare
      TZ: Asia/Shanghai
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

  redis:
    image: redis:7-alpine
    container_name: webstare-redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data

volumes:
  mysql-data:
  redis-data:
```

启动：
```bash
docker-compose up -d
```

#### 方案B：本地安装
1. 安装 MySQL 8.0，创建数据库：
```sql
CREATE DATABASE webstare DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```
2. 安装 Redis 7.x，默认端口 6379

---

### 1.5 数据库表结构初始化 SQL

在 `webstare-backend/src/main/resources/db/init.sql` 创建：

```sql
-- 用户表
CREATE TABLE `user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名/学号',
  `password` VARCHAR(255) NOT NULL COMMENT '密码',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0-禁用 1-启用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 用户画像表
CREATE TABLE `user_profile` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `knowledge_base` JSON DEFAULT NULL COMMENT '知识基础 {\"Python\": \"初级\"}',
  `weak_points` JSON DEFAULT NULL COMMENT '薄弱点数组',
  `cognitive_style` VARCHAR(50) DEFAULT NULL COMMENT '认知风格：视觉型/实践型等',
  `learning_goal` VARCHAR(255) DEFAULT NULL COMMENT '学习目标',
  `interests` JSON DEFAULT NULL COMMENT '兴趣领域',
  `learning_pace` VARCHAR(20) DEFAULT NULL COMMENT '学习节奏：快/中/慢',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户画像表';

-- 技能树节点表
CREATE TABLE `knowledge_tree_node` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父节点ID，0为根节点',
  `name` VARCHAR(100) NOT NULL COMMENT '知识点名称',
  `subject` VARCHAR(50) NOT NULL COMMENT '所属课程/学科',
  `status` TINYINT DEFAULT 0 COMMENT '状态 0-未学 1-学习中 2-已掌握',
  `user_id` BIGINT NOT NULL COMMENT '用户ID（个性化树）',
  `resources` JSON DEFAULT NULL COMMENT '关联资源ID集合',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='技能树节点表';

-- 题库表
CREATE TABLE `question_bank` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `subject` VARCHAR(50) NOT NULL COMMENT '学科',
  `tags` JSON DEFAULT NULL COMMENT '知识点标签数组',
  `difficulty` TINYINT DEFAULT 1 COMMENT '难度 1-简单 2-中等 3-困难',
  `content` TEXT NOT NULL COMMENT '题面（Markdown）',
  `options` JSON DEFAULT NULL COMMENT '选项（单选/多选）',
  `answer` TEXT NOT NULL COMMENT '答案与解析',
  `question_type` VARCHAR(20) DEFAULT '单选' COMMENT '题型：单选/多选/填空/编程',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_subject` (`subject`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题库表';

-- 知识点标签表
CREATE TABLE `knowledge_tag` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(50) NOT NULL COMMENT '标签名称',
  `subject` VARCHAR(50) NOT NULL COMMENT '所属学科',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识点标签表';

-- 学习记录表
CREATE TABLE `study_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `node_id` BIGINT DEFAULT NULL COMMENT '技能树节点ID',
  `resource_type` VARCHAR(20) DEFAULT NULL COMMENT '资源类型：文档/视频/PPT',
  `resource_id` VARCHAR(100) DEFAULT NULL COMMENT '资源ID',
  `study_duration` INT DEFAULT 0 COMMENT '学习时长（秒）',
  `study_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '学习时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习记录表';

-- 测验记录表
CREATE TABLE `exam_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `node_id` BIGINT DEFAULT NULL COMMENT '技能树节点ID',
  `score` INT DEFAULT 0 COMMENT '得分',
  `total_score` INT DEFAULT 100 COMMENT '总分',
  `pass_rate` DECIMAL(5,2) DEFAULT NULL COMMENT '通过率',
  `expected_pass_rate` DECIMAL(5,2) DEFAULT NULL COMMENT '预期通过率',
  `weak_points` JSON DEFAULT NULL COMMENT '薄弱点',
  `exam_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '测验时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='测验记录表';

-- 答题明细表
CREATE TABLE `answer_detail` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `exam_record_id` BIGINT NOT NULL COMMENT '测验记录ID',
  `question_id` BIGINT NOT NULL COMMENT '题目ID',
  `user_answer` TEXT DEFAULT NULL COMMENT '用户答案',
  `is_correct` TINYINT DEFAULT 0 COMMENT '是否正确 0-否 1-是',
  `answer_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间',
  PRIMARY KEY (`id`),
  KEY `idx_exam_record_id` (`exam_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='答题明细表';
```

---

## 第2天：配置与接口预留

---

### 2.1 后端配置文件

#### `application.yml`
```yaml
server:
  port: 8080

spring:
  application:
    name: webstare-backend
  profiles:
    active: dev

  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/webstare?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false
    username: root
    password: root123456

  data:
    redis:
      host: localhost
      port: 6379
      database: 0
      timeout: 3000

mybatis-plus:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.webstare.backend.entity
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl

# 自定义配置
webstare:
  jwt:
    secret: webstare-secret-key-2026-very-long-secret
    expiration: 86400000 # 24小时
  ai:
    service:
      url: http://localhost:5000 # AI agent 服务地址
```

---

### 2.2 后端公共模块搭建

#### 1. 统一响应封装 `common/Result.java`
```java
package com.webstare.backend.common;

import lombok.Data;

@Data
public class Result<T> {
    private Integer code;
    private String message;
    private T data;
    private long timestamp;

    public Result() {
        this.timestamp = System.currentTimeMillis();
    }

    public static <T> Result<T> success(T data) {
        Result<T> result = new Result<>();
        result.code = 200;
        result.message = "success";
        result.data = data;
        return result;
    }

    public static <T> Result<T> error(String message) {
        Result<T> result = new Result<>();
        result.code = 500;
        result.message = message;
        return result;
    }
}
```

#### 2. 统一异常处理 `common/GlobalExceptionHandler.java`
```java
package com.webstare.backend.common;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(Exception.class)
    public Result<?> handleException(Exception e) {
        e.printStackTrace();
        return Result.error(e.getMessage());
    }
}
```

---

### 2.3 AI 服务调用层预留（重点）

创建 `ai/` 包下的接口与 DTO：

#### 1. AI 服务统一客户端 `ai/AiServiceClient.java`
```java
package com.webstare.backend.ai;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

// 注意：如果不用 Feign，也可以用 RestTemplate 或 WebClient
@FeignClient(name = "ai-service", url = "${webstare.ai.service.url}")
public interface AiServiceClient {

    // 画像对话
    @PostMapping("/api/ai/profile-chat")
    AiResponse profileChat(@RequestBody AiRequest request);

    // 生成技能树
    @PostMapping("/api/ai/generate-skill-tree")
    AiResponse generateSkillTree(@RequestBody AiRequest request);

    // 生成学习资源
    @PostMapping("/api/ai/generate-resources")
    AiResponse generateResources(@RequestBody AiRequest request);

    // 智能答疑
    @PostMapping("/api/ai/tutor-ask")
    AiResponse tutorAsk(@RequestBody AiRequest request);

    // 评估反馈
    @PostMapping("/api/ai/evaluate")
    AiResponse evaluate(@RequestBody AiRequest request);
}
```

#### 2. 通用请求 DTO `dto/AiRequest.java`
```java
package com.webstare.backend.dto;

import lombok.Data;
import java.util.Map;

@Data
public class AiRequest {
    private String userId;
    private String type; // profile-chat / generate-tree / generate-resources / tutor-ask / evaluate
    private Map<String, Object> payload;
}
```

#### 3. 通用响应 DTO `dto/AiResponse.java`
```java
package com.webstare.backend.dto;

import lombok.Data;
import java.util.Map;

@Data
public class AiResponse {
    private Integer code;
    private String message;
    private Map<String, Object> data;
}
```

---

### 2.4 前端基础配置

#### 1. `vite.config.js` 代理配置
```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src')
    }
  },
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },
      '/ws': {
        target: 'ws://localhost:8080',
        ws: true
      }
    }
  }
})
```

#### 2. 路由配置 `router/index.js`
```javascript
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', name: 'Welcome', component: () => import('@/views/Welcome.vue') },
  { path: '/login', name: 'Login', component: () => import('@/views/Login.vue') },
  { path: '/profile-chat', name: 'ProfileChat', component: () => import('@/views/ProfileChat.vue') },
  { path: '/skill-tree', name: 'SkillTree', component: () => import('@/views/SkillTree.vue') },
  { path: '/study/:nodeId', name: 'Study', component: () => import('@/views/Study.vue') },
  { path: '/exam/:nodeId', name: 'Exam', component: () => import('@/views/Exam.vue') },
  { path: '/profile', name: 'Profile', component: () => import('@/views/Profile.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
```

#### 3. API 封装 `api/request.js`
```javascript
import axios from 'axios'

const request = axios.create({
  baseURL: '/api',
  timeout: 30000
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => Promise.reject(error)
)

// 响应拦截器
request.interceptors.response.use(
  response => response.data,
  error => Promise.reject(error)
)

export default request
```

---

### 2.5 跨域配置（后端）

创建 `config/CorsConfig.java`
```java
package com.webstare.backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }
}
```

---

## 第一阶段交付清单

| 项 | 状态 |
|----|------|
| 后端 SpringBoot 项目骨架 | ☐ |
| 前端 Vue3 项目骨架 | ☐ |
| MySQL & Redis 启动成功 | ☐ |
| 数据库表结构初始化完成 | ☐ |
| 后端公共模块（Result、异常处理）| ☐ |
| AI 服务调用层接口预留 | ☐ |
| 前端路由与 API 封装 | ☐ |
| 跨域配置 | ☐ |

---

完成以上步骤即表示第一阶段结束，可以进入第二阶段「后端业务服务开发」。
