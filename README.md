# SAM PySpark

Serverless PySpark

## Requirements

* SAM CLI - [Install the SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
* [Python installed](https://www.python.org/downloads/)
* Docker - [Install Docker community edition](https://hub.docker.com/search/?type=edition&offering=community)

## Environment

Create you Python environment for development

```bash
virtualenv -p python2.7 .env
source .env/bin/activate
pip install -U -r requirements.txt
aws s3 cp s3://didone-spark/drivers.zip libs/
aws s3 cp s3://didone-spark/java.zip libs/
aws s3 cp s3://didone-spark/python.zip libs/
```

## Build

```sh
rm -Rf .aws-sam
# Create bucket to deploy
DEPLOY_BUCKET=didone-spark-sam
aws s3 mb "s3://${DEPLOY_BUCKET}"
# Build lambdas
sam build
# Change the runtime python2.7 to 'provided'
sed 's+ python2.7+ provided+g' template.yaml > template.tmp
# Package and generate the template for cloudformation
sam package --template template.tmp --output-template-file packaged.yaml --s3-bucket $DEPLOY_BUCKET
```

## Deploy

You can use the AWS *Cloudformation* to manage your deployments as **Application Stacks** using the [packaged.yaml](packaged.yaml) file

```sh
# Create stack
aws cloudformation create-stack --stack-name pyspark-app --template-body file://packaged.yaml --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" "CAPABILITY_AUTO_EXPAND"
# View stack
aws cloudformation describe-stacks --stack-name pyspark-app --output table
```

```sh
# Remove stack
aws cloudformation delete-stack --stack-name pyspark-app
```