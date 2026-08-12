# Stage 1: Build & Dependencies
FROM node:22-alpine AS base
WORKDIR /server
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Stage 2: Runtime
FROM node:22-alpine
WORKDIR /server
COPY --from=base /server/node_modules ./node_modules
COPY package*.json ./
COPY . .

EXPOSE 5050
CMD ["npm", "run", "start"]
