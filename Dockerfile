
# Stage 1: Builder
FROM node:18-alpine AS builder

WORKDIR /usr/src/app

# 只复制 package.json 和 yarn.lock
COPY package.json yarn.lock ./

# 安装依赖
RUN yarn install --frozen-lockfile --production

# 复制源代码
COPY . .

# 构建应用
RUN yarn build

# Stage 2: Production
FROM node:18-alpine

WORKDIR /usr/src/app

# 只复制构建产物
COPY --from=builder /usr/src/app/dist ./dist

# 安装 serve
RUN yarn global add serve

# 清理不必要的文件
RUN rm -rf /usr/src/app/node_modules

EXPOSE 7896

CMD ["serve", "-s", "dist", "-l", "7896"]
