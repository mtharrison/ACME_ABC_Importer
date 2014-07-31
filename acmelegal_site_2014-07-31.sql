# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.5.38-0ubuntu0.12.04.1)
# Database: acmelegal_site
# Generation Time: 2014-07-31 22:01:38 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table abc_file_hashes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `abc_file_hashes`;

CREATE TABLE `abc_file_hashes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(225) DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table abc_geo_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `abc_geo_mapping`;

CREATE TABLE `abc_geo_mapping` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `acme_id` int(11) DEFAULT NULL,
  `abc_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `abc_geo_mapping` WRITE;
/*!40000 ALTER TABLE `abc_geo_mapping` DISABLE KEYS */;

INSERT INTO `abc_geo_mapping` (`id`, `acme_id`, `abc_code`)
VALUES
	(1,104,'AUS%'),
	(2,71,'UTA'),
	(3,71,'UTL'),
	(4,69,'UHX'),
	(5,69,'UHD'),
	(6,37,'UPA'),
	(7,52,'USWS'),
	(8,72,'UTW'),
	(9,72,'UTB'),
	(10,48,'UAB'),
	(11,59,'UGC'),
	(12,27,'UWC%'),
	(13,57,'USWC'),
	(14,21,'UEC'),
	(15,26,'UWU%'),
	(16,40,'UNC'),
	(17,56,'USWX'),
	(18,54,'USWD'),
	(19,47,'UA%'),
	(20,90,'UN%'),
	(21,111,'UDA'),
	(22,111,'UDH'),
	(23,66,'UTE'),
	(24,66,'UTY'),
	(25,53,'USWB'),
	(26,64,'UDW'),
	(27,64,'UDW'),
	(28,89,'UPG'),
	(29,73,'UTS'),
	(30,73,'UTC'),
	(31,70,'UT%'),
	(32,65,'UH%'),
	(33,35,'UYE'),
	(34,81,'UISL'),
	(35,67,'UHK'),
	(36,67,'UHB'),
	(37,28,'UWL%'),
	(38,32,'UYW'),
	(39,42,'UNB'),
	(40,41,'UND'),
	(41,29,'UWR%'),
	(42,75,'UL%'),
	(43,76,'ULL'),
	(44,77,'ULM'),
	(45,80,'ULP'),
	(46,78,'ULN'),
	(47,79,'ULO'),
	(48,30,'UWM%'),
	(49,88,'UHE'),
	(50,23,'UED'),
	(51,49,'UAD'),
	(52,24,'UE%'),
	(53,25,'UWN%'),
	(54,2,'UW%'),
	(55,43,'UNE'),
	(56,22,'UEN'),
	(57,44,'UNA'),
	(58,103,'%'),
	(59,103,'EU%'),
	(60,103,'UX%'),
	(61,103,'UCI%'),
	(62,103,'U%'),
	(63,103,'UXA'),
	(64,103,'UXD'),
	(65,74,'UTV'),
	(66,74,'UTD'),
	(67,105,'SAU%'),
	(68,82,'US%'),
	(69,82,'UIS'),
	(70,82,'USE'),
	(71,82,'USG'),
	(72,82,'USA'),
	(73,33,'UYL'),
	(74,45,'UPE'),
	(75,62,'UD%'),
	(76,58,'UG%'),
	(77,51,'USW%'),
	(78,46,'UPF'),
	(79,50,'UAE'),
	(80,68,'UHC'),
	(81,63,'UH%'),
	(82,60,'UGD'),
	(83,20,'UEY'),
	(84,38,'UPD'),
	(85,36,'UP%'),
	(86,107,'UDC'),
	(87,107,'UDP'),
	(88,55,'USWW'),
	(89,39,'UPB'),
	(90,34,'UYB'),
	(91,31,'UY%');

/*!40000 ALTER TABLE `abc_geo_mapping` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table abc_practice_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `abc_practice_mapping`;

CREATE TABLE `abc_practice_mapping` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `acme_id` int(11) DEFAULT NULL,
  `abc_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `abc_practice_mapping` WRITE;
/*!40000 ALTER TABLE `abc_practice_mapping` DISABLE KEYS */;

