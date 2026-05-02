<template>
  <div class="profile-chat-container">
    <div class="chat-header">
      <div class="header-content">
        <div class="header-left">
          <h2>🎓 构建你的专属学习画像</h2>
          <p>我们将通过 15 个详细问题，为你构建 8 大维度的完整学习画像</p>
        </div>
        <div class="header-right">
          <div class="progress-section">
            <el-progress
              :percentage="progress"
              :color="progressColor"
              :stroke-width="10"
              style="width: 220px;"
            />
            <span class="progress-text">{{ currentStep }}/{{ totalSteps }}</span>
          </div>
        </div>
      </div>
    </div>

    <div class="step-indicator">
      <span class="step-label">当前阶段</span>
      <div class="step-tags">
        <el-tag v-for="tag in currentStepTags" :key="tag" type="primary" size="small" class="step-tag">
          {{ tag }}
        </el-tag>
      </div>
    </div>

    <div class="chat-messages" ref="messagesRef">
      <div v-for="(msg, index) in messages" :key="index" class="message-item" :class="msg.role">
        <div class="avatar">
          <el-avatar v-if="msg.role === 'ai'" :size="44" class="ai-avatar">
            <el-icon><User /></el-icon>
          </el-avatar>
          <el-avatar v-else :size="44" class="user-avatar">
            <el-icon><UserFilled /></el-icon>
          </el-avatar>
        </div>
        <div class="message-content">
          <div v-if="msg.role === 'ai'" v-html="renderMarkdown(msg.content)" class="markdown-content"></div>
          <div v-else>{{ msg.content }}</div>
        </div>
      </div>

      <div v-if="showOptions" class="message-item options-container">
        <div class="avatar">
          <el-avatar :size="44" class="ai-avatar"><el-icon><User /></el-icon></el-avatar>
        </div>
        <div class="options-wrapper">
          <p class="options-hint">{{ currentType === 'multiSelect' ? '请选择最符合你的选项（可多选）' : '请选择最符合你的选项' }}</p>
          <div v-if="currentType === 'multiSelect'" class="options-content">
            <div 
              v-for="option in currentOptions" 
              :key="option" 
              class="option-btn" 
              :class="{ selected: selectedOptions.includes(option) }"
              @click="toggleOption(option)"
            >
              <span class="option-icon">{{ getOptionIcon(option) }}</span>
              <span class="option-text">{{ option }}</span>
            </div>
          </div>
          <div v-else class="options-content">
            <div 
              v-for="option in currentOptions" 
              :key="option" 
              class="option-btn" 
              @click="selectOption(option)"
            >
              <span class="option-icon">{{ getOptionIcon(option) }}</span>
              <span class="option-text">{{ option }}</span>
            </div>
          </div>
          <el-button v-if="currentType === 'multiSelect'" type="primary" style="margin-top: 12px" @click="confirmMultiSelect">
            确认选择 ({{ selectedOptions.length }})
          </el-button>
        </div>
      </div>

      <div v-if="isTyping" class="message-item ai">
        <div class="avatar"><el-avatar :size="44" class="ai-avatar"><el-icon><User /></el-icon></el-avatar></div>
        <div class="message-content">
          <span class="typing">AI 班主任正在思考</span>
          <span class="dot"></span><span class="dot"></span><span class="dot"></span>
        </div>
      </div>
    </div>

    <div class="chat-input-container">
      <el-input
        v-model="inputMsg"
        type="textarea"
        :rows="3"
        placeholder="在此输入你的回答..."
        @keyup.enter.ctrl="sendMessage"
        :disabled="showOptions || isTyping.value"
        resize="none"
      />
      <el-button 
        type="primary" 
        @click="sendMessage" 
        :disabled="showOptions || isTyping.value"
        size="large"
      >
        发送
      </el-button>
    </div>

    <div class="profile-preview" v-show="currentStep > 1">
      <div class="preview-header">
        <h3>📊 画像预览</h3>
        <el-tag type="success" size="small">实时更新</el-tag>
      </div>
      
      <div class="preview-sections">
        <div class="preview-section" v-if="profile.basicInfo.major">
          <div class="section-title">
            <el-icon><User /></el-icon> 基本信息
          </div>
          <div class="section-tags">
            <el-tag v-for="item in profile.basicInfo.tags" :key="item" size="small" closable>
              {{ item }}
            </el-tag>
          </div>
        </div>
        
        <div class="preview-section" v-if="profile.ability.level">
          <div class="section-title">
            <el-icon><TrendCharts /></el-icon> 能力评估
          </div>
          <div class="section-tags">
            <el-tag v-for="item in profile.ability.tags" :key="item" type="warning" size="small" closable>
              {{ item }}
            </el-tag>
          </div>
        </div>
        
        <div class="preview-section" v-if="profile.learning.style">
          <div class="section-title">
            <el-icon><Reading /></el-icon> 学习风格
          </div>
          <div class="section-tags">
            <el-tag v-for="item in profile.learning.tags" :key="item" type="info" size="small" closable>
              {{ item }}
            </el-tag>
          </div>
        </div>
        
        <div class="preview-section" v-if="profile.goal.direction">
          <div class="section-title">
            <el-icon><Guide /></el-icon> 目标方向
          </div>
          <div class="section-tags">
            <el-tag v-for="item in profile.goal.tags" :key="item" type="danger" size="small" closable>
              {{ item }}
            </el-tag>
          </div>
        </div>
        
        <div class="preview-section" v-if="profile.interest.tags.length > 0">
          <div class="section-title">
            <el-icon><Star /></el-icon> 兴趣爱好
          </div>
          <div class="section-tags">
            <el-tag v-for="item in profile.interest.tags" :key="item" type="success" size="small" closable>
              {{ item }}
            </el-tag>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, nextTick, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { marked } from 'marked'
