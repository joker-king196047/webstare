import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Welcome',
    component: () => import('@/views/Welcome.vue'),
    meta: { title: '欢迎 - WebStare' }
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录 - WebStare' }
  },
  {
    path: '/profile-chat',
    name: 'ProfileChat',
    component: () => import('@/views/ProfileChat.vue'),
    meta: { title: '构建画像 - WebStare' }
  },
  {
    path: '/skill-tree',
    name: 'SkillTree',
    component: () => import('@/views/SkillTree.vue'),
    meta: { title: '技能树 - WebStare' }
  },
  {
    path: '/study/:nodeId',
    name: 'Study',
    component: () => import('@/views/Study.vue'),
    meta: { title: '学习 - WebStare' }
  },
  {
    path: '/exam/:nodeId',
    name: 'Exam',
    component: () => import('@/views/Exam.vue'),
    meta: { title: '测验 - WebStare' }
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('@/views/Profile.vue'),
    meta: { title: '个人中心 - WebStare' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  document.title = to.meta?.title || 'WebStare'
  next()
})

export default router
