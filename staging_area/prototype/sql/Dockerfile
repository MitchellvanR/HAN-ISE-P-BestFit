FROM mcr.microsoft.com/mssql/server:2019-latest

ENV ACCEPT_EULA y
ENV SA_PASSWORD ISE_project

USER root

RUN apt-get update && \
    apt-get install dos2unix && \
    apt-get clean

WORKDIR /usr/src/app

COPY ./entrypoint.sh ./entrypoint.sh
COPY ./run-init.sh ./run-init.sh

RUN dos2unix ./entrypoint.sh
RUN dos2unix ./run-init.sh

RUN ["chmod", "+x", "./entrypoint.sh"]
RUN ["chmod", "+x", "./run-init.sh"]

EXPOSE 1433
CMD ["/bin/bash", "./entrypoint.sh"]