FROM redash/redash:preview
LABEL maintainer="Godwin peter .O <me@godwin.dev>"
USER root
RUN apt-get update  -y && apt-get install -y unzip curl \
&& mkdir -p /tmp/oracle && cd /tmp/oracle \
&& curl -L https://raw.github.com/gpproton/php7-with-oci8/master/instantclient/19.3.0.0.0/instantclient-basiclite-linux.x64-19.3.0.0.0dbru.zip -O \
&& curl -L https://raw.github.com/gpproton/php7-with-oci8/master/instantclient/19.3.0.0.0/instantclient-sdk-linux.x64-19.3.0.0.0dbru.zip -O \
&& curl -L https://raw.github.com/gpproton/php7-with-oci8/master/instantclient/19.3.0.0.0/instantclient-sqlplus-linux.x64-19.3.0.0.0dbru.zip -O \
&& unzip '*.zip' -d /usr/local/ \
&& ln -s /usr/local/instantclient_19_3 /usr/local/instantclient \
&& ln -s /usr/local/instantclient/lib* /usr/lib \
&& ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
&& echo 'export LD_LIBRARY_PATH="/usr/local/instantclient"' >> /root/.bashrc \
&& echo 'umask 002' >> /root/.bashrc \
&& echo '/usr/local/instantclient/' >> /etc/ld.so.conf.d/oracle-instantclient.conf \
&& rm -rf /tmp/oracle \
&& apt-get clean -y
# End oracle installation
ENV ORACLE_HOME=/usr/local/instantclient
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/instantclient
RUN pip install cx_Oracle
USER redash
#Add REDASH ENV to add Oracle Query Runner 
ENV REDASH_ADDITIONAL_QUERY_RUNNERS=redash.query_runner.oracle