import { ElMessage } from 'element-plus'
import { User, UserFilled, TrendCharts, Reading, Guide, Star } from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()

const messages = ref([
  {
    role: 'ai',
    content: `👋 **欢迎来到 WebStare 学习画像系统！**

我是你的 AI 班主任，接下来我会通过 **15 个精心设计的问题**，为你构建一个 **8 大维度**的完整学习画像。

这个画像将帮助我：
- 📚 为你推荐最适合的学习资源
- 🎯 制定个性化的学习路径
- ⏰ 调整最优的学习节奏
- 💡 提供精准的智能辅导

准备好了吗？让我们开始吧！`
  }
])

const inputMsg = ref('')
const isTyping = ref(false)
const showOptions = ref(false)
const currentOptions = ref<string[]>([])
const selectedOptions = ref<string[]>([])
const currentType = ref<'input' | 'select' | 'multiSelect' | 'complete'>('input')
const messagesRef = ref<HTMLElement | null>(null)

const totalSteps = 15
const currentStep = ref(0)
const progress = computed(() => Math.round((currentStep.value / totalSteps) * 100))
const progressColor = computed(() => {
  if (progress.value < 25) return '#f56c6c'
  if (progress.value < 50) return '#e6a23c'
  if (progress.value < 75) return '#409eff'
  return '#67c23a'
})

const currentStepTags = computed(() => {
  const tagMap = {
    1: ['基本信息'],
    2: ['基本信息'],
    3: ['专业背景'],
    4: ['能力评估'],
    5: ['能力评估'],
    6: ['能力评估'],
    7: ['学习风格'],
    8: ['学习风格'],
    9: ['学习节奏'],
    10: ['目标方向'],
    11: ['目标方向'],
    12: ['目标方向'],
    13: ['兴趣爱好'],
    14: ['兴趣爱好'],
    15: ['完成']
  }
  return tagMap[currentStep.value as keyof typeof tagMap] || ['准备中']
})

