FROM tomcat:8-jre8

MAINTAINER warren.strange@gmail.com

ENV JAVA_OPTS="-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode"
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

EXPOSE 8080

# download openam nightly build war
# Trick taken from wadahiro/docker-openam-nightly!

# Temporary commented not to donwload the nightly build, to load a stable version instead
#RUN curl http://download.forgerock.org/downloads/openam/openam_link.js | \
#   grep -o "http://.*\.war" | xargs curl -o webapps/openam.war

#RUN curl https://github.com/OpenRock/OpenAM/releases/download/13.0.0/OpenAM-13.0.0.war -o webapps/openam.war
# ADD https://github.com/OpenRock/OpenAM/releases/download/13.0.0/OpenAM-13.0.0.war webapps/openam.war
ADD OpenAM-13.5.0.war webapps/openam.war

COPY config /root/openam

ADD run-openam.sh /tmp/run-openam.sh

RUN chmod +x /tmp/run-openam.sh

# Here we are overriding text.js lib because of a known OPENAM issue in OPENAM-13.0.0, this is supposed
# to be fixed for OPENAM-13.5.0+
# We have implemented solution 3) from:
# https://bugster.forgerock.org/jira/browse/OPENAM-8371
# Here is just copied to a temp folder, in run-openam.sh is copied to the final destination as this needs to be
# done after the OPENAM war has been deployed to Tomcat
# COPY text.js /tmp/text.js

# Configuration to expose 80 port
COPY server.xml /usr/local/tomcat/conf/server.xml

# Configuration to expose 80 port
COPY server.xml /usr/local/tomcat/conf/server.xml

CMD ["/tmp/run-openam.sh"]