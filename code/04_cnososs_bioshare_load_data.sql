-- CHRISTY'S MODIFICATIONS TO MORELY'S CODE
-- THIS FILE LOADS DATA INTO THE TABLES
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

--Building heights needs to be done before recpt

--Field	Type	Definition
--Geom	Geometry (Polygon)	Building or urban area polygon
--Height	numeric	Building height in metres

insert into buildings (geom, height)
select b.geom, b."HEIGHT"
from buildings.buildings_bankstown_ele_hgt as b;


--Receptors

--Field	Type	Definition
--Geom	Geometry (Point)	Location of receptor
--GID	Integer	Unique ID of receptor
--…	…	Descriptor columns (optional)


--create or replace procedure generate_points(lga_2016_code text,  num_points int)
--language 'plpgsql'
--as $$
--	declare 
--		i int = 1;
--		geometry_value geometry = (select geom from abs_lga.lga_2016_nsw where lga_code16=lga_2016_code);
--	begin
--	while (i <= num_points) loop
--		insert into recpt (geom) values (ST_GeneratePoints(geometry_value,1));
--		i = i+1;
--	end loop;
--	commit;
--end $$;
-- populate the table with 10 random points in the lga_2016 region for Cantebury-Bankstown (lga_2016_code = 11570)
--call generate_points('11570',10);
create or replace function generate_points(num_points int)
returns int
as $$
	declare 
		i int = 1;
		n_rows int = (select count(*) from buildings);
		random_int int = 0;
		geometry_value geometry;
	begin
	while (i <= num_points) loop
		random_int = (select floor(random() * n_rows + 1)::int);
		geometry_value = (select geom from public.buildings where id=random_int);
		--insert into recpt (geom) values (ST_GeneratePoints(geometry_value,1));
		insert into recpt (geom) values ((ST_Dump(ST_GeneratePoints(geometry_value,1))).geom);
		--random_int = (select floor(random() * 290452 + 1)::int);	
		--geometry_value = (select geom from buildings where id=253936);
		--insert into recpt (geom) values (ST_GeneratePoints((select geom from buildings where id=253936),1));
		i = i+1;
	end loop;
	return i;
end $$ language 'plpgsql' volatile;
-- populate the table with 10 random points in the lga_2016 region for Cantebury-Bankstown (lga_2016_code = 11570)
delete from recpt;
select generate_points(10);




--Land cover

--Field	Type	Definition
--Geom	Geometry (Polygon)	CORINE Land cover polygon
--Code_06	Text	CORINE Land cover code. 3 characters, e.g. 111 is --continuous urban fabric


insert into landcover
select gid, geom, lay_class
from landuse.lep_landzoning_nsw
where lower(lga_name) like '%bankstown%';

-- map landcover values to corine codes see file lep_landzoning_to_corine_code_mapping.docx
update landcover
set code_06='121'
where code_06 in (
'Business Development',
'Business Park',
'Enterprise Corridor',
'General Industrial',
'Infrastructure',
'Light Industrial',
'Primary Production Small Lots'
);

update landcover
set code_06='133'
where code_06 in (
'Unzoned Land'
);


update landcover
set code_06='111'
where code_06 in (
'High Density Residential',
'Medium Density Residential',
'Local Centre',
'Mixed Use',
'Neighbourhood Centre'
);

update landcover
set code_06='112'
where code_06 in (
'Low Density Residential'
);

				 
update landcover
set code_06='313'
where code_06 in (				 
'National Parks and Nature Reserves'
);


update landcover
set code_06='142'
where code_06 in (
'Private Recreation',
'Public Recreation',				 
'Special Activities'
);

update landcover
set code_06='511'
where code_06 in (
'Natural Waterways'
);




--Temperature

--Field	Type	Definition
--Geom	Geometry (Point)	Location of met station
--Air_temp	numeric	Annual average temperature in degrees Celsius
--src_id	numeric	Unique ID of met station

