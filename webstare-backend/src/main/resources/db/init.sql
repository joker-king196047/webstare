-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名/学号',
  `password` VARCHAR(255) NOT NULL COMMENT '密码',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0-禁用 1-启用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 用户画像表
CREATE TABLE IF NOT EXISTS `user_profile` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `knowledge_base` JSON DEFAULT NULL COMMENT '知识基础 {"Python": "初级"}',
  `weak_points` JSON DEFAULT NULL COMMENT '薄弱点数组',
  `cognitive_style` VARCHAR(50) DEFAULT NULL COMMENT '认知风格：视觉型/实践型等',
  `learning_goal` VARCHAR(255) DEFAULT NULL COMMENT '学习目标',
  `interests` JSON DEFAULT NULL COMMENT '兴趣领域',
  `learning_pace` VARCHAR(20) DEFAULT NULL COMMENT '学习节奏：快/中/慢',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户画像表';

-- 技能树节点表
CREATE TABLE IF NOT EXISTS `knowledge_tree_node` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父节点ID，0为根节点',
  `name` VARCHAR(100) NOT NULL COMMENT '知识点名称',
  `subject` VARCHAR(50) NOT NULL COMMENT '所属课程/学科',
  `status` TINYINT DEFAULT 0 COMMENT '状态 0-未学 1-学习中 2-已掌握',
  `user_id` BIGINT NOT NULL COMMENT '用户ID（个性化树）',
  `resources` JSON DEFAULT NULL COMMENT '关联资源ID集合',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='技能树节点表';

-- 题库表
CREATE TABLE IF NOT EXISTS `question_bank` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `subject` VARCHAR(50) NOT NULL COMMENT '学科',
  `tags` JSON DEFAULT NULL COMMENT '知识点标签数组',
  `difficulty` TINYINT DEFAULT 1 COMMENT '难度 1-简单 2-中等 3-困难',
  `content` TEXT NOT NULL COMMENT '题面（Markdown）',
  `options` JSON DEFAULT NULL COMMENT '选项（单选/多选）',
  `answer` TEXT NOT NULL COMMENT '答案与解析',
  `question_type` VARCHAR(20) DEFAULT '单选' COMMENT '题型：单选/多选/填空/编程',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_subject` (`subject`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题库表';

-- 知识点标签表
CREATE TABLE IF NOT EXISTS `knowledge_tag` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(50) NOT NULL COMMENT '标签名称',
  `subject` VARCHAR(50) NOT NULL COMMENT '所属学科',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识点标签表';

-- 学习记录表
CREATE TABLE IF NOT EXISTS `study_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `node_id` BIGINT DEFAULT NULL COMMENT '技能树节点ID',
  `resource_type` VARCHAR(20) DEFAULT NULL COMMENT '资源类型：文档/视频/PPT',
  `resource_id` VARCHAR(100) DEFAULT NULL COMMENT '资源ID',
  `study_duration` INT DEFAULT 0 COMMENT '学习时长（秒）',
  `study_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '学习时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习记录表';

-- 测验记录表
CREATE TABLE IF NOT EXISTS `exam_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `node_id` BIGINT DEFAULT NULL COMMENT '技能树节点ID',
  `score` INT DEFAULT 0 COMMENT '得分',
  `total_score` INT DEFAULT 100 COMMENT '总分',
  `pass_rate` DECIMAL(5,2) DEFAULT NULL COMMENT '通过率',
  `expected_pass_rate` DECIMAL(5,2) DEFAULT NULL COMMENT '预期通过率',
  `weak_points` JSON DEFAULT NULL COMMENT '薄弱点',
  `exam_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '测验时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='测验记录表';

-- 答题明细表
CREATE TABLE IF NOT EXISTS `answer_detail` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `exam_record_id` BIGINT NOT NULL COMMENT '测验记录ID',
  `question_id` BIGINT NOT NULL COMMENT '题目ID',
  `user_answer` TEXT DEFAULT NULL COMMENT '用户答案',
  `is_correct` TINYINT DEFAULT 0 COMMENT '是否正确 0-否 1-是',
  `answer_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间',
  PRIMARY KEY (`id`),
  KEY `idx_exam_record_id` (`exam_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='答题明细表';
