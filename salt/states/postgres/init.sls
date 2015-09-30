include:
  - build-essential

postgresql:
  pkg:
    - installed
    - name: postgresql-9.3
  # This doesn't seem to work. See postgresql_restart below.
  service:
    - running
    - enable: true
    - reload: true
    - watch:
      - file: /etc/postgresql/9.3/main/postgresql.conf
      - file: /etc/postgresql/9.3/main/pg_hba.conf
    - require:
      - pkg: postgresql

postgresql-server-dev:
  pkg:
    - installed
    - name: postgresql-server-dev-9.3

postgresql_conf:
  file:
    - managed
    - name: /etc/postgresql/9.3/main/postgresql.conf
    - source: salt://postgres/postgresql.conf
    - template: jinja
    - user: postgres
    - group: postgres
    - require:
      - pkg: postgresql

postgresql_hba:
  file:
    - managed
    - name: /etc/postgresql/9.3/main/pg_hba.conf
    - source: salt://postgres/pg_hba.conf
    - user: postgres
    - group: postgres
    - template: jinja
    - require:
      - pkg: postgresql

# Hack to get around: https://github.com/saltstack/salt/issues/14183
postgresql_restart:
  cmd:
    - run
    - name: service postgresql restart
    - require:
      - file: postgresql_conf
      - file: postgresql_hba

os_role:
  postgres_user:
    - present
    - name: ubuntu
    - password: ubuntu
    - encrypted: true
    - superuser: true
    - createdb: true
    - createroles: true
    - user: postgres
    - require:
      - cmd: postgresql_restart

chartio_role:
  postgres_user:
    - present
    - name: chartio
    - password: chartio
    - encrypted: true
    - user: postgres
    - require:
      - cmd: postgresql_restart

os_database:
  postgres_database:
    - present
    - name: ubuntu
    - owner: ubuntu
    - user: ubuntu
    - require:
      - cmd: postgresql_restart
      - postgres_user: os_role
      - postgres_user: chartio_role
