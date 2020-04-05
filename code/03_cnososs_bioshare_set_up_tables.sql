-- CHRISTY'S MODIFICATIONS TO MORELY'S CODE
-- THIS FILE SETS UP ALL THE TABLES IN SQL
--################################################################################
--## Copyright 2014-15 David Morley
--## 
--## Licensed under the Apache License, Version 2.0 (the "License");
--## you may not use this file except in compliance with the License.
--## You may obtain a copy of the License at
--## 
--##     http://www.apache.org/licenses/LICENSE-2.0
--## 
--## Unless required by applicable law or agreed to in writing, software
--## distributed under the License is distributed on an "AS IS" BASIS,
--## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--## See the License for the specific language governing permissions and
--## limitations under the License.
--################################################################################

--#################################################
--##						 ##
--##	CNOSSOS-EU ROAD TRAFFIC NOISE MODEL	 ##
--##	ADAPTED FOR BIOSHARE PROJECT		 ##
--##	[2012 report eur 25379 en] 		 ##
--##	24hr Version				 ##
--##						 ##
--##	David Morley: d.morley@imperial.ac.uk	 ##
--##	Version 1.3, 4th August 2015		 ##
--##						 ##
--#################################################

--## For full details please see Environmental Pollution  (2015), pp. 332-341 DOI information: 10.1016/j.envpol.2015.07.031

--################################################################################################

-- FILENAMES	: DEFINITION [HEADERS]
-- recpt	: Receptors [gid, geom(point)]	
-- roads	: Road network, light, heavy hourly flow and speed [gid, geom(line), qh_0, ql_0 ... qh_23, ql_23, speed1, speed3]
-- landcover	: Land classes, 3 character Corine code [gid, geom(polygon), code_06]
-- buildings	: Building heights [gid, geom(polygon), height]
-- mettemp	: Temperature at met station [gid, geom(point), air_temp], or a constant temperature
-- metwind	: Wind direction proportion [gid, geom(point), ne, se, sw, nw], or a constant proportion

--################################################################################################



--Receptors

--Field	Type	Definition
--Geom	Geometry (Point)	Location of receptor
--GID	Integer	Unique ID of receptor
--…	…	Descriptor columns (optional)

drop table if exists recpt;
create table recpt (
		gid serial primary key,
		geom geometry,
		description text
);
create index recpt_geom_idx ON recpt using gist (geom);


--Land cover

--Field	Type	Definition
--Geom	Geometry (Polygon)	CORINE Land cover polygon
--Code_06	Text	CORINE Land cover code. 3 characters, e.g. 111 is --continuous urban fabric


drop table if exists landcover;
create table landcover (
		id serial primary key,
		geom geometry,
		code_06 text
);
create index landcover_geom_idx ON landcover using gist (geom);


--Building heights

--Field	Type	Definition
--Geom	Geometry (Polygon)	Building or urban area polygon
--Height	numeric	Building height in metres

drop table if exists buildings;
create table buildings (
		id serial PRIMARY key,
		geom geometry,
		height double PRECISION
);
create index buildings_geom_idx ON buildings using gist (geom);

--Temperature

--Field	Type	Definition
--Geom	Geometry (Point)	Location of met station
--Air_temp	numeric	Annual average temperature in degrees Celsius
--src_id	numeric	Unique ID of met station

drop table if exists mettemp;
create table mettemp (
		src_id int primary key,
		geom geometry,
		air_temp numeric
);

create index mettemp_geom_idx ON mettemp using gist (geom);


--Wind direction

--Field	Type	Definition
--Geom	Geometry (Point)	Location of met station
--NE	numeric	Proportion of time annually wind is from NE
--SE	numeric	Proportion of time annually wind is from SE
--SW	numeric	Proportion of time annually wind is from SW
--NW	numeric	Proportion of time annually wind is from NW
--src_id	numeric	Unique ID of met station

drop table if exists metwind;
create table metwind (
		src_id int primary key,
		geom geometry,
		ne numeric,
		se numeric,
		sw numeric,
		nw numeric
);
create index metwind_geom_idx ON metwind using gist (geom);



--Road network and Traffic Flow 
--Field	Type	Definition
--Geom	Geometry (Line)	Road segment
--qh_0	numeric	Heavy vehicles per hour at 0.00 (midnight) – 1.00 
--ql_0	numeric	Light vehicles per hour at 0.00 (midnight) – 1.00
--qh_1	numeric	Heavy vehicles per hour at 1.00 – 2.00
--ql_1	numeric	Light vehicles per hour at 1.00 – 2.00
--qh_2	numeric	Heavy vehicles per hour at 2.00 – 3.00
--ql_2	numeric	Light vehicles per hour at 2.00 – 3.00
--...
--qh_22	numeric	Heavy vehicles per hour at 22.00 – 23.00
--ql_22	numeric	Light vehicles per hour at 22.00 – 23.00
--qh_23	numeric	Heavy vehicles per hour at 23.00 – 0.00 (midnight)
--ql_23	numeric	Light vehicles per hour at 23.00 – 0.00 (midnight)
--speed1	numeric	Maximum legal speed of light vehicles on segment
--speed3	numeric	Maximum legal speed of heavy vehicles on segment

drop table if exists roads;
create table roads (
		gid serial primary key,
		geom geometry,
		qh_0 numeric,
		ql_0 numeric,
		qh_1 numeric,
		ql_1 numeric,
		qh_2 numeric,
		ql_2 numeric,
		qh_3 numeric,
		ql_3 numeric,
		qh_4 numeric,
		ql_4 numeric,
		qh_5 numeric,
		ql_5 numeric,
		qh_6 numeric,
		ql_6 numeric,
		qh_7 numeric,
		ql_7 numeric,
		qh_8 numeric,
		ql_8 numeric,
		qh_9 numeric,
		ql_9 numeric,
		qh_10 numeric,
		ql_10 numeric,
		qh_11 numeric,
		ql_11 numeric,
		qh_12 numeric,
		ql_12 numeric,
		qh_13 numeric,
		ql_13 numeric,
		qh_14 numeric,
		ql_14 numeric,
		qh_15 numeric,
		ql_15 numeric,
		qh_16 numeric,
		ql_16 numeric,
		qh_17 numeric,
		ql_17 numeric,
		qh_18 numeric,
		ql_18 numeric,
		qh_19 numeric,
		ql_19 numeric,
		qh_20 numeric,
		ql_20 numeric,
		qh_21 numeric,
		ql_21 numeric,
		qh_22 numeric,
		ql_22 numeric,
		qh_23 numeric,
		ql_23 numeric,
		speed1 numeric,
		speed3 numeric

);
create index roads_geom_idx ON roads using gist (geom);
