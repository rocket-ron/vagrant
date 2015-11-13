#! /bin/bash

wget -qO - http://www.carfab.com/apachesoftware/hadoop/common/hadoop-2.6.2/hadoop-2.6.2-src.tar.gz | tar -xz
mv hadoop-2.6.2-src hadoop-2.6.2
#
# https://www.ibm.com/developerworks/community/blogs/e90753c6-a6f1-4ae2-81d4-86eb33cf313c/entry/apache_spark_integrartion_with_softlayer_object_store?lang=en
#
wget -P ./hadoop-2.6.2/hadoop-tools https://issues.apache.org/jira/secure/attachment/12754028/HADOOP-10420-012.patch
cd hadoop-2.6.2/hadoop-tools
git apply HADOOP-10420-012.patch
cd hadoop-openstack && mvn -DskipTests package && mvn -DskipTests install 
cd
git clone git://github.com/apache/spark.git -b branch-1.5
cd spark
#
# MISSING: need to modify the POM.xml file to add the hadoop-openstack dependency
# https://spark.apache.org/docs/latest/storage-openstack-swift.html?cm_mc_uid=14663886429214294671460&cm_mc_sid_50200000=1446879446
#
build/mvn -Pyarn -Phadoop-2.6 -Dhadoop.version=2.6.2 -DskipTests clean package
echo export SPARK_HOME=\"/usr/local/spark\" >> /root/.bash_profile