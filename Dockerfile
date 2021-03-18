FROM gcr.io/distroless/java:11
COPY hazelcast-enterprise-all.jar /opt/hazelcast/
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
