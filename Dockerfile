FROM node:12 as frontend-builder

WORKDIR /frontend
COPY package.json package-lock.json /frontend/
RUN npm install

COPY client /frontend/client
COPY webpack.config.js /frontend/
RUN npm run build

FROM python:3.7-slim

EXPOSE 5000

# Controls whether to install extra dependencies needed for all data sources.
ARG skip_ds_deps

RUN useradd --create-home redash

# Ubuntu packages
RUN apt-get update && \
  apt-get install -y \
    curl \
    unzip \
    libaio-dev \
    gnupg \
    build-essential \
    pwgen \
    libffi-dev \
    sudo \
    git-core \
    wget \
    # Postgres client
    libpq-dev \
    # for SAML
    xmlsec1 \
    # Additional packages required for data sources:
    libssl-dev \
    default-libmysqlclient-dev \
    freetds-dev \
    libsasl2-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir -p /tmp/oracle

WORKDIR /app

# We first copy only the requirements file, to avoid rebuilding on every file
# change.
COPY requirements.txt requirements_bundles.txt requirements_dev.txt requirements_all_ds.txt ./
RUN pip install -r requirements.txt -r requirements_dev.txt
RUN if [ "x$skip_ds_deps" = "x" ] ; then pip install -r requirements_all_ds.txt ; else echo "Skipping pip install -r requirements_all_ds.txt" ; fi

COPY . /app
COPY --from=frontend-builder /frontend/client/dist /app/client/dist
RUN chown -R redash /app

##Modification starts
##RUN apt-get update  -y && apt-get install -y unzip && mkdir -p /tmp/oracle
ADD oracle /tmp/oracle/
RUN unzip /tmp/oracle/instantclient-basic-linux.x64-18.3.0.0.0dbru.zip -d /usr/local/ \
&& unzip /tmp/oracle/instantclient-sdk-linux.x64-18.3.0.0.0dbru.zip -d /usr/local/ \
&& unzip /tmp/oracle/instantclient-sqlplus-linux.x64-18.3.0.0.0dbru.zip -d /usr/local/ \
&& ln -s /usr/local/instantclient_18_3 /usr/local/instantclient \
&& rm /usr/local/instantclient/libclntsh.so \
&& ln -s /usr/local/instantclient/libclntsh.so.18.1 /usr/local/instantclient/libclntsh.so \
&& ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
##&& apt-get install libaio-dev -y \
&& apt-get clean -y
ENV ORACLE_HOME=/usr/local/instantclient
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/instantclient
RUN pip install cx_Oracle
#Add REDASH ENV to add Oracle Query Runner 
ENV REDASH_ADDITIONAL_QUERY_RUNNERS=redash.query_runner.oracle
##Modification ends

USER redash

ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["server"]
