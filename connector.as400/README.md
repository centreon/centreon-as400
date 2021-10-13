# Tools

## Launch test

### Build

    mvn clean package

### Execute

    java \
      -DCONNECTOR_ETC=target/test-classes/ \
      -DCONNECTOR_HOME=target/test-classes/ \
      -DCONNECTOR_LOG=target/test-classes/ \
      -DCONNECTOR_TMP=target/test-classes/ \
      -jar target/connector-as400-1.8.4-jar-with-dependencies.jar \
      -I -H localhost -l LOGIN -p PASSWORD -A '80!90' -C cpuUsage

## References

[IBM knowledge center example](https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_72/rzahh/pcsystemstatexample.htm)
