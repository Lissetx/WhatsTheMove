FROM node:17
WORKDIR /apis/consumerservice
COPY package.json ./
RUN npm install
COPY . ./
EXPOSE 5000
CMD ["node", "index.js"]