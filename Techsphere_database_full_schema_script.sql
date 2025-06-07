CREATE DATABASE  IF NOT EXISTS `techsphere` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `techsphere`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: techsphere
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attendance_records`
--

DROP TABLE IF EXISTS `attendance_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_records` (
  `employeeid` int DEFAULT NULL,
  `employeename` text,
  `date` text,
  `check_in_time` text,
  `check_out_time` text,
  `total_hours` int DEFAULT NULL,
  `location` text,
  `shift` text,
  `manager_id` int DEFAULT NULL,
  `overtime_hours` int DEFAULT NULL,
  `days_present` int DEFAULT NULL,
  `days_absent` int DEFAULT NULL,
  `sick_leaves` int DEFAULT NULL,
  `vacation_leaves` int DEFAULT NULL,
  `late_check_ins` int DEFAULT NULL,
  `remarks` text,
  KEY `fk_emp_id_idx` (`employeeid`),
  CONSTRAINT `fk_emp_id` FOREIGN KEY (`employeeid`) REFERENCES `employee_details` (`employeeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employee_details`
--

DROP TABLE IF EXISTS `employee_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_details` (
  `employeeid` int NOT NULL,
  `employeename` text,
  `age` int DEFAULT NULL,
  `gender` text,
  `department_id` text,
  `job_title` text,
  `hire_date` text,
  `salary` int DEFAULT NULL,
  `manager_id` int DEFAULT NULL,
  `location` text,
  `performance_score` text,
  `certifications` text,
  `experience_years` int DEFAULT NULL,
  `shift` text,
  `remarks` text,
  PRIMARY KEY (`employeeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `project_assignments`
--

DROP TABLE IF EXISTS `project_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_assignments` (
  `project_id` int DEFAULT NULL,
  `employeeid` int DEFAULT NULL,
  `employeename` text,
  `project_name` text,
  `start_date` text,
  `end_date` text,
  `project_status` text,
  `client_name` text,
  `budget` int DEFAULT NULL,
  `team_size` int DEFAULT NULL,
  `manager_id` int DEFAULT NULL,
  `technologies_used` text,
  `location` text,
  `hours_worked` int DEFAULT NULL,
  `milestones_achieved` int DEFAULT NULL,
  `risks_identified` text,
  KEY `fk_emp_id2_idx` (`employeeid`),
  CONSTRAINT `fk_emp_id2` FOREIGN KEY (`employeeid`) REFERENCES `employee_details` (`employeeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `training_programs`
--

DROP TABLE IF EXISTS `training_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `training_programs` (
  `employeeid` int DEFAULT NULL,
  `employeename` text,
  `department_id` text,
  `program_id` int DEFAULT NULL,
  `program_name` text,
  `start_date` text,
  `end_date` text,
  `duration` text,
  `trainer_name` text,
  `cost` int DEFAULT NULL,
  `location` text,
  `certificate_awarded` text,
  `completion_status` text,
  `feedback_score` double DEFAULT NULL,
  `technologies_covered` text,
  `remarks` text,
  `MyUnknownColumn` text,
  KEY `fk_emp_id3_idx` (`employeeid`),
  CONSTRAINT `fk_emp_id3` FOREIGN KEY (`employeeid`) REFERENCES `employee_details` (`employeeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-07 22:48:07
