FROM golang:1.11

ARG app_env
ENV APP_ENV $app_env
ENV APP_PATH /go/src/github.com/terry6394/botAlert

COPY . ${APP_PATH}/
WORKDIR ${APP_PATH}/app

RUN go get ./
RUN go build

# Get fresh when non-production build.
RUN if [ "${app_env}" != production ] ; \
      then \
      go get github.com/pilu/fresh ; \
    fi


CMD if [ "${APP_ENV}" != production ] ; \
      then \
        go get github.com/pilu/fresh && fresh; \
      else \
        ./app; \
    fi

EXPOSE 45678
