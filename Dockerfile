# Dockerfile for production

# BUILD PHASE

# NOTE: The build phase is only used for the build process

# NOTE: In the end, this intermediate build container will be disposed of

FROM node:alpine as builder

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY --chown=node:node ./package.json ./

RUN npm install

COPY --chown=node:node ./ ./

USER node

RUN npm run build



# RUN PHASE

# NOTE: This finalized container will be kept and run

# NOTE: The finalized production code will be run on this container

FROM nginx

# Reference to copy files from the build phase
COPY --from=builder /home/node/app/build /usr/share/nginx/html

# No need to have an instruction to start nginx. The nginx image will automatically start it.
