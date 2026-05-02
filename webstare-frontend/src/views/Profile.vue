<template>
  <div class="profile-container">
    <h1>个人中心</h1>
    <el-button @click="goBack">返回技能树</el-button>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

function goBack() {
  router.push('/skill-tree')
}
</script>

<style scoped>
.profile-container {
  width: 100%;
  height: 100%;
  padding: 24px;
}
</style>