const profile = ref({
  basicInfo: { major: '', grade: '', school: '', tags: [] as string[] },
  background: { knowledgeAreas: [] as string[], experience: '', tags: [] as string[] },
  ability: { level: '', weakPoints: [] as string[], strongPoints: [] as string[], tags: [] as string[] },
  learning: { style: '', preference: '', environment: '', tags: [] as string[] },
  rhythm: { pace: '', time: '', habit: '', tags: [] as string[] },
  goal: { direction: '', timeFrame: '', specific: '', tags: [] as string[] },
  interest: { hobbies: [] as string[], fields: [] as string[], tags: [] as string[] },
  device: { primary: '', scenario: '', tags: [] as string[] }
})

const dialogFlow = [
  {
    step: 1,
    question: '首先，请告诉我你所学的专业是什么？',
    placeholder: '例如：计算机科学与技术、软件工程、人工智能...',
    type: 'input' as const,
    options: [],
    update: (value: string) => {
      profile.value.basicInfo.major = value
      profile.value.basicInfo.tags.push(value)
    }
  },
  {
    step: 2,
    question: '很好！你现在读大几了呢？',
    placeholder: '',
    type: 'select' as const,
    options: ['大一', '大二', '大三', '大四', '研究生', '已工作'],
    update: (value: string) => {
      profile.value.basicInfo.grade = value
      profile.value.basicInfo.tags.push(value)
    }
  },
  {
    step: 3,
    question: '你目前掌握哪些编程语言或技术领域呢？（可以选择多个）',
    placeholder: '',
    type: 'multiSelect' as const,
    options: ['Python', 'Java', 'C/C++', 'JavaScript/TypeScript', 'Go', 'Rust', '数据库', '前端开发', 'AI/ML', '不太会'],
    update: (values: string[]) => {
      profile.value.background.knowledgeAreas = values
      profile.value.background.tags = values
    }
  },
  {
    step: 4,
    question: '你觉得你的编程能力在哪个水平？',
    placeholder: '',
    type: 'select' as const,
    options: ['零基础入门', '初级（能写简单程序）', '中级（可独立完成项目）', '高级（可带领团队）'],
    update: (value: string) => {
      profile.value.ability.level = value
      profile.value.ability.tags.push(value)
    }
  },
  {
    step: 5,
    question: '你认为自己最需要提升的薄弱环节是什么？',
    placeholder: '',
    type: 'select' as const,
    options: ['算法与数据结构', '面向对象编程', '数据库设计', '系统架构', '调试能力', '代码质量', '沟通协作'],
    update: (value: string) => {
      profile.value.ability.weakPoints.push(value)
      profile.value.ability.tags.push(`薄弱:${value}`)
    }
  },
  {
    step: 6,
    question: '相对而言，你对哪些方面比较有自信？',
    placeholder: '',
    type: 'select' as const,
    options: ['逻辑思维', '学习新知识', '动手实践', '查找资料', '解决bug', '代码整洁', '创新想法'],
    update: (value: string) => {
      profile.value.ability.strongPoints.push(value)
      profile.value.ability.tags.push(`优势:${value}`)
    }
  },
  {
    step: 7,
    question: '你平时学习新技术时，最喜欢哪种方式？',
    placeholder: '',
    type: 'select' as const,
    options: ['🎬 看视频教程', '📖 阅读官方文档', '💻 边学边敲代码', '👨‍🏫 上课听老师讲', '📚 看技术书籍'],
    update: (value: string) => {
      profile.value.learning.style = value
      profile.value.learning.tags.push(value)
    }
  },
  {
    step: 8,
    question: '学习时，你喜欢什么样的环境？',
    placeholder: '',
    type: 'select' as const,
    options: ['🌙 深夜安静独自学', '☀️ 白天图书馆', '🎧 听音乐学习', '👥 和朋友一起学', '💬 随时可以讨论'],
    update: (value: string) => {
      profile.value.learning.environment = value
      profile.value.learning.tags.push(value)
    }
  },
  {
    step: 9,
    question: '你理想的学习节奏是怎样的？',
    placeholder: '',
    type: 'select' as const,
    options: ['⚡ 突击式：短期高强度集中学习', '🐢 匀速式：每天稳定学习一点', '🎯 任务式：完成一个目标休息', '🌊 波浪式：状态好多学，状态差休息'],
    update: (value: string) => {
      profile.value.rhythm.pace = value
      profile.value.rhythm.tags.push(value)
    }
  },
  {
    step: 10,
    question: '你学习编程的主要目标是什么？',
    placeholder: '',
    type: 'select' as const,
    options: ['🏢 找到好工作', '🎓 提升学术能力', '🚀 做自己的产品', '💡 纯兴趣爱好', '📝 通过考试'],
    update: (value: string) => {
      profile.value.goal.direction = value
      profile.value.goal.tags.push(value)
    }
  },
  {
    step: 11,
    question: '你对哪个方向最感兴趣呢？',
    placeholder: '',
    type: 'select' as const,
    options: ['后端开发', '前端开发', '全栈开发', 'AI/人工智能', '移动端开发', '数据科学', '云计算/DevOps'],
    update: (value: string) => {
      profile.value.goal.specific = value
      profile.value.goal.tags.push(value)
    }
  },
  {
    step: 12,
    question: '你希望多长时间达成你的小目标？',
    placeholder: '',
    type: 'select' as const,
    options: ['1-3个月', '3-6个月', '6-12个月', '1-2年', '长期学习'],
    update: (value: string) => {
      profile.value.goal.timeFrame = value
      profile.value.goal.tags.push(value)
    }
  },
  {
    step: 13,
    question: '除了编程，你还有哪些兴趣爱好？',
    placeholder: '',
    type: 'select' as const,
    options: ['🎮 游戏', '🎵 音乐', '📷 摄影', '🎨 绘画', '🏃 运动', '📖 阅读', '🎬 电影', '🧩 逻辑游戏'],
    update: (value: string) => {
      profile.value.interest.hobbies.push(value)
      profile.value.interest.tags.push(value)
    }
  },
  {
    step: 14,
    question: '你平时喜欢在哪些技术领域探索？',
    placeholder: '',
    type: 'select' as const,
    options: ['开源项目', '科技新闻', '技术博客', '编程竞赛', '技术社群', '产品设计'],
    update: (value: string) => {
      profile.value.interest.fields.push(value)
      profile.value.interest.tags.push(value)
    }
  },
  {
    step: 15,
    question: '完成！',
    placeholder: '',
    type: 'complete' as const,
    options: [],
    update: () => {}
  }
]

