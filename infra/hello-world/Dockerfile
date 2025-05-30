# Build arguments
ARG NODE_ENV=production
ARG PORT=3000

# Stage 1: Build environment
FROM node:18-alpine AS builder

WORKDIR /app


# Copy package files first to leverage Docker cache
COPY package.json yarn.lock ./

# Install dependencies (including devDependencies for building)
RUN yarn install --frozen-lockfile --production=false

# Copy all source files
COPY . .

# Stage 2: Production environment
FROM node:18-alpine

WORKDIR /app

# Install production dependencies only
COPY --from=builder /app/package.json /app/yarn.lock ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/app.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/views ./views

# Create a non-root user and switch to it
RUN addgroup -g 1001 -S nodejs && \
    adduser -u 1001 -S nodejs -G nodejs && \
    chown -R nodejs:nodejs /app

USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/ || exit 1

EXPOSE ${PORT}

CMD ["node", "app.js"]