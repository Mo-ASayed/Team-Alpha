FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY yarn.lock ./
RUN yarn install

COPY . .

RUN yarn build

FROM node:18-alpine AS production

RUN yarn global add serve

WORKDIR /app

COPY --from=builder /app/build ./build

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
