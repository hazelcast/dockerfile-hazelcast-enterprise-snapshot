FROM maven:3-openjdk-8 AS build-env

ARG SOURCE_BRANCH=master
ARG GITHUB_TOKEN=xxx

RUN apt-get update && apt-get install -y git
RUN git clone -b "$SOURCE_BRANCH" --depth 1 https://$GITHUB_TOKEN@github.com/hazelcast/hazelcast-enterprise.git
RUN mvn -B -f hazelcast-enterprise/pom.xml clean install -DskipTests && \
  rm hazelcast-enterprise/hazelcast-enterprise-all/target/original-*.jar && \
  rm hazelcast-enterprise/hazelcast-enterprise-all/target/*-tests.jar && \
  mkdir /app && \
  mv hazelcast-enterprise/hazelcast-enterprise-all/target/hazelcast-enterprise-all-*.jar /app/hazelcast-enterprise-all.jar

# https://github.com/GoogleContainerTools/distroless/tree/master/java
# https://github.com/GoogleContainerTools/distroless/blob/master/examples/java/Dockerfile

FROM gcr.io/distroless/java:11
COPY --from=build-env /app /opt/hazelcast
WORKDIR /opt/hazelcast
ENTRYPOINT ["/usr/bin/java", \
  "--add-modules", "java.se", \
  "--add-exports", "java.base/jdk.internal.ref=ALL-UNNAMED", \
  "--add-opens", "java.base/java.lang=ALL-UNNAMED", \
  "--add-opens", "java.base/java.nio=ALL-UNNAMED", \
  "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED", \
  "--add-opens", "java.management/sun.management=ALL-UNNAMED", \
  "--add-opens", "jdk.management/com.sun.management.internal=ALL-UNNAMED" ]

CMD ["-jar", "hazelcast-enterprise-all.jar"]
