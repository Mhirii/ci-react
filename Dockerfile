FROM nginx:1.25.4-alpine3.18
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY ./dist /var/www/html/
EXPOSE 80
ENTRYPOINT ["nginx","-g","daemon off;"]
