include:
  - ruby
  - mongo
  - postgres

mosql:
  gem.installed

collections.yml:
  file:
    - managed
    - name: /home/ubuntu/collections.yml
    - source: salt://mosql/collections.yml
    - user: ubuntu
    - group: ubuntu
