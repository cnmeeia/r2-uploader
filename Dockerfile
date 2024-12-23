# Stage 1: Build
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /usr/src/app

# 安装依赖
COPY package.json ./
COPY yarn.lock ./
RUN yarn install --frozen-lockfile || yarn install

# 复制代码并构建
COPY . .
RUN yarn build

# Stage 2: Production
FROM node:18-alpine

# 设置工作目录
WORKDIR /usr/src/app

# 复制生产构建结果
COPY --from=builder /usr/src/app/dist ./dist
RUN yarn global add serve

# 暴露端口
EXPOSE 7896

# 运行应用
CMD ["serve", "-s", "dist", "-l", "7896"]