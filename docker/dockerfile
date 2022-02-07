FROM node:lts as dependencies
WORKDIR /polygon-ethereum-nextjs-marketplace
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:lts as builder
WORKDIR /polygon-ethereum-nextjs-marketplace
COPY . .
COPY --from=dependencies /polygon-ethereum-nextjs-marketplace/node_modules ./node_modules
RUN yarn build

FROM node:lts as runner
WORKDIR /polygon-ethereum-nextjs-marketplace
ENV NODE_ENV production

COPY --from=builder /polygon-ethereum-nextjs-marketplace/next.config.js ./
COPY --from=builder /polygon-ethereum-nextjs-marketplace/public ./public
COPY --from=builder /polygon-ethereum-nextjs-marketplace/.next ./.next
COPY --from=builder /polygon-ethereum-nextjs-marketplace/node_modules ./node_modules
COPY --from=builder /polygon-ethereum-nextjs-marketplace/package.json ./package.json

EXPOSE 3000
CMD ["yarn", "dev"]