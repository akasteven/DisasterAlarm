delimiter $$

CREATE DATABASE `disaster_info` /*!40100 DEFAULT CHARACTER SET utf8 */$$

delimiter $$

CREATE TABLE `earthquake` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `magnitude` float(3,1) NOT NULL,
  `datetime` datetime NOT NULL,
  `latitude` float(3,1) NOT NULL,
  `longitude` float(4,1) NOT NULL,
  `depth` tinyint(4) NOT NULL,
  `location` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8$$

