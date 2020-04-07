## This sets up the master user for the CNOSSOS database

## It is assumed that all types, functions and tables with be created in the public schema with an owner
## of cnossos_superuser

## It is also assumed that there is a role of dev_group who has access to all the tables where the data
## inputs are stored


CREATE USER cnossos_superuser;
ALTER USER cnossos_superuser WITH PASSWORD '45_sea_dragons';
GRANT ALL ON SCHEMA public TO cnossos_superuser;
GRANT dev_group TO cnossos_superuser;

