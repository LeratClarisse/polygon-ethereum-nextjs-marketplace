# Install dependencies only when needed
FROM node:16-alpine AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /polygon-ethereum-nextjs-marketplace
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# If using npm with a `package-lock.json` comment out above and use below instead
# COPY package.json package-lock.json ./ 
# RUN npm ci

# Rebuild the source code only when needed
FROM node:16-alpine AS builder
WORKDIR /polygon-ethereum-nextjs-marketplace
COPY --from=deps /polygon-ethereum-nextjs-marketplace/node_modules ./node_modules
COPY . .

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry during the build.
ENV NEXT_TELEMETRY_DISABLED 1

RUN yarn build

# Production image, copy all the files and run next
FROM node:16-alpine AS runner
WORKDIR /polygon-ethereum-nextjs-marketplace

ENV NODE_ENV development
# Uncomment the following line in case you want to disable telemetry during runtime.
ENV NEXT_TELEMETRY_DISABLED 1

# You only need to copy next.config.js if you are NOT using the default configuration
COPY --from=builder /polygon-ethereum-nextjs-marketplace/next.config.js ./
COPY --from=builder /polygon-ethereum-nextjs-marketplace/public ./public
COPY --from=builder /polygon-ethereum-nextjs-marketplace/package.json ./package.json
COPY --from=builder /polygon-ethereum-nextjs-marketplace/node_modules ./node_modules
COPY --from=builder /polygon-ethereum-nextjs-marketplace ./


# Automatically leverage output traces to reduce image size 
# https://nextjs.org/docs/advanced-features/output-file-tracing
#COPY --from=builder --chown=nextjs:nodejs /polygon-ethereum-nextjs-marketplace/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /polygon-ethereum-nextjs-marketplace/.next/static ./.next/static


EXPOSE 3000

ENV PORT 3000

CMD ["yarn", "dev"]