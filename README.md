# Overview

mongo demo
db.collection1.find({"_id":ObjectId("5602de10f0dd8b3d8814324c")})
db.collection1.update({"_id":ObjectId("5602de10f0dd8b3d8814324c")},{$set:{"productID":"foo"}})

psql
select * from collection1 where id = '5602de10f0dd8b3d8814324c';
