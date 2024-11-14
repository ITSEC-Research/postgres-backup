#=========GOOGLE CLOUD CLI========#
FROM ubuntu:22.04 as upload
RUN apt-get update
RUN apt-get install apt-transport-https ca-certificates gnupg nano curl -y
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get update && apt-get install google-cloud-cli -y
ENV BOTO_CONFIG=/root/.boto

#=========POSTGRES========#
RUN curl -fSsL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /usr/share/keyrings/postgresql.gpg > /dev/null
RUN echo deb [arch=amd64,arm64,ppc64el signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main | tee /etc/apt/sources.list.d/postgresql.list
RUN apt-get update
# Make sure using right postgres version
RUN apt-get install postgresql-client-15 -y

#=========COPY FILES========#
COPY postgres-backup.sh /root/postgres-backup.sh

#=========GIVE ROOT ACCESS========#
USER root
