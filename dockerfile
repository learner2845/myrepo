FROM ubuntu
LABEL author=learner2845
RUN apt-get update -y && apt-get install nginx -y
