# Build stage
FROM node:20-alpine AS builder
WORKDIR /app

# Build arguments
ARG NEXT_PUBLIC_API_URL
ARG NEXT_PUBLIC_SITE_URL
ARG RESEND_API_KEY=re_placeholder_for_build

COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install

COPY . .

# Set build-time environment variables
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL \
    NEXT_PUBLIC_SITE_URL=$NEXT_PUBLIC_SITE_URL \
    RESEND_API_KEY=$RESEND_API_KEY \
    NEXT_TELEMETRY_DISABLED=1

RUN pnpm build

# Run stage
FROM node:20-alpine
WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/package.json /app/pnpm-lock.yaml ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# Runtime environment variables
ENV NODE_ENV=production \
    PORT=3000

EXPOSE 3000

CMD ["npx", "next", "start"]
