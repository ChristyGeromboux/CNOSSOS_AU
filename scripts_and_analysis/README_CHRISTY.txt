## The sql files here are designed to replicate the work done by Morley et al. 2015 
## The code is Morley's, modified only slightly in order to run on the environment we have set up, 
## with data for Bankstown, NSW

## This project uses David Morleys code to estimate traffic noise using data for the Bankstown, NSW region

To get this to run in PostGIS you will need:
PostGres
PostGIS
PGAdmin4 

Once set up, open PGAdmin4 and create a database for this project, and a schema for all the tables. The SQL in the following scripts assume the schema is called cnossos, but this can be changed by altering the line at the top of each script (change cnossos to be the name of the schema you create):


From within PGAdmin open and run each of the following sql scripts in order. They all use the public schema and create the users, types, funcions and tables. They then load data into the tables from pre-populated source tables, and finally run the noise model on the data.

00_cnossos_create_users.sql
01_cnossos_bioshare_set_up_types.sql
02_cnossos_bioshare_set_up_functions.sql
03_cnossos_bioshare_set_up_tables.sql
04_cnossos_bioshare_load_data.sql
05_cnossos_bioshare_run_analysis.sql

Note that the 04 script will only work to poplate data if the relevant tables exist. In this case we have created data tables which sit in their relative schemas, and are accessed to populate the data in the cnossos model table.