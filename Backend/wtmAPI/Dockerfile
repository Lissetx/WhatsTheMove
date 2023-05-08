FROM node:17
ENV apiport=5051
ENV apihost=localhost
WORKDIR /apis/wtmapi
COPY package.json ./
COPY . ./
RUN npm install
EXPOSE 5050
CMD ["npm", "start"]