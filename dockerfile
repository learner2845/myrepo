FROM ubuntu
LABEL author=learner
RUN apt-get update -y && apt-get install nginx -y
