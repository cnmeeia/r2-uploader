FROM node:18-alpine AS builder

WORKDIR /usr/src/app

COPY package.json ./

RUN yarn install

COPY . .

RUN yarn build

FROM node:18-alpine

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/dist ./dist

RUN yarn global add serve

EXPOSE 7896

CMD ["serve", "-s", "dist", "-l", "7896"]