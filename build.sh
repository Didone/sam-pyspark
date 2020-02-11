DEPLOY_BUCKET="didone-spark-sam"
BUILD_PATH=".aws-sam/build/layer"
APP_NAME="pyspark-app"
aws cloudformation delete-stack --stack-name $APP_NAME
rm -Rf .aws-sam
# Create bucket to deploy
aws s3 mb "s3://${DEPLOY_BUCKET}"
# Build lambdas
sam build
# Build layers
mkdir -p ${BUILD_PATH}
cp -Rf bin/ ${BUILD_PATH}/bin/
cp -Rf conf/ ${BUILD_PATH}/conf/
cp bootstrap ${BUILD_PATH}/bootstrap
unzip -o libs/python.zip -d .aws-sam/build/layer
unzip -o libs/java.zip -d .aws-sam/build/layer
cd ${BUILD_PATH}
chmod u+x bin/*.*
chmod u+x bootstrap
zip -r -9 ../spark.zip . -x \*.pyc
zip -r -9 ../java.zip .
aws s3 mv ../spark.zip s3://didone-spark/spark.zip
cd ../../../
# Change the runtime python2.7 to 'provided'
sed 's+ python2.7+ provided+g' template.yaml > template.tmp
# Package and generate the template for cloudformation
sam package \
    --template template.tmp \
    --output-template-file packaged.yaml \
    --s3-bucket $DEPLOY_BUCKET
#Deploy
aws cloudformation create-stack \
    --stack-name $APP_NAME \
    --template-body file://packaged.yaml \
    --tags Key=project,Value=pyspark \
    --parameters ParameterKey=AccessKey,ParameterValue=$AWS_ACCESS_KEY_ID ParameterKey=SecretKey,ParameterValue=$AWS_SECRET_ACCESS_KEY
    --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" "CAPABILITY_AUTO_EXPAND"
aws cloudformation describe-stacks --stack-name $APP_NAME --output table