function renderMarkdown(text: string) {
  return marked.parse(text) as string
}

function getOptionIcon(option: string): string {
  const iconMap: Record<string, string> = {
    'Python': '🐍', 'Java': '☕', 'C/C++': '⚙️', 'JavaScript/TypeScript': '🌐', 
    'Go': '🚀', 'Rust': '🦀', '数据库': '🗃️', '前端开发': '🎨', 'AI/ML': '🤖',
    '不太会': '📚', '零基础入门': '🌱', '初级（能写简单程序）': '📗',
    '中级（可独立完成项目）': '📘', '高级（可带领团队）': '📙'
  }
  return iconMap[option] || '✅'
}

function scrollToBottom() {
  nextTick(() => {
    if (messagesRef.value) {
      messagesRef.value.scrollTop = messagesRef.value.scrollHeight
    }
  })
}

async function startConversation() {
  await new Promise(resolve => setTimeout(resolve, 1000))
  const stepData = dialogFlow[0]
  messages.value.push({
    role: 'ai',
    content: `### 第 1 步：基本信息\n\n${stepData.question}`
  })
  currentStep.value = 1
  scrollToBottom()
}

function toggleOption(option: string) {
  const index = selectedOptions.value.indexOf(option)
  if (index > -1) {
    selectedOptions.value.splice(index, 1)
  } else {
    selectedOptions.value.push(option)
  }
}

function selectOption(option: string) {
  showOptions.value = false
  handleInput(option)
}

