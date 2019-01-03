FROM golang:1.11

ARG app_env
ENV APP_ENV $app_env
ENV APP_PATH /go/src/github.com/terry6394/botAlert

COPY . ${APP_PATH}
WORKDIR ${APP_PATH}/app

RUN go get ./
RUN go build

CMD if [ "${APP_ENV}" == "production" ]; \
      then \
      app; \
      else \
      go get github.com/pilu/fresh && \
      fresh; \
      fi

EXPOSE 45678
