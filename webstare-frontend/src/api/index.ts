import request from './request'

export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
  timestamp: number
}

export const testApi = {
  hello: () => request.get<ApiResponse>('/test/hello')
}

export const userApi = {
  login: (data: { username: string; password: string }) => request.post<ApiResponse>('/user/login', data),
  register: (data: any) => request.post<ApiResponse>('/user/register', data),
  getInfo: () => request.get<ApiResponse>('/user/info'),
  updateProfile: (data: any) => request.put<ApiResponse>('/user/profile', data)
}

export const aiApi = {
  profileChat: (data: { userId?: string; message: string }) => request.post<ApiResponse>('/ai/profile-chat', data),
  generateSkillTree: (data: { userId?: string }) => request.post<ApiResponse>('/ai/generate-skill-tree', data),
  generateResources: (data: { userId?: string; nodeId: string }) => request.post<ApiResponse>('/ai/generate-resources', data),
  tutorAsk: (data: { userId?: string; question: string; context?: any }) => request.post<ApiResponse>('/ai/tutor-ask', data),
  evaluate: (data: { userId?: string; examData: any }) => request.post<ApiResponse>('/ai/evaluate', data)
}
