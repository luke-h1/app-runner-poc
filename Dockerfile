FROM --platform=linux/amd64 node:20.11.0-alpine AS base



ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable


FROM base AS builder
COPY package.json .
COPY pnpm-lock.yaml .
COPY . .

RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm --prod --ignore-scripts --frozen-lockfile install

ENV NODE_ENV=production
ENV TZ=Europe/London

USER node 
CMD ["node", "src/index.js"]