function confirmMultiSelect() {
  if (selectedOptions.value.length === 0) {
    ElMessage.warning('请至少选择一个选项')
    return
  }
  showOptions.value = false
  handleInput([...selectedOptions.value])
  selectedOptions.value = []
}

async function sendMessage() {
  if (!inputMsg.value.trim() || showOptions.value || isTyping.value) return
  handleInput(inputMsg.value)
  inputMsg.value = ''
}

async function handleInput(userInput: string | string[]) {
  const displayInput = Array.isArray(userInput) ? userInput.join('、') : userInput
  messages.value.push({ role: 'user', content: displayInput })
  
  const stepData = dialogFlow[currentStep.value - 1]
  if (stepData.type === 'multiSelect') {
    const values = Array.isArray(userInput) ? userInput : selectedOptions.value
    stepData.update(values)
  } else {
    stepData.update(displayInput)
  }
  
  currentStep.value++
  scrollToBottom()

  if (currentStep.value > totalSteps) {
    await showFinalProfile()
    return
  }

  await showNextQuestion()
}

async function showNextQuestion() {
  isTyping.value = true
  await new Promise(resolve => setTimeout(resolve, 700 + Math.random() * 400))
  isTyping.value = false

  const stepData = dialogFlow[currentStep.value - 1]
  const message = `### 第 ${stepData.step} 步：${stepData.question}`
  messages.value.push({ role: 'ai', content: message })

  if (stepData.type === 'select' || stepData.type === 'multiSelect') {
    currentType.value = stepData.type
    currentOptions.value = stepData.options
    selectedOptions.value = []
    showOptions.value = true
  }

  scrollToBottom()
}

async function showFinalProfile() {
  isTyping.value = true
  await new Promise(resolve => setTimeout(resolve, 1500))
  isTyping.value = false

  const finalMessage = `🎉 **太棒了！画像构建完成！**

以下是为你构建的完整学习画像：

---

## 📊 8 大维度完整画像

| 维度 | 详细描述 |
|------|---------|
| **🎯 基本信息** | ${profile.value.basicInfo.major} ${profile.value.basicInfo.grade} |
| **📚 专业背景** | 掌握 ${profile.value.background.knowledgeAreas.join('、')} |
| **💪 能力评估** | 水平:${profile.value.ability.level}<br>优势:${profile.value.ability.strongPoints.join('、')}<br>待提升:${profile.value.ability.weakPoints.join('、')} |
| **📖 学习风格** | ${profile.value.learning.style} ${profile.value.learning.environment} |
| **⏰ 学习节奏** | ${profile.value.rhythm.pace} |
| **🎯 目标方向** | ${profile.value.goal.direction} → ${profile.value.goal.specific}<br>时间规划: ${profile.value.goal.timeFrame} |
| **⭐ 兴趣爱好** | ${profile.value.interest.hobbies.join('、')} |
| **🔍 技术关注** | ${profile.value.interest.fields.join('、')} |

---

现在，基于你的画像，我将为你生成个性化的技能树和学习路径！准备好了吗？🚀`

  messages.value.push({ role: 'ai', content: finalMessage })
  userStore.setUserProfile(profile.value)

  scrollToBottom()

  await new Promise(resolve => setTimeout(resolve, 4000))
  ElMessage.success('画像保存成功！正在跳转...')
  router.push('/skill-tree')
}

onMounted(() => {
  setTimeout(() => {
    startConversation()
  }, 1200)
})
</script>

<style scoped>
.profile-chat-container {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  background-color: #f5f7fa;
  position: relative;
}

.chat-header {
  padding: 28px 36px;
  background: white;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border-bottom: 1px solid #e4e7ed;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1400px;
  margin: 0 auto;
}

.header-left h2 {
  margin: 0 0 8px 0;
  color: #303133;
  font-size: 26px;
  font-weight: 600;
}

.header-left p {
  margin: 0;
  color: #909399;
  font-size: 14px;
}

.header-right .progress-section {
  display: flex;
  align-items: center;
  gap: 16px;
}

.header-right .progress-text {
  font-size: 15px;
  font-weight: 600;
  color: #409eff;
}