-- values obtained from BOM weather station (id = 066137) at Bankstown for 2019
-- monthly max averages 					32.3	29.3	27.8	25.7	22.5	18.5	19.2	19.6	23.1	25.8	28.6	30.2	25.2
-- monthly min averages 					21.5	18.0	17.6	13.2	8.7		7.3		5.8		6.0		9.2		11.9	14.6	16.8	12.6
-- monthly averages (max-ave + min-ave)/2 	26.9	23.65	22.7	19.45	15.6	12.9	12.5	12.8	16.15	18.85	21.6	23.5	18.9
-- yearly avereges sum(monthly-ave)/12		18.88461538

INSERT INTO mettemp (Geom, Air_temp,src_id) 
values (ST_SetSRID(ST_MakePoint(150.9864,-33.9181),4283),18.88461538,066137);


--Wind direction

--Field	Type	Definition
--Geom	Geometry (Point)	Location of met station
--NE	numeric	Proportion of time annually wind is from NE
--SE	numeric	Proportion of time annually wind is from SE
--SW	numeric	Proportion of time annually wind is from SW
--NW	numeric	Proportion of time annually wind is from NW
--src_id	numeric	Unique ID of met station

-- use BOM weather station id (94765) and locality (-33.92 S 151.03 E) for Bankstown
-- use random wind values 

INSERT INTO metwind (Geom, NE, SE, SW, NW, src_id) 
values (ST_SetSRID(ST_MakePoint(150.9864,-33.9181),4283),.25,.30,.15,.40,066137);



--Road network and Traffic Flow 
--Field	Type	Definition
--Geom	Geometry (Line)	Road segment
--qh_0	numeric	Heavy vehicles per hour at 0.00 (midnight) – 1.00 
--ql_0	numeric	Light vehicles per hour at 0.00 (midnight) – 1.00
--qh_1	numeric	Heavy vehicles per hour at 1.00 – 2.00
--ql_1	numeric	Light vehicles per hour at 1.00 – 2.00
--...
--qh_23	numeric	Heavy vehicles per hour at 23.00 – 0.00 (midnight)
--ql_23	numeric	Light vehicles per hour at 23.00 – 0.00 (midnight)
--speed1	numeric	Maximum legal speed of light vehicles on segment
--speed3	numeric	Maximum legal speed of heavy vehicles on segment

INSERT INTO roads ( gid, geom, ql_0, ql_1, ql_2, ql_3, ql_4, ql_5, ql_6, ql_7, ql_8, ql_9, ql_10, ql_11, 
ql_12, ql_13, ql_14, ql_15, ql_16, ql_17, ql_18, ql_19, ql_20, ql_21, ql_22, ql_23,
qh_0, qh_1, qh_2, qh_3, qh_4, qh_5, qh_6, qh_7, qh_8, qh_9, qh_10, qh_11, 
qh_12, qh_13, qh_14, qh_15, qh_16, qh_17, qh_18, qh_19, qh_20, qh_21, qh_22, qh_23,
speed1, speed3 )
SELECT gid, geom,
4.445172045, 3.020002381, 2.443147994, 2.578878438, 3.834385046, 8.177759257, 18.93439695, 33.76294797, 37.25800691, 33.45755447, 34.4755328, 36.37575902, 37.05441124, 37.39373735, 38.14025479, 40.27800928, 44.31599, 44.45172045, 35.52744374, 25.34766044, 18.08608167, 13.50517919, 10.21371591, 6.922252649,
0.233956423, 0.158947494, 0.128586737, 0.135730444, 0.201809739, 0.430408382, 0.996547208, 1.776997262, 1.960947732, 1.76092392, 1.814501727, 1.914513633, 1.950232171, 1.96809144, 2.007381831, 2.119895226, 2.332420527, 2.339564234, 1.86986546, 1.334087392, 0.951899036, 0.710798905, 0.537563996, 0.364329087,
50, 50
FROM    streetpro_2012_nsw.nsw_st_bankstown
WHERE   road_class not in ('A','B','C','D','G','H');