use hivedb;

-- 1. create external table
drop table if exists olympics;

create external table if not exists olympics(
athlete varchar(50), age int, country varchar(50), year int, date_of_event string, sport varchar(50), gold int, silver int, bronze int, total int)
row format delimited
fields terminated by "\t"
lines terminated by "\n"
stored as textfile
location '/hive_olympics';

-- show first 5 rows
select * from olympics limit 5;

-- 2. create Avro table

drop table if exists olympics_avro;
create external table if not exists olympics_avro
row format SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
tblproperties('avro.schema.literal'='{
	"name":"olympics_schema",
	"type":"record",
	"fields":[
		{"name":"athlete", "type":"string"},
		{"name":"age", "type":"int"},
                {"name":"country", "type":"string"},
                {"name":"year", "type":"int"},
                {"name":"dateofevent", "type":"string"},
                {"name":"sport", "type":"string"},
                {"name":"gold", "type":"int"},
                {"name":"silver", "type":"int"},
                {"name":"bronze", "type":"int"},
                {"name":"total", "type":"int"}
	]
}');

describe formatted olympics_avro;

-- 3. Insert data from External Table to Avro Table
insert overwrite table olympics_avro select * from olympics limit 100;









