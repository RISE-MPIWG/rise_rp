FROM nginx:alpine

MAINTAINER pbelouin
COPY nginx.conf /etc/nginx/nginx.conf
COPY rise-rp.pem /etc/ssl/rise-rp.pem
COPY rise-rp.csr /etc/ssl/rise-rp.csr
COPY rise-rp.key /etc/ssl/rise-rp.key
CMD [ "nginx", "-g", "daemon off;" ]