.step-indicator {
  padding: 16px 36px;
  background: white;
  border-bottom: 1px solid #ebeef5;
  display: flex;
  align-items: center;
  gap: 16px;
}

.step-label {
  font-size: 14px;
  color: #606266;
}

.step-tags {
  display: flex;
  gap: 8px;
}

.step-tag {
  padding: 0 16px;
  height: 28px;
  line-height: 26px;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 32px;
  max-width: 1100px;
  margin: 0 auto;
  width: 100%;
  padding-right: 360px;
}

.message-item {
  display: flex;
  gap: 18px;
  margin-bottom: 32px;
}

.message-item.user {
  flex-direction: row-reverse;
}

.avatar {
  flex-shrink: 0;
}

.ai-avatar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  box-shadow: 0 4px 14px rgba(102, 126, 234, 0.35);
}

.user-avatar {
  background: #67c23a;
  color: white;
  box-shadow: 0 4px 14px rgba(103, 194, 58, 0.35);
}

.message-content {
  max-width: 75%;
  padding: 20px 24px;
  border-radius: 16px;
  background-color: white;
  box-shadow: 0 2px 14px rgba(0, 0, 0, 0.06);
  line-height: 1.8;
  font-size: 15px;
  color: #303133;
}

.message-item.user .message-content {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.markdown-content h3 {
  margin: 0 0 16px 0;
  font-size: 19px;
  color: #303133;
  padding-bottom: 10px;
  border-bottom: 2px solid #f0f0f0;
}

.markdown-content p {
  margin: 10px 0;
}

.markdown-content table {
  width: 100%;
  border-collapse: collapse;
  margin: 20px 0;
}

.markdown-content th,
.markdown-content td {
  padding: 12px 16px;
  border: 1px solid #e4e7ed;
  text-align: left;
}

.markdown-content th {
  background: #f5f7fa;
  font-weight: 600;
}

.options-container {
  margin-bottom: 32px;
}

.options-wrapper {
  max-width: 75%;
}

.options-hint {
  color: #909399;
  font-size: 14px;
  margin: 0 0 12px 0;
}

.options-content {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.option-btn {
  padding: 14px 22px;
  border-radius: 28px;
  border: 1px solid #d9d9d9;
  background: white;
  cursor: pointer;
  transition: all 0.25s;
  font-size: 14px;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.option-btn:hover {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-color: #667eea;
  transform: translateY(-3px);
  box-shadow: 0 6px 18px rgba(102, 126, 234, 0.4);
}

.option-btn.selected {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-color: #667eea;
}

.option-btn:active {
  transform: translateY(-1px);
}

.option-icon {
  font-size: 18px;
}

.chat-input-container {
  padding: 24px 36px;
  background: white;
  display: flex;
  gap: 18px;
  border-top: 1px solid #e4e7ed;
  max-width: 1100px;
  margin: 0 auto;
  width: 100%;
  padding-right: 360px;
}

.chat-input-container .el-button {
  min-width: 100px;
}

.typing {
  color: #909399;
  font-style: italic;
}

.dot {
  animation: pulse 1.4s infinite;
  margin-left: 4px;
  display: inline-block;
}

.dot:nth-child(2) {
  animation-delay: 0.2s;
}

.dot:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes pulse {
  0%, 100% { opacity: 0.25; }
  50% { opacity: 1; }
}

.profile-preview {
  position: fixed;
  right: 20px;
  top: 150px;
  width: 300px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  padding: 20px;
  max-height: calc(100vh - 180px);
  overflow-y: auto;
}

.preview-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 14px;
  border-bottom: 2px solid #f0f0f0;
}

.preview-header h3 {
  margin: 0;
  font-size: 17px;
  color: #303133;
}

.preview-sections {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.preview-section {
  padding: 16px;
  background: #fafafa;
  border-radius: 10px;
}

.section-title {
  font-size: 14px;
  color: #606266;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  gap: 6px;
  font-weight: 600;
}

.section-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
</style>
