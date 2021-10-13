
mvn install:install-file -Dfile=${basedir}/lib/jt400.jar -Dsources=${basedir}/lib/source/jtopen_7_4_source.zip -Djavadoc=${basedir}/lib/javadoc/jtopen_7_4_javadoc.zip -DgroupId=net.sf -DartifactId=jt400 -Dversion=7.4 -Dpackaging=jar


mvn install:install-file -Dfile=${basedir}/lib/jtopen7.9/jtopen_7_9/lib/jt400.jar -Dsources=${basedir}/lib/jtopen7.9/jtopen_7_9_source.zip -Djavadoc=${basedir}/lib/jtopen7.9/jtopen_7_9_javadoc.zip -DgroupId=net.sf -DartifactId=jt400 -Dversion=7.9 -Dpackaging=jar


mvn install:install-file -Dfile=${basedir}/jtopen_7_9/lib/jt400.jar -Dsources=${basedir}/jtopen_7_9_source.zip -Djavadoc=${basedir}/jtopen_7_9_javadoc.zip -DgroupId=net.sf -DartifactId=jt400 -Dversion=7.9 -Dpackaging=jar