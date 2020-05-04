FROM node:11-slim

# Set working dir
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json

# Install yarn then install deps
RUN npm install yarn -g
RUN yarn install react-scripts -g
RUN yarn install
COPY . /usr/src/app

# Build app
RUN yarn build

### STAGE 2: Production Environment ###
FROM nginx:1.13.12-alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]