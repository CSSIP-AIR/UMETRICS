-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: localhost    Database: UMETRICSSupport
-- ------------------------------------------------------
-- Server version	5.6.15

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `UMETRICSSupport`
--

USE `UMETRICSSupport`;

--
-- Dumping routines for database 'UMETRICSSupport'
--
/*!50003 DROP PROCEDURE IF EXISTS `CalculatePersonAttributeStatistics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `CalculatePersonAttributeStatistics`()
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Stored procedure to calculate statistics for the PersonAttribute table.  These statistics are used for disambiguation.'
begin


	################################################################################
	# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
	# All rights reserved.
	# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
	# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	################################################################################


	declare _overall_person_count int unsigned;
	declare _overall_person_attribute_count int unsigned;


	select count(*) into _overall_person_count from UMETRICS.Person;
	select count(*) into _overall_person_attribute_count from UMETRICS.PersonAttribute;


	drop table if exists PersonAttributeStatistics;


	create table PersonAttributeStatistics
	(
		OverallPersonCount int unsigned not null,
		OverallPersonAttributeCount int unsigned not null,
		PersonCountPerRelationshipCode int unsigned not null,
		AttributeCountPerRelationshipCode int unsigned not null,
		PersonAttributeCountPerRelationshipCode int unsigned not null,
		RelationshipCodeWeight float unsigned not null comment 'Currently calculated as (PersonCountPerRelationshipCode / PersonAttributeCountPerRelationshipCode) * (AttributeCountPerRelationshipCode / PersonAttributeCountPerRelationshipCode).  See CalculatePersonAttributeStatistics stored procedure for more details.',
		primary key (RelationshipCode)
	)

	select distinct
		RelationshipCode,
		_overall_person_count OverallPersonCount,
		_overall_person_attribute_count OverallPersonAttributeCount,
		(select count(distinct PersonId) from UMETRICS.PersonAttribute where RelationshipCode = t.RelationshipCode) PersonCountPerRelationshipCode,
		(select count(distinct AttributeId) from UMETRICS.PersonAttribute where RelationshipCode = t.RelationshipCode) AttributeCountPerRelationshipCode,
		(select count(*) from UMETRICS.PersonAttribute where RelationshipCode = t.RelationshipCode) PersonAttributeCountPerRelationshipCode,
		0.0 RelationshipCodeWeight

	from
		(
			select distinct
				RelationshipCode

			from
				UMETRICS.PersonAttribute

		) t;


	update
		PersonAttributeStatistics

	set
		RelationshipCodeWeight = (PersonCountPerRelationshipCode / PersonAttributeCountPerRelationshipCode) * (AttributeCountPerRelationshipCode / PersonAttributeCountPerRelationshipCode);


end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CollapsePersons` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `CollapsePersons`(IN `person_a_id` int unsigned, IN `person_b_id` int unsigned, notes varchar(500))
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Collapses two People records and all of their supporting baggage.'
begin


	################################################################################
	# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
	# All rights reserved.
	# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
	# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	################################################################################


	declare _older_person_id int unsigned;
	declare _newer_person_id int unsigned;
	declare _person_collapse_log_id int unsigned;


	# Perform some sanity checking.
	if person_a_id is null then
		signal sqlstate '45000' set message_text = 'person_a_id is required';
	elseif not exists (select PersonId from UMETRICS.Person where PersonId = person_a_id) then
		signal sqlstate '45000' set message_text = 'person_a_id does not exist in the Person table';
	elseif person_b_id is null then
		signal sqlstate '45000' set message_text = 'person_b_id is required';
	elseif not exists (select PersonId from UMETRICS.Person where PersonId = person_b_id) then
		signal sqlstate '45000' set message_text = 'person_b_id does not exist in the Person table';
	elseif person_a_id = person_b_id then
		signal sqlstate '45000' set message_text = 'person_a_id may not equal person_b_id';
	end if;


	# The assumption here is that, since PersonIds are assigned serially, the lower the
	# PersonId, the longer the Person has been in the database.  For consistency and to
	# cause PersonIds to be a bit more static, we will always collapse down into an older
	# Persons.
	if person_a_id < person_b_id then
		set _older_person_id = person_a_id;
		set _newer_person_id = person_b_id;
	else
		set _older_person_id = person_b_id;
		set _newer_person_id = person_a_id;
	end if;


	# The following tables will be affected for collapses:
	#
	#    Person
	#    PersonAddress
	#    PersonAttribute
	#    PersonGrantAward
	#    PersonName
	#    PersonPublication
	#    PersonTerm
	#
	# For every table above except Person, we are going to renumber the new PersonId to the
	# older PersonId.  We will have to check ahead of time to ensure that certain records
	# don't already exist.  Duplicates will be deleted.  Once everything is collapsed, we
	# will remove the newer person.
	#
	# We will also log everything that was collapsed, for posterity.


	# Create an anchor point for our collapse.
	insert into UMETRICSSupport.CollapsePersonsLog
	(
		CollapsedPersonId,
		TargetPersonId,
		CollapseDateTime,
		Notes
	)
	values
	(
		_newer_person_id,
		_older_person_id,
		now(),
		notes
	);

	set _person_collapse_log_id = last_insert_id();


	# Each of these sections is going to work pretty much the same way:
	#
	#   1 - log upcoming deletes
	#   2 - perform deletes
	#   3 - log upcoming reassignments
	#   4 - perform reassignment


	set @counter = 0;


	###### PersonAddress


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonAddress',
		a.PersonAddressId,
		'DELETED',
		concat_ws('', '<PersonAddress><PersonAddressId>', a.PersonAddressId, '</PersonAddressId><PersonId>', a.PersonId, '</PersonId><AddressId>', a.AddressId, '</AddressId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonAddress>')

	from
		UMETRICS.PersonAddress a

		inner join UMETRICS.PersonAddress b on
		b.PersonId = _older_person_id and
		b.AddressId = a.AddressId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	delete
		a

	from
		UMETRICS.PersonAddress a

		inner join UMETRICS.PersonAddress b on
		b.PersonId = _older_person_id and
		b.AddressId = a.AddressId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonAddress',
		a.PersonAddressId,
		'REASSIGNED',
		concat_ws('', '<PersonAddress><PersonAddressId>', a.PersonAddressId, '</PersonAddressId><PersonId>', a.PersonId, '</PersonId><AddressId>', a.AddressId, '</AddressId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonAddress>')

	from
		UMETRICS.PersonAddress a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonAddress

	set
		PersonId = _older_person_id,
		RelationshipCode = if(RelationshipCode = 'PRIMARY', 'ALTERNATE', RelationshipCode) # Multiple PRIMARY addresses can be problematic.

	where
		PersonId = _newer_person_id;


	###### PersonAttribute


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonAttribute',
		a.PersonAttributeId,
		'DELETED',
		concat_ws('', '<PersonAttribute><PersonAttributeId>', a.PersonAttributeId, '</PersonAttributeId><PersonId>', a.PersonId, '</PersonId><AttributeId>', a.AttributeId, '</AttributeId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonAttribute>')

	from
		UMETRICS.PersonAttribute a

		inner join UMETRICS.PersonAttribute b on
		b.PersonId = _older_person_id and
		b.AttributeId = a.AttributeId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	delete
		a

	from
		UMETRICS.PersonAttribute a

		inner join UMETRICS.PersonAttribute b on
		b.PersonId = _older_person_id and
		b.AttributeId = a.AttributeId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonAttribute',
		a.PersonAttributeId,
		'REASSIGNED',
		concat_ws('', '<PersonAttribute><PersonAttributeId>', a.PersonAttributeId, '</PersonAttributeId><PersonId>', a.PersonId, '</PersonId><AttributeId>', a.AttributeId, '</AttributeId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonAttribute>')

	from
		UMETRICS.PersonAttribute a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonAttribute

	set
		PersonId = _older_person_id

	where
		PersonId = _newer_person_id;


	###### PersonGrantAward


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonGrantAward',
		a.PersonGrantAwardId,
		'DELETED',
		concat_ws('', '<PersonGrantAward><PersonGrantAwardId>', a.PersonGrantAwardId, '</PersonGrantAwardId><PersonId>', a.PersonId, '</PersonId><GrantAwardId>', a.GrantAwardId, '</GrantAwardId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonGrantAward>')

	from
		UMETRICS.PersonGrantAward a

		inner join UMETRICS.PersonGrantAward b on
		b.PersonId = _older_person_id and
		b.GrantAwardId = a.GrantAwardId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	delete
		a

	from
		UMETRICS.PersonGrantAward a

		inner join UMETRICS.PersonGrantAward b on
		b.PersonId = _older_person_id and
		b.GrantAwardId = a.GrantAwardId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonGrantAward',
		a.PersonGrantAwardId,
		'REASSIGNED',
		concat_ws('', '<PersonGrantAward><PersonGrantAwardId>', a.PersonGrantAwardId, '</PersonGrantAwardId><PersonId>', a.PersonId, '</PersonId><GrantAwardId>', a.GrantAwardId, '</GrantAwardId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonGrantAward>')

	from
		UMETRICS.PersonGrantAward a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonGrantAward

	set
		PersonId = _older_person_id

	where
		PersonId = _newer_person_id;


	###### PersonName - PersonNames are never deleted, only reassigned as they enjoy a
	#                   special kind of relationship with a Person.


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	# To save on space, we are not going to record the entire name, just the bits that help
	# us trace collapses.  The actual name information is never really lost due to
	# collapsing, so the risk is much lower.
	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonName',
		a.PersonNameId,
		'REASSIGNED',
		concat_ws('', '<PersonName><PersonNameId>', a.PersonNameId, '</PersonNameId><PersonId>', a.PersonId, '</PersonId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonName>')

	from
		UMETRICS.PersonName a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonName

	set
		PersonId = _older_person_id,
		RelationshipCode = if(RelationshipCode = 'PRIMARY', 'ALIAS', RelationshipCode) # Multiple PRIMARY names can be problematic

	where
		PersonId = _newer_person_id;


	###### PersonPublication


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonPublication',
		a.PersonPublicationId,
		'DELETED',
		concat_ws('', '<PersonPublication><PersonPublicationId>', a.PersonPublicationId, '</PersonPublicationId><PersonId>', a.PersonId, '</PersonId><PublicationId>', a.PublicationId, '</PublicationId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonPublication>')

	from
		UMETRICS.PersonPublication a

		inner join UMETRICS.PersonPublication b on
		b.PersonId = _older_person_id and
		b.PublicationId = a.PublicationId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	delete
		a

	from
		UMETRICS.PersonPublication a

		inner join UMETRICS.PersonPublication b on
		b.PersonId = _older_person_id and
		b.PublicationId = a.PublicationId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonPublication',
		a.PersonPublicationId,
		'REASSIGNED',
		concat_ws('', '<PersonPublication><PersonPublicationId>', a.PersonPublicationId, '</PersonPublicationId><PersonId>', a.PersonId, '</PersonId><PublicationId>', a.PublicationId, '</PublicationId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonPublication>')

	from
		UMETRICS.PersonPublication a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonPublication

	set
		PersonId = _older_person_id

	where
		PersonId = _newer_person_id;


	###### PersonTerm


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonTerm',
		a.PersonTermId,
		'DELETED',
		concat_ws('', '<PersonTerm><PersonTermId>', a.PersonTermId, '</PersonTermId><PersonId>', a.PersonId, '</PersonId><TermId>', a.TermId, '</TermId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode><Weight>', a.Weight, '</Weight></PersonTerm>')

	from
		UMETRICS.PersonTerm a

		inner join UMETRICS.PersonTerm b on
		b.PersonId = _older_person_id and
		b.TermId = a.TermId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	delete
		a

	from
		UMETRICS.PersonTerm a

		inner join UMETRICS.PersonTerm b on
		b.PersonId = _older_person_id and
		b.TermId = a.TermId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonTerm',
		a.PersonTermId,
		'REASSIGNED',
		concat_ws('', '<PersonTerm><PersonTermId>', a.PersonTermId, '</PersonTermId><PersonId>', a.PersonId, '</PersonId><TermId>', a.TermId, '</TermId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode><Weight>', a.Weight, '</Weight></PersonTerm>')

	from
		UMETRICS.PersonTerm a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonTerm

	set
		PersonId = _older_person_id

	where
		PersonId = _newer_person_id;


	### Finally, blow away the newer person.


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'Person',
		_newer_person_id,
		'DELETED',
		concat_ws('', '<Person><PersonId>', _newer_person_id, '</PersonId></Person>');


	delete from UMETRICS.Person where PersonId = _newer_person_id;


end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
