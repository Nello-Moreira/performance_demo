FROM node:20.12.2-alpine3.19
WORKDIR /app
COPY ./server .
RUN apk update && apk upgrade && apk add curl=8.5.0-r0
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=2s CMD curl --fail http://localhost:$PORT/ping || exit 1
CMD [ "node", "index.js" ]