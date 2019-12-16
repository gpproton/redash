FROM redash/redash:latest
LABEL maintainer="Godwin peter .O <me@godwin.dev>"
USER root
RUN apt-get update  -y && apt-get install -y unzip && mkdir -p /tmp/oracle
ADD oracle /tmp/oracle/
RUN unzip /tmp/oracle/instantclient-basic-linux.x64-18.3.0.0.0dbru.zip -d /usr/local/ \
&& unzip /tmp/oracle/instantclient-sdk-linux.x64-18.3.0.0.0dbru.zip -d /usr/local/ \
&& unzip /tmp/oracle/instantclient-sqlplus-linux.x64-18.3.0.0.0dbru.zip -d /usr/local/ \
&& ln -s /usr/local/instantclient_18_3 /usr/local/instantclient \
&& rm /usr/local/instantclient/libclntsh.so \
&& ln -s /usr/local/instantclient/libclntsh.so.18.1 /usr/local/instantclient/libclntsh.so \
&& ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
&& apt-get install libaio-dev -y \
&& apt-get clean -y
ENV ORACLE_HOME=/usr/local/instantclient
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/instantclient
RUN pip install cx_Oracle
USER redash
#Add REDASH ENV to add Oracle Query Runner 
ENV REDASH_ADDITIONAL_QUERY_RUNNERS=redash.query_runner.oracle
