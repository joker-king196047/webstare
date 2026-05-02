<template>
  <div class="exam-container">
    <h1>测验页面</h1>
    <p>节点 ID: {{ nodeId }}</p>
    <el-button @click="goBack">返回技能树</el-button>
  </div>
</template>

<script setup lang="ts">
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const nodeId = route.params.nodeId

function goBack() {
  router.push('/skill-tree')
}
</script>

<style scoped>
.exam-container {
  width: 100%;
  height: 100%;
  padding: 24px;
}
</style>
