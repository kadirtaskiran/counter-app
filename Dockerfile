FROM node:11.1.0-alpine as build

WORKDIR /app

COPY package*.json /app/

RUN npm install

COPY ./ /app/

RUN npm run build

FROM nginx:1.15.8-alpine

COPY --from=build /app/public /usr/share/nginx/html/
COPY --from=build /app/build/index.html /usr/share/nginx/html/index.html
COPY --from=build /app/build /usr/share/nginx/html/counter-app
COPY --from=build /app/nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]