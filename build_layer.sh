BUILD_PATH=".aws-sam/build/layer"
mkdir -p ${BUILD_PATH}
cp -Rf bin/ ${BUILD_PATH}/bin/
cp -Rf conf/ ${BUILD_PATH}/conf/
cp bootstrap ${BUILD_PATH}/bootstrap
unzip -o -q libs/python.zip -d .aws-sam/build/layer
unzip -o -q libs/java.zip -d .aws-sam/build/layer
cd ${BUILD_PATH}
chmod u+x bin/*.*
chmod u+x bootstrap
zip -r -9 -q ../spark.zip . -x \*.pyc
zip -r -9 -q ../java.zip .
aws s3 mv ../spark.zip s3://didone-spark/spark.zip
cd ../../../
