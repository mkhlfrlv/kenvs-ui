FROM node:16

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY package.json ./
COPY package-lock.json ./
RUN npm install
RUN npm install -g http-server

COPY . ./

RUN npm run build

CMD ["http-server", "dist", "-p", "8080"]