FROM node:17
ENV apiport=5051
ENV apihost=localhost
WORKDIR /apis/wtmapi
RUN npm install
COPY . ./
EXPOSE 5050
CMD ["npm", "start"]