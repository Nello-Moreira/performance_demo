FROM node:20.12.2-alpine3.19
WORKDIR /app
RUN npm install -g artillery@2.0.10
COPY ./performance_tests .
CMD [ "sh", "run_tests.sh" ]