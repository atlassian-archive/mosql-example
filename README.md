# Overview

This repo serves as an example of how to replicate data from MongoDB to
PostgreSQL. For more information, see the webinar: http://landing.chartio.com/slides-compose-switched-from-mongodb-to-postgres.

# Usage

- Spin up an AWS VPC isolated from the rest of your infrastructure:
  ```
  aws --region us-west-2 cloudformation create-stack \
  --stack-name mosql-example \
  --template-body file://./cf.json \
  --parameters \
  ParameterKey=LocalIP,ParameterValue=<YOUR_LOCAL_IP_ADDRESS> \
  ParameterKey=KeyName,ParameterValue=<YOUR_AWS_SSH_KEY_NAME>
  ```

- Spin up and configure an EC2 instance in the above VPC using Vagrant and
  Salt:
  ```
  AWS_REGION=us-west-2 vagrant up mosql-example
  ```

- SSH into the EC2 instance:
  ```
  AWS_REGION=us-west-2 vagrant ssh mosql-example
  ```

- Use a terminal multiplexer such as `tmux` to start 3 sessions or SSH into the
instance 2 more times.

- Start `mosql` in one session:
  ```
  mosql
  ```

- Start the `mongo` shell in a second session and view the documents in
  collection 1:
  ```
  mongo demo
  db.collection1.find()
  ```

- Start the `psql` shell in a third session and check that the data has been
  replicated:
  ```
  psql
  \x auto
  select * from collection1;
  ```

- Modify a specific document in the `mongo` shell:
  ```
  db.collection1.find({"_id":ObjectId("<INSERT_DOCUMENT_ID>")})
  db.collection1.update({"_id":ObjectId("<INSERT_DOCUMENT_ID>")},{$set:{"productID":"foo"}})
  ```

- Check that the modification has been replicated in the `psql` shell:
  ```
  select * from collection1 where id = '<INSERT_DOCUMENT_ID>';
  ```
