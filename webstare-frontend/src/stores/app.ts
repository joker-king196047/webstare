import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useAppStore = defineStore('app', () => {
  const currentNodeId = ref<string | null>(null)
  const skillTree = ref<any>(null)
  const resources = ref<any[]>([])

  function setCurrentNodeId(nodeId: string | null) {
    currentNodeId.value = nodeId
  }

  function setSkillTree(tree: any) {
    skillTree.value = tree
  }

  function setResources(res: any[]) {
    resources.value = res
  }

  function addResource(res: any) {
    resources.value.push(res)
  }

  return {
    currentNodeId,
    skillTree,
    resources,
    setCurrentNodeId,
    setSkillTree,
    setResources,
    addResource
  }
})
