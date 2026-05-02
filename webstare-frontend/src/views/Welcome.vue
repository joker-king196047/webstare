<template>
  <div class="welcome-container">
    <div class="welcome-content">
      <h1 class="welcome-title">WebStare</h1>
      <p class="welcome-subtitle">基于多智能体的大学生个性化学习辅助系统</p>
      
      <div class="welcome-actions">
        <el-button type="primary" size="large" @click="goLogin">
          开始使用
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

function goLogin() {
  router.push('/login')
}
</script>

<style scoped>
.welcome-container {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.welcome-content {
  text-align: center;
  color: white;
}

.welcome-title {
  font-size: 72px;
  font-weight: 800;
  margin-bottom: 24px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
}

.welcome-subtitle {
  font-size: 24px;
  margin-bottom: 48px;
  opacity: 0.95;
}

.welcome-actions {
  margin-top: 32px;
}
</style>
