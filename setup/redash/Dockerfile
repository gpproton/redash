FROM redash/redash:preview

USER root

RUN apt-get update  -y
RUN apt-get install -y unzip

# Oracle instantclient
RUN mkdir -p /tmp/oracle
ADD oracle/instantclient-basic-linux.x64-18.3.0.0.0dbru.zip /tmp/oracle/instantclient-basic-linux.x64-18.3.0.0.0dbru.zip
ADD oracle/instantclient-sdk-linux.x64-18.3.0.0.0dbru.zip /tmp/oracle/instantclient-sdk-linux.x64-18.3.0.0.0dbru.zip
ADD oracle/instantclient-sqlplus-linux.x64-18.3.0.0.0dbru.zip /tmp/oracle/instantclient-sqlplus-linux.x64-18.3.0.0.0dbru.zip

RUN unzip /tmp/oracle/instantclient-basic-linux.x64-18.3.0.0.0dbru.zip -d /usr/local/
RUN unzip /tmp/oracle/instantclient-sdk-linux.x64-18.3.0.0.0dbru.zip -d /usr/local/
RUN unzip /tmp/oracle/instantclient-sqlplus-linux.x64-18.3.0.0.0dbru.zip -d /usr/local/
RUN ln -s /usr/local/instantclient_18_3 /usr/local/instantclient
RUN rm /usr/local/instantclient/libclntsh.so
RUN ln -s /usr/local/instantclient/libclntsh.so.18.1 /usr/local/instantclient/libclntsh.so
RUN ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus

RUN apt-get install libaio-dev -y
RUN apt-get clean -y

ENV ORACLE_HOME=/usr/local/instantclient
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/instantclient

RUN pip install cx_Oracle

USER redash
#Add REDASH ENV to add Oracle Query Runner 
ENV REDASH_ADDITIONAL_QUERY_RUNNERS=redash.query_runner.oracle
