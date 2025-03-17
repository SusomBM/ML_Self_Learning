-- Creating the schema
create schema upgrad_case_study_toylica;

-- Using the schema
use upgrad_case_study_toylica;

-- Creating table 1
CREATE TABLE `cust_dimen` (
  `Cust_id` varchar(12) NOT NULL,
  `Customer_Name` varchar(25) DEFAULT NULL,
  `City` varchar(12) DEFAULT NULL,
  `State` varchar(12) DEFAULT NULL,
  `Customer_Segment` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`Cust_id`)
);