INSERT INTO `abc_practice_mapping` (`id`, `acme_id`, `abc_code`)
VALUES
	(1,103,'WELF'),
	(2,107,'ULR'),
	(3,168,'TRAN'),
	(4,102,'TRAN'),
	(5,101,'TAC'),
	(6,139,'STRU'),
	(7,167,'SPOR'),
	(8,100,'SPOR'),
	(9,99,'SHIP'),
	(10,98,'SFO'),
	(11,138,'STS'),
	(12,97,'SEC'),
	(13,126,'FA3'),
	(14,126,'AD2'),
	(15,126,'AD3'),
	(16,126,'F17'),
	(17,126,'AD4'),
	(18,166,'RESO'),
	(19,96,'RES'),
	(20,95,'REMO'),
	(21,137,'REIN'),
	(22,94,'SHE'),
	(23,117,'HR5'),
	(24,117,'HR6'),
	(25,105,'PUBP'),
	(26,165,'PUBP'),
	(27,118,'PSL'),
	(28,93,'PROL'),
	(29,92,'PROF'),
	(30,91,'PROC'),
	(31,164,'PRIV'),
	(32,90,'PRIV'),
	(33,116,'PRA1'),
	(34,116,'PRA%'),
	(35,89,'PLAN'),
	(36,87,'PFI'),
	(37,88,'PI'),
	(38,86,'PENS'),
	(39,85,'MOTO'),
	(40,163,'MENT'),
	(41,84,'MENT'),
	(42,83,'MED'),
	(43,162,'MED'),
	(44,119,'MA1'),
	(45,119,'MA%'),
	(46,169,'NOTA'),
	(47,82,'LICE'),
	(48,161,'LIB'),
	(49,108,'HR5'),
	(50,120,'IT5'),
	(51,160,'ITE'),
	(52,81,'ITE'),
	(53,127,'IT5'),
	(54,127,'IT%'),
	(55,127,'IT6'),
	(56,127,'IT2'),
	(57,127,'IT1'),
	(58,127,'IT4'),
	(59,159,'IP'),
	(60,80,'IP'),
	(61,78,'FR'),
	(62,77,'INSC'),
	(63,79,'INSU'),
	(64,76,'INSO'),
	(65,75,'IND'),
	(66,74,'IMMI'),
	(67,125,'HR2'),
	(68,125,'HR%'),
	(69,125,'HR4'),
	(70,125,'HR3'),
	(71,125,'HR1'),
	(72,73,'HOUS'),
	(73,140,'COUN'),
	(74,149,'COUN'),
	(75,136,'FINA'),
	(76,158,'FINA'),
	(77,158,'FI19'),
	(78,124,'FI2'),
	(79,124,'FI3'),
	(80,124,'FI1'),
	(81,124,'FI6'),
	(82,124,'FI9'),
	(83,72,'FAM'),
	(84,121,'FA1'),
	(85,121,'FA%'),
	(86,67,'EC'),
	(87,155,'EC'),
	(88,71,'ENVI'),
	(89,70,'EMP'),
	(90,157,'EMP'),
	(91,69,'EE'),
	(92,156,'EE'),
	(93,68,'EDUC'),
	(94,134,'DOCU'),
	(95,142,'DERI'),
	(96,66,'DATA'),
	(97,154,'CRIM'),
	(98,65,'CRIM'),
	(99,141,'COP'),
	(100,153,'COP'),
	(101,104,'COS'),
	(102,133,'COGO'),
	(103,64,'CORP'),
	(104,152,'CORP'),
	(105,63,'CONS'),
	(106,151,'CONC'),
	(107,113,'CONC'),
	(108,113,'FI5'),
	(109,62,'CON'),
	(110,150,'COMP'),
	(111,61,'COMP'),
	(112,61,'PRA2'),
	(113,132,'CPLI'),
	(114,60,'CS'),
	(115,58,'PROP'),
	(116,147,'PROP'),
	(117,147,'FA2'),
	(118,147,'MA2'),
	(119,57,'COML'),
	(120,59,'COM'),
	(121,148,'COM'),
	(122,56,'CLIF'),
	(123,55,'CLID'),
	(124,54,'CIV'),
	(125,146,'CIV'),
	(126,53,'CHIL'),
	(127,52,'CHAR'),
	(128,131,'CAP'),
	(129,106,'BUSD'),
	(130,106,'MA3'),
	(131,51,'BANL'),
	(132,145,'BANK'),
	(133,50,'BANK'),
	(134,144,'ASS'),
	(135,49,'ASS'),
	(136,130,'ARB'),
	(137,48,'AGRI'),
	(138,122,'AD1'),
	(139,122,'AD%'),
	(140,122,'PRA5'),
	(141,122,'PRA7'),
	(142,122,'MA4'),
	(143,123,'FI8'),
	(144,123,'FI%'),
	(145,123,'FI4');

/*!40000 ALTER TABLE `abc_practice_mapping` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table abc_service_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `abc_service_mapping`;

CREATE TABLE `abc_service_mapping` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `acme_id` int(11) DEFAULT NULL,
  `abc_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `abc_service_mapping` WRITE;
/*!40000 ALTER TABLE `abc_service_mapping` DISABLE KEYS */;

INSERT INTO `abc_service_mapping` (`id`, `acme_id`, `abc_code`)
VALUES
	(1,31,'FINA'),
	(2,41,'LES'),
	(3,30,'SOL'),
	(4,28,'H2'),
	(5,14,'COSE'),
	(6,32,'DATA'),
	(7,27,'CONT'),
	(8,13,'COST'),
	(9,33,'FAC'),
	(10,34,'HR'),
	(11,40,'INTE'),
	(12,37,'IT'),
	(13,15,'H1'),
	(14,7,'EXE'),
	(15,9,'EXE'),
	(16,38,'MARK'),
	(17,1,'SOL'),
	(18,8,'EXE'),
	(19,29,'PAT'),
	(20,36,'PRAC'),
	(21,35,'H2'),
	(22,39,'LES'),
	(23,2,'SOL'),
	(24,3,'SOL'),
	(25,4,'SOL'),
	(26,5,'SOL'),
	(27,6,'SOL');

/*!40000 ALTER TABLE `abc_service_mapping` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table acme_streamer
# ------------------------------------------------------------

DROP TABLE IF EXISTS `acme_streamer`;

CREATE TABLE `acme_streamer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `location` mediumtext,
  `area` mediumtext,
  `title` mediumtext,
  `type` mediumtext,
  `sector` mediumtext,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `abc_persid` varchar(255) DEFAULT NULL,
  `abc_lasthash` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
