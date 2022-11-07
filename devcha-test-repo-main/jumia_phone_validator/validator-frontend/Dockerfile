FROM node:alpine
WORKDIR /validator-frontend
RUN npm run build
COPY ./build .
RUN npm i serve -g
CMD ["serve", "-s", "-l", "8081"]
