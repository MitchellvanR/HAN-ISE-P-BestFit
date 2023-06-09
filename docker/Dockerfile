FROM mcr.microsoft.com/mssql/server:2019-latest

ENV ACCEPT_EULA y
ENV SA_PASSWORD BestFitSAExamplePassword0?
# When deploying to production, change SA_PASSWORD to a strong password and store it in a secure manner.

USER root

RUN apt-get update && \
    apt-get install -y \
    dos2unix  \
    mssql-tools  \
    unixodbc-dev && \
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