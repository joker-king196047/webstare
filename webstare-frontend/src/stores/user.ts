import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useUserStore = defineStore('user', () => {
  const token = ref<string>(localStorage.getItem('token') || '')
  const userInfo = ref<any>(null)
  const userProfile = ref<any>(null)

  const isLoggedIn = computed(() => !!token.value)

  function setToken(newToken: string) {
    token.value = newToken
    localStorage.setItem('token', newToken)
  }

  function setUserInfo(info: any) {
    userInfo.value = info
  }

  function setUserProfile(profile: any) {
    userProfile.value = profile
  }

  function logout() {
    token.value = ''
    userInfo.value = null
    userProfile.value = null
    localStorage.removeItem('token')
  }

  return {
    token,
    userInfo,
    userProfile,
    isLoggedIn,
    setToken,
    setUserInfo,
    setUserProfile,
    logout
  }
})
