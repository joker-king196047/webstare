<template>
  <div class="skill-tree-container">
    <el-container style="height: 100%;">
      <el-header>
        <div class="header-content">
        <h2>个性化技能树</h2>
        <div class="header-actions">
          <el-button type="primary" @click="refreshTree">刷新技能树</el-button>
          <el-button @click="goProfile">个人中心</el-button>
        </div>
        </div>
      </el-header>
      <el-main>
        <el-row :gutter="20">
          <el-col :span="18">
            <el-card class="tree-card">
              <template #header><span>知识图谱</span></template>
              <div class="tree-placeholder">
                <el-empty description="技能树可视化组件加载中..." />
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card class="node-panel">
              <template #header><span>节点详情</span></template>
              <el-empty description="选择左侧节点查看详情" />
            </el-card>
          </el-col>
        </el-row>
      </el-main>
    </el-container>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

function refreshTree() {
  // TODO: 调用 API 刷新技能树
}

function goProfile() {
  router.push('/profile')
}
</script>

<style scoped>
.skill-tree-container {
  width: 100%;
  height: 100%;
}

.el-header {
  background-color: white;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  display: flex;
  align-items: center;
}

.header-content {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.tree-placeholder {
  height: 500px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px dashed #e4e7ed;
  border-radius: 8px;
}

.tree-card,
.node-panel {
  height: 100%;
}
</style>
