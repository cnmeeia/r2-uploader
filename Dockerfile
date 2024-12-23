# Stage 1: Build
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /usr/src/app

# 安装构建所需的依赖
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# 复制项目文件并进行构建
COPY . .
RUN yarn build

# Stage 2: Final Image
FROM node:18-alpine

# 设置工作目录
WORKDIR /usr/src/app

# 只复制生产环境所需文件
COPY --from=builder /usr/src/app/dist ./dist
RUN yarn global add serve

# 暴露端口
EXPOSE 7896

# 运行生产服务器
CMD ["serve", "-s", "dist", "-l", "7896"]