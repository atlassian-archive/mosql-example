mongodb:
  file:
    - managed
    - name: /etc/mongodb.conf
    - source: salt://mongo/mongodb.conf
  pkg:
    - installed


# Installing mongo above auto starts the service.
# This is a hack to restart the service and trigger init_delay.
mongo_dead:
  service:
    - dead
    - name: mongodb
    - require:
      - file: mongodb
      - pkg: mongodb

mongo_running:
  service:
    - running
    - name: mongodb
    - enable: true
    - init_delay: 180
    - require:
      - service: mongo_dead


mongo_repl:
  cmd:
    - run
    - name: |
        mongo --eval 'rs.initiate({"_id" : "rs0", "version" : 1, "members" : [{"_id" : 0, "host" : "127.0.0.0:27017"}]});' && sleep 10
    - user: ubuntu
    - group: ubuntu
    - require:
      - service: mongo_running

copy_mongo_data:
  file:
    - recurse
    - name: /tmp/mongo_data
    - source: salt://mongo/data
    - user: ubuntu
    - group: ubuntu

load_mongo_data:
  cmd:
    - run
    - name: |
        mongoimport --db demo --collection collection1 --type json --file collection1.json
    - user: ubuntu
    - group: ubuntu
    - cwd: /tmp/mongo_data
    - require:
      - file: copy_mongo_data
      - cmd: mongo_repl
