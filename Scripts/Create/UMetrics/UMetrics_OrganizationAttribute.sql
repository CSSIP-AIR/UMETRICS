CREATE DATABASE  IF NOT EXISTS `UMetrics` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `UMetrics`;
-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com    Database: UMetrics
-- ------------------------------------------------------
-- Server version	5.6.13-log

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
-- Table structure for table `OrganizationAttribute`
--

DROP TABLE IF EXISTS `OrganizationAttribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrganizationAttribute` (
  `OrganizationAttributeId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an OrganizationAttribute.',
  `OrganizationId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the Organization.',
  `AttributeId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the Attribute.',
  `RelationshipCode` enum('DUNS') NOT NULL COMMENT 'Describes the attribute''s relationship to the organization.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
  PRIMARY KEY (`OrganizationAttributeId`),
  UNIQUE KEY `AK_OrganizationAttribute` (`OrganizationId`,`AttributeId`,`RelationshipCode`),
  KEY `FK_OrganizationAttribute_Organization` (`OrganizationId`),
  KEY `FK_OrganizationAttribute_Attribute` (`AttributeId`),
  CONSTRAINT `FK_OrganizationAttribute_Organization` FOREIGN KEY (`OrganizationId`) REFERENCES `Organization` (`OrganizationId`),
  CONSTRAINT `FK_OrganizationAttribute_Attribute` FOREIGN KEY (`AttributeId`) REFERENCES `Attribute` (`AttributeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Attributes for Organizations.';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-06 18:46:10
