# WebStare - 基于多智能体的大学生个性化学习辅助系统

## 项目简介

WebStare 是一个基于多智能体协同的个性化学习平台，结合动态画像和技能树导航，为大学生提供定制化的学习体验。

## 技术栈

### 后端
- Spring Boot 3.x
- MyBatis Plus
- MySQL 8.0
- Redis
- Hutool 工具类
- JWT

### 前端
- Vue 3
- TypeScript
- Vite
- Element Plus
- Vue Router
- Pinia
- Axios
- Marked (Markdown)
- Highlight.js

## 项目结构

```
webstare/
├── webstare-backend/        # 后端项目
│   ├── src/main/
│   │   ├── java/com/webstare/backend/
│   │   │   ├── ai/         # AI 服务调用
│   │   │   ├── common/     # 公共模块
│   │   │   ├── config/     # 配置
│   │   │   ├── controller/ # 控制器
│   │   │   ├── dto/        # 数据传输对象
│   │   │   └── ...
│   │   └── resources/      # 配置和 SQL
│   └── pom.xml
├── webstare-frontend/       # 前端项目
│   ├── src/
│   │   ├── api/           # API 封装
│   │   ├── components/    # 公共组件
│   │   ├── router/        # 路由
│   │   ├── stores/        # 状态管理
│   │   ├── styles/        # 样式
│   │   ├── views/         # 页面
│   │   └── main.ts
│   └── package.json
├── 0day/                   # 项目初始化文档
├── 需求文档/               # 需求分析和设计文档
└── docker-compose.yml      # 数据库容器编排
```

## 快速开始

### 前置要求
- Node.js >= 18
- Java >= 17
- Maven >= 3.8
- Docker (可选，用于运行 MySQL 和 Redis)

### 1. 启动数据库 (可选)

```bash
# 使用 Docker 启动 MySQL 和 Redis
docker-compose up -d
```

如果使用本地数据库，请修改 `webstare-backend/src/main/resources/application.yml` 中的数据库连接配置。

### 2. 启动后端

```bash
cd webstare-backend
mvn spring-boot:run
```

后端服务将在 `http://localhost:8080` 启动。

### 3. 启动前端

```bash
cd webstare-frontend
npm run dev
```

前端服务将在 `http://localhost:3000` 启动。

## 开发计划

详细开发计划请参考 `计划.md`。

## License

MIT
