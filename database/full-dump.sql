-- Database Schema Dump
-- Generated at: 2026-03-31T13:24:40.601Z
-- Source: task-manager production database

SET FOREIGN_KEY_CHECKS = 0;

-- Table: __drizzle_migrations
DROP TABLE IF EXISTS `__drizzle_migrations`;
CREATE TABLE `__drizzle_migrations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `hash` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` bigint DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=844141;

-- Table: archived_task_progress_logs
DROP TABLE IF EXISTS `archived_task_progress_logs`;
CREATE TABLE `archived_task_progress_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `archivedTaskId` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logDate` timestamp NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `originalCreatedAt` timestamp NOT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `archived_task_progress_logs_archivedTaskId_archived_tasks_id_fk` (`archivedTaskId`),
  CONSTRAINT `archived_task_progress_logs_archivedTaskId_archived_tasks_id_fk` FOREIGN KEY (`archivedTaskId`) REFERENCES `archived_tasks` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=120001;

-- Table: archived_tasks
DROP TABLE IF EXISTS `archived_tasks`;
CREATE TABLE `archived_tasks` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `originalTaskId` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `number` int NOT NULL,
  `title` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `assignee` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `schedule` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `details` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','in-progress','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `startDate` timestamp NULL DEFAULT NULL,
  `dueDate` timestamp NULL DEFAULT NULL,
  `originalCreatedAt` timestamp NOT NULL,
  `archivedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `archivedBy` int NOT NULL,
  `archiveReason` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `archived_tasks_userId_users_id_fk` (`userId`),
  KEY `archived_tasks_archivedBy_users_id_fk` (`archivedBy`),
  CONSTRAINT `archived_tasks_userId_users_id_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `archived_tasks_archivedBy_users_id_fk` FOREIGN KEY (`archivedBy`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: businessPlanActuals
DROP TABLE IF EXISTS `businessPlanActuals`;
CREATE TABLE `businessPlanActuals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `year` int NOT NULL,
  `category` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `division` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subDivision` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `month1` decimal(20,2) DEFAULT '0',
  `month2` decimal(20,2) DEFAULT '0',
  `month3` decimal(20,2) DEFAULT '0',
  `month4` decimal(20,2) DEFAULT '0',
  `month5` decimal(20,2) DEFAULT '0',
  `month6` decimal(20,2) DEFAULT '0',
  `month7` decimal(20,2) DEFAULT '0',
  `month8` decimal(20,2) DEFAULT '0',
  `month9` decimal(20,2) DEFAULT '0',
  `month10` decimal(20,2) DEFAULT '0',
  `month11` decimal(20,2) DEFAULT '0',
  `month12` decimal(20,2) DEFAULT '0',
  `total` decimal(20,2) DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: businessPlanHistory
DROP TABLE IF EXISTS `businessPlanHistory`;
CREATE TABLE `businessPlanHistory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `businessPlanId` int NOT NULL,
  `version` int NOT NULL,
  `year` int NOT NULL,
  `category` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `division` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subDivision` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `month1` decimal(20,2) DEFAULT '0',
  `month2` decimal(20,2) DEFAULT '0',
  `month3` decimal(20,2) DEFAULT '0',
  `month4` decimal(20,2) DEFAULT '0',
  `month5` decimal(20,2) DEFAULT '0',
  `month6` decimal(20,2) DEFAULT '0',
  `month7` decimal(20,2) DEFAULT '0',
  `month8` decimal(20,2) DEFAULT '0',
  `month9` decimal(20,2) DEFAULT '0',
  `month10` decimal(20,2) DEFAULT '0',
  `month11` decimal(20,2) DEFAULT '0',
  `month12` decimal(20,2) DEFAULT '0',
  `total` decimal(20,2) DEFAULT '0',
  `changeReason` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `changedByUserId` int DEFAULT NULL,
  `changedByUserName` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `changedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `changedBy` int DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `businessPlanHistory_businessPlanId_businessPlans_id_fk` (`businessPlanId`),
  KEY `businessPlanHistory_changedByUserId_users_id_fk` (`changedByUserId`),
  CONSTRAINT `businessPlanHistory_businessPlanId_businessPlans_id_fk` FOREIGN KEY (`businessPlanId`) REFERENCES `businessPlans` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `businessPlanHistory_changedByUserId_users_id_fk` FOREIGN KEY (`changedByUserId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: businessPlans
DROP TABLE IF EXISTS `businessPlans`;
CREATE TABLE `businessPlans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `year` int NOT NULL,
  `category` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `division` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subDivision` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `month1` decimal(20,2) DEFAULT '0',
  `month2` decimal(20,2) DEFAULT '0',
  `month3` decimal(20,2) DEFAULT '0',
  `month4` decimal(20,2) DEFAULT '0',
  `month5` decimal(20,2) DEFAULT '0',
  `month6` decimal(20,2) DEFAULT '0',
  `month7` decimal(20,2) DEFAULT '0',
  `month8` decimal(20,2) DEFAULT '0',
  `month9` decimal(20,2) DEFAULT '0',
  `month10` decimal(20,2) DEFAULT '0',
  `month11` decimal(20,2) DEFAULT '0',
  `month12` decimal(20,2) DEFAULT '0',
  `total` decimal(20,2) DEFAULT '0',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=30001;

-- Table: contractBusinessPlanHistory
DROP TABLE IF EXISTS `contractBusinessPlanHistory`;
CREATE TABLE `contractBusinessPlanHistory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contractBusinessPlanId` int NOT NULL,
  `year` int NOT NULL,
  `channel` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subChannel` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `month1` int DEFAULT '0',
  `month2` int DEFAULT '0',
  `month3` int DEFAULT '0',
  `month4` int DEFAULT '0',
  `month5` int DEFAULT '0',
  `month6` int DEFAULT '0',
  `month7` int DEFAULT '0',
  `month8` int DEFAULT '0',
  `month9` int DEFAULT '0',
  `month10` int DEFAULT '0',
  `month11` int DEFAULT '0',
  `month12` int DEFAULT '0',
  `total` int DEFAULT '0',
  `changedBy` int DEFAULT NULL,
  `changeReason` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `version` int NOT NULL DEFAULT '1',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `contractBusinessPlanHistory_contractBusinessPlanId_fk` (`contractBusinessPlanId`),
  CONSTRAINT `contractBusinessPlanHistory_contractBusinessPlanId_fk` FOREIGN KEY (`contractBusinessPlanId`) REFERENCES `contractBusinessPlans` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: contractBusinessPlans
DROP TABLE IF EXISTS `contractBusinessPlans`;
CREATE TABLE `contractBusinessPlans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `year` int NOT NULL,
  `channel` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subChannel` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `month1` int DEFAULT '0',
  `month2` int DEFAULT '0',
  `month3` int DEFAULT '0',
  `month4` int DEFAULT '0',
  `month5` int DEFAULT '0',
  `month6` int DEFAULT '0',
  `month7` int DEFAULT '0',
  `month8` int DEFAULT '0',
  `month9` int DEFAULT '0',
  `month10` int DEFAULT '0',
  `month11` int DEFAULT '0',
  `month12` int DEFAULT '0',
  `total` int DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `actual1` int DEFAULT '0',
  `actual2` int DEFAULT '0',
  `actual3` int DEFAULT '0',
  `actual4` int DEFAULT '0',
  `actual5` int DEFAULT '0',
  `actual6` int DEFAULT '0',
  `actual7` int DEFAULT '0',
  `actual8` int DEFAULT '0',
  `actual9` int DEFAULT '0',
  `actual10` int DEFAULT '0',
  `actual11` int DEFAULT '0',
  `actual12` int DEFAULT '0',
  `actualTotal` int DEFAULT '0',
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=60001;

-- Table: contract_channels
DROP TABLE IF EXISTS `contract_channels`;
CREATE TABLE `contract_channels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=30001;

-- Table: contract_records
DROP TABLE IF EXISTS `contract_records`;
CREATE TABLE `contract_records` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `channel` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `previousMonthCount` int DEFAULT '0',
  `monthlyTarget` int DEFAULT '0',
  `week1Count` int DEFAULT '0',
  `week2Count` int DEFAULT '0',
  `week3Count` int DEFAULT '0',
  `week4Count` int DEFAULT '0',
  `week5Count` int DEFAULT '0',
  `totalCount` int DEFAULT '0',
  `year` int NOT NULL,
  `month` int NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `subChannel` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `achievementRate` decimal(5,1) DEFAULT '0',
  `brand` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'bombom',
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `contract_records_userId_users_id_fk` (`userId`),
  CONSTRAINT `contract_records_userId_users_id_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: contract_sub_channels
DROP TABLE IF EXISTS `contract_sub_channels`;
CREATE TABLE `contract_sub_channels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `channelId` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `contract_sub_channels_channelId_contract_channels_id_fk` (`channelId`),
  CONSTRAINT `contract_sub_channels_channelId_contract_channels_id_fk` FOREIGN KEY (`channelId`) REFERENCES `contract_channels` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: divisions
DROP TABLE IF EXISTS `divisions`;
CREATE TABLE `divisions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `divisions_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=60001;

-- Table: financial_balances
DROP TABLE IF EXISTS `financial_balances`;
CREATE TABLE `financial_balances` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `openingBalance` bigint NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: financial_records
DROP TABLE IF EXISTS `financial_records`;
CREATE TABLE `financial_records` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `week` int NOT NULL,
  `category` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('income','expense') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` bigint NOT NULL DEFAULT '0',
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: goals
DROP TABLE IF EXISTS `goals`;
CREATE TABLE `goals` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `year` int NOT NULL,
  `category` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `targetValue` bigint DEFAULT '0',
  `currentValue` bigint DEFAULT '0',
  `unit` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `priority` enum('high','medium','low') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium',
  `status` enum('not-started','in-progress','completed','delayed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'not-started',
  `startDate` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `endDate` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `goals_userId_users_id_fk` (`userId`),
  CONSTRAINT `goals_userId_users_id_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: kpi_assignees
DROP TABLE IF EXISTS `kpi_assignees`;
CREATE TABLE `kpi_assignees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: kpi_indicators
DROP TABLE IF EXISTS `kpi_indicators`;
CREATE TABLE `kpi_indicators` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kpiItemId` int NOT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `kpi_indicators_kpiItemId_kpi_items_id_fk` (`kpiItemId`),
  CONSTRAINT `kpi_indicators_kpiItemId_kpi_items_id_fk` FOREIGN KEY (`kpiItemId`) REFERENCES `kpi_items` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=60001;

-- Table: kpi_item_details
DROP TABLE IF EXISTS `kpi_item_details`;
CREATE TABLE `kpi_item_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kpiItemId` int NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `previousEvaluation` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currentPlan` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `execution` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `kpi_item_details_kpiItemId_kpi_items_id_fk` (`kpiItemId`),
  CONSTRAINT `kpi_item_details_kpiItemId_kpi_items_id_fk` FOREIGN KEY (`kpiItemId`) REFERENCES `kpi_items` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: kpi_items
DROP TABLE IF EXISTS `kpi_items`;
CREATE TABLE `kpi_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `division` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `person` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `task` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `goal` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=30001;

-- Table: kpi_records
DROP TABLE IF EXISTS `kpi_records`;
CREATE TABLE `kpi_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kpiIndicatorId` int NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `week` int NOT NULL,
  `value` decimal(15,2) DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `kpi_records_kpiIndicatorId_kpi_indicators_id_fk` (`kpiIndicatorId`),
  CONSTRAINT `kpi_records_kpiIndicatorId_kpi_indicators_id_fk` FOREIGN KEY (`kpiIndicatorId`) REFERENCES `kpi_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=30001;

-- Table: kpi_targets
DROP TABLE IF EXISTS `kpi_targets`;
CREATE TABLE `kpi_targets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kpiIndicatorId` int NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `monthlyTarget` decimal(15,2) DEFAULT '0',
  `previousActual` decimal(15,2) DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `kpi_targets_kpiIndicatorId_kpi_indicators_id_fk` (`kpiIndicatorId`),
  CONSTRAINT `kpi_targets_kpiIndicatorId_kpi_indicators_id_fk` FOREIGN KEY (`kpiIndicatorId`) REFERENCES `kpi_indicators` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=60001;

-- Table: meeting_minutes
DROP TABLE IF EXISTS `meeting_minutes`;
CREATE TABLE `meeting_minutes` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `meetingDate` timestamp NOT NULL,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attendees` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `decisions` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actionItems` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nextMeetingDate` timestamp NULL DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `meeting_minutes_userId_users_id_fk` (`userId`),
  CONSTRAINT `meeting_minutes_userId_users_id_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: monthly_messages
DROP TABLE IF EXISTS `monthly_messages`;
CREATE TABLE `monthly_messages` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `authorName` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `monthly_messages_userId_users_id_fk` (`userId`),
  CONSTRAINT `monthly_messages_userId_users_id_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: positions
DROP TABLE IF EXISTS `positions`;
CREATE TABLE `positions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `positions_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=30001;

-- Table: quarterly_reviews
DROP TABLE IF EXISTS `quarterly_reviews`;
CREATE TABLE `quarterly_reviews` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `year` int NOT NULL,
  `quarter` enum('Q1','Q2','Q3','Q4') COLLATE utf8mb4_unicode_ci NOT NULL,
  `salesTarget` bigint DEFAULT '0',
  `salesActual` bigint DEFAULT '0',
  `profitTarget` bigint DEFAULT '0',
  `profitActual` bigint DEFAULT '0',
  `strategy1Progress` int DEFAULT '0',
  `strategy2Progress` int DEFAULT '0',
  `strategy3Progress` int DEFAULT '0',
  `strategy4Progress` int DEFAULT '0',
  `achievements` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `improvements` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nextQuarterPlan` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `overallRating` enum('excellent','good','fair','poor') COLLATE utf8mb4_unicode_ci DEFAULT 'fair',
  `overallComment` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `quarterly_reviews_userId_users_id_fk` (`userId`),
  CONSTRAINT `quarterly_reviews_userId_users_id_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: ranks
DROP TABLE IF EXISTS `ranks`;
CREATE TABLE `ranks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `level` int NOT NULL DEFAULT '0',
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `ranks_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=30001;

-- Table: reports
DROP TABLE IF EXISTS `reports`;
CREATE TABLE `reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reportType` enum('weekly','monthly') COLLATE utf8mb4_unicode_ci NOT NULL,
  `reportScope` enum('individual','team','division') COLLATE utf8mb4_unicode_ci NOT NULL,
  `targetUserId` int DEFAULT NULL,
  `targetTeamId` int DEFAULT NULL,
  `targetDivisionId` int DEFAULT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `week` int DEFAULT NULL,
  `title` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nextPlan` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issues` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `generatedBy` int DEFAULT NULL,
  `reportStatus` enum('draft','finalized') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `reports_targetUserId_users_id_fk` (`targetUserId`),
  KEY `reports_targetTeamId_teams_id_fk` (`targetTeamId`),
  KEY `reports_targetDivisionId_divisions_id_fk` (`targetDivisionId`),
  KEY `reports_generatedBy_users_id_fk` (`generatedBy`),
  CONSTRAINT `reports_targetUserId_users_id_fk` FOREIGN KEY (`targetUserId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `reports_targetTeamId_teams_id_fk` FOREIGN KEY (`targetTeamId`) REFERENCES `teams` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `reports_targetDivisionId_divisions_id_fk` FOREIGN KEY (`targetDivisionId`) REFERENCES `divisions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `reports_generatedBy_users_id_fk` FOREIGN KEY (`generatedBy`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=360001;

-- Table: sales_categories
DROP TABLE IF EXISTS `sales_categories`;
CREATE TABLE `sales_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `division` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=30001;

-- Table: sales_events
DROP TABLE IF EXISTS `sales_events`;
CREATE TABLE `sales_events` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `eventDate` timestamp NOT NULL,
  `endDate` timestamp NULL DEFAULT NULL,
  `isAllDay` tinyint(1) NOT NULL DEFAULT '1',
  `eventType` enum('meeting','deadline','promotion','holiday','payment','launch','other') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `color` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '#3b82f6',
  `division` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reminderDays` int DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `sales_events_userId_users_id_fk` (`userId`),
  CONSTRAINT `sales_events_userId_users_id_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: sales_items
DROP TABLE IF EXISTS `sales_items`;
CREATE TABLE `sales_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoryId` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `sales_items_categoryId_sales_categories_id_fk` (`categoryId`),
  CONSTRAINT `sales_items_categoryId_sales_categories_id_fk` FOREIGN KEY (`categoryId`) REFERENCES `sales_categories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=30001;

-- Table: sales_records
DROP TABLE IF EXISTS `sales_records`;
CREATE TABLE `sales_records` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `division` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `productGroup` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monthlyTarget` bigint DEFAULT '0',
  `previousMonthSales` bigint DEFAULT '0',
  `week1Sales` bigint DEFAULT '0',
  `week2Sales` bigint DEFAULT '0',
  `week3Sales` bigint DEFAULT '0',
  `week4Sales` bigint DEFAULT '0',
  `week5Sales` bigint DEFAULT '0',
  `cumulativeSales` bigint DEFAULT '0',
  `achievementRate` decimal(5,1) DEFAULT '0',
  `year` int NOT NULL,
  `month` int NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `sales_records_userId_users_id_fk` (`userId`),
  CONSTRAINT `sales_records_userId_users_id_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: task_attachments
DROP TABLE IF EXISTS `task_attachments`;
CREATE TABLE `task_attachments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `taskId` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `fileName` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fileKey` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `mimeType` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'application/octet-stream',
  `fileSize` bigint DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `task_attachments_taskId_tasks_id_fk` (`taskId`),
  KEY `task_attachments_userId_users_id_fk` (`userId`),
  CONSTRAINT `task_attachments_taskId_tasks_id_fk` FOREIGN KEY (`taskId`) REFERENCES `tasks` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `task_attachments_userId_users_id_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=90001;

-- Table: task_progress_logs
DROP TABLE IF EXISTS `task_progress_logs`;
CREATE TABLE `task_progress_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `taskId` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logDate` timestamp NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `task_progress_logs_taskId_tasks_id_fk` (`taskId`),
  CONSTRAINT `task_progress_logs_taskId_tasks_id_fk` FOREIGN KEY (`taskId`) REFERENCES `tasks` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=510001;

-- Table: tasks
DROP TABLE IF EXISTS `tasks`;
CREATE TABLE `tasks` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `number` int NOT NULL,
  `title` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `assignee` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `schedule` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `details` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','in-progress','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `startDate` timestamp NULL DEFAULT NULL,
  `dueDate` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `tasks_userId_users_id_fk` (`userId`),
  CONSTRAINT `tasks_userId_users_id_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: teams
DROP TABLE IF EXISTS `teams`;
CREATE TABLE `teams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `divisionId` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `teams_divisionId_divisions_id_fk` (`divisionId`),
  CONSTRAINT `teams_divisionId_divisions_id_fk` FOREIGN KEY (`divisionId`) REFERENCES `divisions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=60001;

-- Table: users
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `openId` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(320) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `loginMethod` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('user','admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `lastSignedIn` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `divisionId` int DEFAULT NULL,
  `teamId` int DEFAULT NULL,
  `positionId` int DEFAULT NULL,
  `rankId` int DEFAULT NULL,
  `isProfileComplete` tinyint(1) NOT NULL DEFAULT '0',
  `koreanName` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `canEditSales` tinyint(1) NOT NULL DEFAULT '0',
  `canEditFinancial` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `users_openId_unique` (`openId`),
  KEY `users_divisionId_divisions_id_fk` (`divisionId`),
  KEY `users_teamId_teams_id_fk` (`teamId`),
  KEY `users_positionId_positions_id_fk` (`positionId`),
  KEY `users_rankId_ranks_id_fk` (`rankId`),
  CONSTRAINT `users_divisionId_divisions_id_fk` FOREIGN KEY (`divisionId`) REFERENCES `divisions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `users_teamId_teams_id_fk` FOREIGN KEY (`teamId`) REFERENCES `teams` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `users_positionId_positions_id_fk` FOREIGN KEY (`positionId`) REFERENCES `positions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `users_rankId_ranks_id_fk` FOREIGN KEY (`rankId`) REFERENCES `ranks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=14580001;

SET FOREIGN_KEY_CHECKS = 1;


-- Database Data Dump
-- Generated at: 2026-03-31T13:24:40.601Z
-- Source: task-manager production database

SET FOREIGN_KEY_CHECKS = 0;

-- Table: __drizzle_migrations (27 rows)
INSERT INTO `__drizzle_migrations` (`id`, `hash`, `created_at`) VALUES
(1, '814a08e40d7fc2bcfd458759d18319198ca8ae394f2fa15617a78678e9c9c93b', 1769398883600),
(2, 'b8e56fdb5774662fc645d51865507e481f6fea1dbd9842e14069bec20bbd9d40', 1769399415437),
(236314, 'cd87bc182428f03ca207b606e305c72dfd3b486db0b769f0f2824089f7860f8f', 1769405618693),
(266314, 'b709caaae2014f691c4cbc5a48f24df421a3fb5405656657487602414d680137', 1769409257511),
(296314, '10ec1a3704fada24c7fc7a07522104177cc446bcac8a6988b11dbae71a1bd892', 1769430995844),
(326314, 'cc2abf06322de844f7616cc9f7f406e1ba0d50988f0cd063f532d706cb1337dc', 1769433941682),
(326315, 'c09b17ad27424af46cd1463716b455e293d017a04c71156ad6c6477f53cf33de', 1769436806176),
(326316, 'd5cd461ea93b7331098f57f58868c832163ff37b258f9fe3fd1e988ec5c29645', 1769437947018),
(356314, '883dd7c6f596d201fbfb7ec12e3ad5fe2f1790c1c5362469a4453da69c7c99c1', 1769472249228),
(386314, '1aff44f63131888856b831355cae3338cf26105257c07b6af58426f178592b46', 1769484735499),
(386315, '848aada362e61b4f21826b5698a3dae4ec20c3f430091e21f05e6bdd3604e980', 1769487588011),
(416314, '4f4232f16b312337b51d0b494ba8d1b5d5f86354a8739df8123d3237bc752987', 1770001133532),
(446314, 'a1aaebb1ac3296c704213bf776262dbf81aaf080cc71d6ffd2dd436765abb1df', 1770005378029),
(476314, '19b0c8652c1903af71580c06ca5c0c160b2be4745a5e257547e2d835930bfcaf', 1770018172502),
(506314, 'ee3c23f041f5aca1fdfa20703515d6b088bd7638e1f3ee7ca630a8a93c63ece8', 1770085871286),
(536314, 'a6a3fc930ac778ae1b332961e337d9dec6cb6d1291c1754a1b61c03f74fa9e77', 1770087661918),
(566314, '0f8fec2e6e10ff7caa0158efd5f9c4d2c07d3ce8519b90cf8bd5dce9ee97d3ea', 1770187817546),
(596314, 'da21e8258c1f67ab48568cd1ca66337ea4b14cb1f6626c85dc649445dd4a3b15', 1770196465073),
(626314, 'afb2882bd2a067b759f91d35686095696114b94992ebe4a0a07cd1f119b392dd', 1770256297044),
(656314, '0002_square_the_hunter', 1770867432893),
(686314, '0eba4d300e4416398f479df17150009e7d3fc79bf3d2a9e2c40abca827babdc0', 1771904890930),
(716314, '956881fc71902ab2dbbc5b4c447ffd6389715e86f9f203441d4a6d008eaaf74e', 1772596005732),
(746314, 'dcbad9479a2b3c24f89d50fc1720c3e2ab02e0ebde234070ab32c1ab6cfbda4a', 1772958721901),
(776314, '748e966d9454c518e6bac000508880bcd8adb6d783970bc8a8f3fda56c590752', 1773635279689),
(776315, '0d882d6cb912a6518d398b703eb4e94f11b2d3ea874c241994221999e5116563', 1773638305995),
(776316, '3b0a1540d77244e319161c156b8117d71a8c0aeb0373ddbbbeb9c6288b4c0758', 1773640032193),
(806314, '9483d3be3ddcd62add5e4f866c283c4bf614a3a4b5f8290754f0935294ca4cbc', 1773646332550);

-- Table: archived_task_progress_logs (11 rows)
INSERT INTO `archived_task_progress_logs` (`id`, `archivedTaskId`, `logDate`, `content`, `originalCreatedAt`) VALUES
(1, 'I7U-rAKPhSJsz8bKaJ6wQ', '2026-01-28 05:00:00', '수수료협의. 요청자료 제공', '2026-02-02 12:46:49'),
(2, 'UwkvDZLWPPKU33QPykiOL', '2026-02-03 05:00:00', '쿠션입고', '2026-02-02 12:48:05'),
(30001, 'DX09JiDdrupax94s_7Exz', '2026-02-03 09:08:52', '생산완료', '2026-02-03 09:09:07'),
(30002, 'XsLmCsJ7Jhy32DhppP5hQ', '2026-01-30 05:00:00', '시안확정', '2026-02-10 10:26:17'),
(30003, 'XsLmCsJ7Jhy32DhppP5hQ', '2026-02-10 10:26:08', '샘플 검토', '2026-02-10 10:26:17'),
(60001, 'leMKiA3wpLLNon39raZHv', '2026-02-25 05:00:00', '물류담당자 미팅 진행', '2026-03-04 08:46:34'),
(60002, 'uWxDKg_Lc2aqowQYJbUxJ', '2026-02-20 05:00:00', '추가발주건 생산 진행', '2026-02-23 15:10:48'),
(60003, 'V9RUNzx6CNDToUsRyoIxA', '2026-02-02 12:39:11', '일정 및 목적 수립', '2026-02-02 12:39:34'),
(60004, 'ns1Lo9wKH2m4Mk91yqImk', '2026-02-02 12:30:30', '견적요청', '2026-02-03 05:46:52'),
(60005, 'BTe9kJ_zxXgFFj7vImILW', '2026-01-30 05:00:00', '1차 채용인원(7명)확정, 기숙사 준비', '2026-02-02 12:45:05'),
(90001, '7zUV72VEvGMpLqR-PC3-D', '2026-02-24 09:16:38', '정시영차장에게 금형발주 요청', '2026-02-24 09:16:54');

-- Table: archived_tasks (27 rows)
INSERT INTO `archived_tasks` (`id`, `originalTaskId`, `userId`, `number`, `title`, `department`, `assignee`, `schedule`, `details`, `status`, `startDate`, `dueDate`, `originalCreatedAt`, `archivedAt`, `archivedBy`, `archiveReason`) VALUES
('0qFA9op05XaZemIJnfXXt', 'SoqWTiJfkcPqxoYnXt7J2', 1, 5, '유비플러스 세팅 - 리코코', '고객영업팀', '이주홍파트장', '2월중', '담당자에게 진행 방법 전달', 'pending', NULL, NULL, '2026-01-26 08:55:00', '2026-03-17 06:29:26', 1, NULL),
('3qMx8yTLO4LlTRhK9aOMf', 'qgmJFOEXnZh2aHT85mT8l', 1, 45, '직원교육', '', '', '', '업무관리 프로그램 사용법\n유비플러스 사용법', 'completed', NULL, NULL, '2026-03-17 06:28:06', '2026-03-26 14:14:28', 1, NULL),
('6RZp0B5_Dbtv97fQ09GqK', 'nCqY4rfgntD8wyBjxuSqD', 1, 22, '리코코매트 샘플 확인', '', '', '완료', 'UV인쇄 제품 확인', 'completed', NULL, NULL, '2026-01-26 08:55:04', '2026-02-02 13:29:51', 1, NULL),
('7zUV72VEvGMpLqR-PC3-D', '9ryc0EEm9WfGZ7KfTBo5L', 1, 43, '기존생산라인 추가 금형 발주', '', '', '', '', 'completed', '2026-02-24 05:00:00', NULL, '2026-02-24 07:31:44', '2026-03-26 14:14:28', 1, NULL),
('A3pIUnd6CmncieGvtkAPe', 'IiwaL40jinNDMq8FmVMlc', 1, 1, '성동구 어린이집 시공', '채널영업팀', '서범주팀장', '2월초', '성동구내 어린이집 매트 시공건으로 전년도 중반부터 3회 시공하였음. 구청 담당자 영업을 통해 확대 가능함.', 'completed', NULL, NULL, '2026-01-26 08:54:59', '2026-02-12 08:30:33', 1, NULL),
('BTe9kJ_zxXgFFj7vImILW', 'UL_9OrTnLrPPFuCUx0_Hv', 1, 18, '생산직 근로자 채용', '제조사업부', '정시영차장', '2월중', '신규라인 투입을 위한 인원충원', 'completed', NULL, NULL, '2026-01-26 08:55:03', '2026-03-17 06:29:26', 1, NULL),
('BUdklecfug2ArszN22zpM', 'PfmmEuRGw6T_ftf12axKe', 1, 2, '2026년 연봉협상', '', '', '1월말', '1월말까지 기존 직원대상 26년 연봉 확정. 생산 및 물류 직원 연봉협의 완료', 'completed', NULL, NULL, '2026-01-26 08:54:59', '2026-02-04 07:55:14', 1, NULL),
('deiKMX_yNOmkYyE8j6O3M', '5vMLIjLnqjbOHEqpVlBQB', 1, 36, '클립매트 신규 체결구조 특허출원', '', '', '', '매트간 결착선 유지기능', 'completed', NULL, '2026-02-09 05:00:00', '2026-02-10 10:04:55', '2026-02-13 09:11:12', 1, NULL),
('DX09JiDdrupax94s_7Exz', 'RAW6rZU04eYWNCR-DyP39', 1, 31, '링크맘 PB 브랜드 매트 제조', '', '', '', '1차 발주분 - 1700장', 'completed', NULL, NULL, '2026-02-03 08:38:52', '2026-02-12 08:30:33', 1, NULL),
('dXRjYS5TqjBUgZ-7Qdu08', 'G0IyXDdudz7JzvyY2qPr3', 1, 29, '기술보증기금 대출 연장 건', '', '', '', '금요일 실사조사', 'completed', NULL, NULL, '2026-02-03 07:16:31', '2026-02-24 08:47:26', 1, NULL),
('I7U-rAKPhSJsz8bKaJ6wQ', '8FXTGgT-qGJLQcZRIwUn2', 1, 14, '엔레드- 마케팅/영업 협력 방안', '', '', '', '슈슈비매트 판매 수수료', 'completed', NULL, NULL, '2026-01-26 08:55:02', '2026-02-04 07:55:14', 1, NULL),
('K_o2B1K29l609RL6DDpkc', 'nZ1o657OGl96Jd1K4UeU-', 1, 32, '주간/월간 업무보고 양식 수정', '', '', '', '', 'pending', NULL, NULL, '2026-02-05 06:17:15', '2026-03-17 06:29:25', 1, NULL),
('kXHogrNfrmLpENfhUMxAR', 'C4AENti7cARgqX1X1Okhy', 1, 23, '수원코베 베이비페어', '채널영업팀', '조희태과장', '', '계약건수 -18건', 'completed', NULL, NULL, '2026-01-26 08:55:04', '2026-02-04 07:55:14', 1, NULL),
('leMKiA3wpLLNon39raZHv', 'hVJsFekp4j64KZFQh8naU', 1, 42, '물류 오배송 최소화 방안 도출', '', '', '', '물류담당자 미팅', 'completed', '2026-02-25 05:00:00', NULL, '2026-02-24 07:30:44', '2026-03-17 06:29:25', 1, NULL),
('NHoR_vS6vbX_f-FHBoEDK', 'jMl_7NJWNJsWOyUZMmXBu', 1, 35, '슈슈비 매트 판매분석', '', '', '', '세트상품 구매비중\nL 사이즈(24장) : 53%\nM 사이즈(20장): 30%\nS 사이즈(16장): 17%\n\n평균 구매장수 36장\n\n재구매율 24%\n\n구매패턴비율\n낱개구매 68%\n세트구매 32%', 'completed', NULL, '2026-02-09 05:00:00', '2026-02-09 11:06:11', '2026-02-13 09:11:12', 1, NULL),
('ns1Lo9wKH2m4Mk91yqImk', 'mYaLW3V8UrniiQZqOsAYV', 1, 26, '청계에스케이뷰 어린이집 시공의뢰', '매트사업부', '서범주', '', '성동구청 어린이집\n시공일 2/27-28', 'pending', '2026-02-02 05:00:00', '2026-02-28 05:00:00', '2026-02-02 09:06:30', '2026-03-17 06:29:25', 1, NULL),
('NvPf9fNqQU41EZscwTX0V', 'gJIHEFCUIo-8wDYEDkTPn', 1, 6, '싱가폴 수출물량입력', '물류팀', '최재형부장', '2월초', '2월 출고 요청 건 접수', 'completed', NULL, NULL, '2026-01-26 08:55:00', '2026-02-12 08:30:33', 1, NULL),
('NZU4oS6TiHanDONO_uy7u', 'JKhjQybe9Lga2XeXB-UDC', 1, 4, '물류. 포장라인 직원채용', '', '', '완료', '1월 26일(물류) 2월 1일(생산)출근예정', 'completed', NULL, NULL, '2026-01-26 08:55:00', '2026-02-02 13:29:51', 1, NULL),
('OWKi8qXzQLfnUUQLDlnJ1', 'TqDRhB64Ohoh9UaoMGdB1', 1, 12, '롤매트 생산업체 확인', '', '', '', '취급가능 최대 두께 12t ', 'completed', NULL, NULL, '2026-01-26 08:55:01', '2026-02-04 07:55:14', 1, NULL),
('PypgXkUK00fG1L4E1OXFt', 'SRdh9keR8npnuAKQDpdGk', 1, 15, '부산지사 전시회 실적 확인', '채널영업팀', '조희태과장', '완료', '계약- 32건', 'completed', NULL, NULL, '2026-01-26 08:55:02', '2026-02-02 13:29:51', 1, NULL),
('R9RakgvRIsonZOiZFLIF5', 'HJgIxAqfOqb8El23-Z_qR', 1, 16, '네이버라이브 방송', '채널영업팀', '송채림대리', '2026-01-29', '계약건수 -37건', 'completed', NULL, NULL, '2026-01-26 08:55:02', '2026-02-04 07:55:14', 1, NULL),
('UwkvDZLWPPKU33QPykiOL', 'WZ_AGX6KeGOv0REKg0tIY', 1, 8, '아기소파 리오더', '물류팀', '최재형부장', '2월초', '사은품으로 사용되던 아기 소파 리오더 발주 총 수량 240개 중 150개 우선 발주', 'completed', NULL, NULL, '2026-01-26 08:55:00', '2026-02-04 07:55:14', 1, NULL),
('uWxDKg_Lc2aqowQYJbUxJ', 'd-nBXFq5x69aDYPL3J8sN', 1, 38, '피코베리 클립매트 공동구매 진행', '', '', '', '최초 생산량 - 1,700장\n공구발주수량 - 5,385장\n2차발주수량 - 10,600장\n2차 공구일정 - 3월 2째주', 'completed', '2026-02-12 05:00:00', NULL, '2026-02-12 08:31:17', '2026-03-17 06:29:25', 1, NULL),
('V9RUNzx6CNDToUsRyoIxA', 'MMMI1a2b5YtdSEf7r1xSq', 1, 27, '2026년 KPI 달성을 위한 워크샵', '', '', '', '1. 담당자 및 부서별 2026년 목표달성 방안\n2. 업무프로세스 개선을 위한 협의\n', 'pending', '2026-03-06 05:00:00', NULL, '2026-02-02 09:10:33', '2026-03-17 06:29:25', 1, NULL),
('vA1sunQDf28iSYYsEevvT', 'MY-76d7URrwLYo0-YZWkg', 1, 20, '마케팅리뷰', '꿈비', '방승현팀장', '1월말', '꿈비 마케팅 담당자가 리뷰한 봄봄매트 마케팅 현황', 'pending', NULL, NULL, '2026-01-26 08:55:03', '2026-03-17 06:29:25', 1, NULL),
('XsLmCsJ7Jhy32DhppP5hQ', 'GmH09FrJ-YC5IH_fNhQvO', 1, 21, '매장사인물-봄봄', '채널영업팀', '조희태과장', '2월말', '봄봄매트 취급 매장 사인물 제작', 'completed', NULL, NULL, '2026-01-26 08:55:03', '2026-02-12 08:30:33', 1, NULL),
('yuVVZJT8RcaQ857waEH84', 'yf5igOiW4w-P5nEoykfmW', 1, 7, '미국 수출 인보이스', '', '', '완료', '신규 거래선으로 금주 수요일 샘플 출고 예정', 'completed', NULL, NULL, '2026-01-26 08:55:00', '2026-02-02 13:47:35', 1, NULL);

-- Table: businessPlanActuals (0 rows)

-- Table: businessPlanHistory (0 rows)

-- Table: businessPlans (38 rows)
INSERT INTO `businessPlans` (`id`, `year`, `category`, `division`, `subDivision`, `month1`, `month2`, `month3`, `month4`, `month5`, `month6`, `month7`, `month8`, `month9`, `month10`, `month11`, `month12`, `total`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
(1, 2026, 'quantity', 'bombom_construction', NULL, '26000.00', '26760.00', '29000.00', '29336.00', '32000.00', '29000.00', '28000.00', '28000.00', '30000.00', '32000.00', '34000.00', '36000.00', '360096.00', 0, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(2, 2026, 'quantity', 'bombom_construction', 'headquarters', '17000.00', '17000.00', '19000.00', '20336.00', '22000.00', '20000.00', '19000.00', '19000.00', '20000.00', '21000.00', '22000.00', '23000.00', '239336.00', 1, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(3, 2026, 'quantity', 'bombom_construction', 'branch', '9000.00', '9760.00', '10000.00', '9000.00', '10000.00', '9000.00', '9000.00', '9000.00', '10000.00', '11000.00', '12000.00', '13000.00', '120760.00', 2, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(4, 2026, 'quantity', 'online_sales', NULL, '24000.00', '24500.00', '24500.00', '24500.00', '24500.00', '24500.00', '24500.00', '24500.00', '24500.00', '24500.00', '24500.00', '24500.00', '293500.00', 3, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(5, 2026, 'quantity', 'online_sales', 'bombom', '8000.00', '9000.00', '9000.00', '9000.00', '9000.00', '9000.00', '9000.00', '9000.00', '9000.00', '9000.00', '9000.00', '9000.00', '107000.00', 4, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(6, 2026, 'quantity', 'online_sales', 'shushuvi', '15000.00', '15000.00', '15000.00', '15000.00', '15000.00', '15000.00', '15000.00', '15000.00', '15000.00', '15000.00', '15000.00', '15000.00', '180000.00', 5, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(7, 2026, 'quantity', 'online_sales', 'etc', '1000.00', '500.00', '500.00', '500.00', '500.00', '500.00', '500.00', '500.00', '500.00', '500.00', '500.00', '500.00', '6500.00', 6, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(8, 2026, 'quantity', 'oem_supply', NULL, '2500.00', '2711.00', '4247.00', '4240.00', '4884.00', '3793.00', '3372.00', '2968.00', '5981.00', '4569.00', '8714.00', '6240.00', '54219.00', 7, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(9, 2026, 'quantity', 'oem_supply', 'linkmom', '0.00', '3500.00', '2500.00', '2575.00', '2652.00', '2732.00', '2814.00', '2898.00', '2985.00', '3075.00', '3167.00', '3262.00', '32160.00', 8, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(10, 2026, 'quantity', 'oem_supply', 'ricoco', '0.00', '0.00', '500.00', '1250.00', '2500.00', '1875.00', '1250.00', '625.00', '3750.00', '2500.00', '6250.00', '3750.00', '24250.00', 9, '2026-02-05 10:06:55', '2026-02-05 10:22:34'),
(11, 2026, 'quantity', 'oem_supply', 'creamhouse', '2500.00', '2711.00', '3747.00', '2990.00', '2384.00', '1918.00', '2122.00', '2343.00', '2231.00', '2069.00', '2464.00', '2490.00', '29969.00', 10, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(12, 2026, 'revenue', 'bombom_construction', NULL, '608400000.00', '623600000.00', '678800000.00', '692467200.00', '754400000.00', '684000000.00', '658800000.00', '658800000.00', '704000000.00', '749200000.00', '794400000.00', '839600000.00', '8446467200.00', 11, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(13, 2026, 'revenue', 'bombom_construction', 'headquarters', '428400000.00', '428400000.00', '478800000.00', '512467200.00', '554400000.00', '504000000.00', '478800000.00', '478800000.00', '504000000.00', '529200000.00', '554400000.00', '579600000.00', '6031267200.00', 12, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(14, 2026, 'revenue', 'bombom_construction', 'branch', '180000000.00', '195200000.00', '200000000.00', '180000000.00', '200000000.00', '180000000.00', '180000000.00', '180000000.00', '200000000.00', '220000000.00', '240000000.00', '260000000.00', '2415200000.00', 13, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(15, 2026, 'revenue', 'online_sales', NULL, '410000000.00', '405000000.00', '423000000.00', '423000000.00', '423000000.00', '423000000.00', '423000000.00', '423000000.00', '423000000.00', '423000000.00', '423000000.00', '423000000.00', '5045000000.00', 14, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(16, 2026, 'revenue', 'online_sales', 'bombom', '80000000.00', '90000000.00', '108000000.00', '108000000.00', '108000000.00', '108000000.00', '108000000.00', '108000000.00', '108000000.00', '108000000.00', '108000000.00', '108000000.00', '1250000000.00', 15, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(17, 2026, 'revenue', 'online_sales', 'shushuvi', '300000000.00', '300000000.00', '300000000.00', '300000000.00', '300000000.00', '300000000.00', '300000000.00', '300000000.00', '300000000.00', '300000000.00', '300000000.00', '300000000.00', '3600000000.00', 16, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(18, 2026, 'revenue', 'online_sales', 'etc', '30000000.00', '15000000.00', '15000000.00', '15000000.00', '15000000.00', '15000000.00', '15000000.00', '15000000.00', '15000000.00', '15000000.00', '15000000.00', '15000000.00', '195000000.00', 17, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(19, 2026, 'revenue', 'oem_supply', NULL, '24500000.00', '79067800.00', '99220600.00', '130427000.00', '188146950.00', '153523663.00', '125502180.00', '97684178.00', '254140761.00', '191396470.00', '384151078.00', '260830994.00', '1988591674.00', 18, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(20, 2026, 'revenue', 'oem_supply', 'linkmom', '0.00', '52500000.00', '37500000.00', '38625000.00', '39783750.00', '40977263.00', '42206580.00', '43472778.00', '44776961.00', '46120270.00', '47503878.00', '48928994.00', '482395474.00', 19, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(21, 2026, 'revenue', 'oem_supply', 'ricoco', '0.00', '0.00', '25000000.00', '62500000.00', '125000000.00', '93750000.00', '62500000.00', '31250000.00', '187500000.00', '125000000.00', '312500000.00', '187500000.00', '1212500000.00', 20, '2026-02-05 10:06:55', '2026-02-05 10:22:34'),
(22, 2026, 'revenue', 'oem_supply', 'creamhouse', '24500000.00', '26567800.00', '36720600.00', '29302000.00', '23363200.00', '18796400.00', '20795600.00', '22961400.00', '21863800.00', '20276200.00', '24147200.00', '24402000.00', '293696200.00', 21, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(23, 2026, 'cost', 'bombom_construction', NULL, '374040000.00', '383920000.00', '417280000.00', '424480320.00', '462640000.00', '419400000.00', '404280000.00', '404280000.00', '432400000.00', '460520000.00', '488640000.00', '516760000.00', '5188640320.00', 22, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(24, 2026, 'cost', 'bombom_construction', 'headquarters', '257040000.00', '257040000.00', '287280000.00', '307480320.00', '332640000.00', '302400000.00', '287280000.00', '287280000.00', '302400000.00', '317520000.00', '332640000.00', '347760000.00', '3618760320.00', 23, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(25, 2026, 'cost', 'bombom_construction', 'branch', '117000000.00', '126880000.00', '130000000.00', '117000000.00', '130000000.00', '117000000.00', '117000000.00', '117000000.00', '130000000.00', '143000000.00', '156000000.00', '169000000.00', '1569880000.00', 24, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(26, 2026, 'cost', 'online_sales', NULL, '261000000.00', '258000000.00', '271500000.00', '271500000.00', '271500000.00', '271500000.00', '271500000.00', '271500000.00', '271500000.00', '271500000.00', '271500000.00', '271500000.00', '3234000000.00', 25, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(27, 2026, 'cost', 'online_sales', 'bombom', '60000000.00', '67500000.00', '81000000.00', '81000000.00', '81000000.00', '81000000.00', '81000000.00', '81000000.00', '81000000.00', '81000000.00', '81000000.00', '81000000.00', '937500000.00', 26, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(28, 2026, 'cost', 'online_sales', 'shushuvi', '180000000.00', '180000000.00', '180000000.00', '180000000.00', '180000000.00', '180000000.00', '180000000.00', '180000000.00', '180000000.00', '180000000.00', '180000000.00', '180000000.00', '2160000000.00', 27, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(29, 2026, 'cost', 'online_sales', 'etc', '21000000.00', '10500000.00', '10500000.00', '10500000.00', '10500000.00', '10500000.00', '10500000.00', '10500000.00', '10500000.00', '10500000.00', '10500000.00', '10500000.00', '136500000.00', 28, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(30, 2026, 'cost', 'oem_supply', NULL, '19600000.00', '52754240.00', '66876480.00', '84116600.00', '117560810.00', '95873478.00', '79460428.00', '63202787.00', '156857217.00', '118893122.00', '235320087.00', '161378997.00', '1251894245.00', 29, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(31, 2026, 'cost', 'oem_supply', 'linkmom', '0.00', '31500000.00', '22500000.00', '23175000.00', '23870250.00', '24586358.00', '25323948.00', '26083667.00', '26866177.00', '27672162.00', '28502327.00', '29357397.00', '289437285.00', 30, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(32, 2026, 'cost', 'oem_supply', 'ricoco', '0.00', '0.00', '15000000.00', '37500000.00', '75000000.00', '56250000.00', '37500000.00', '18750000.00', '112500000.00', '75000000.00', '187500000.00', '112500000.00', '727500000.00', 31, '2026-02-05 10:06:55', '2026-02-05 10:22:34'),
(33, 2026, 'cost', 'oem_supply', 'creamhouse', '19600000.00', '21254240.00', '29376480.00', '23441600.00', '18690560.00', '15037120.00', '16636480.00', '18369120.00', '17491040.00', '16220960.00', '19317760.00', '19521600.00', '234956960.00', 32, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(34, 2026, 'revenue', 'ricoco', NULL, '100000000.00', '50000000.00', '150000000.00', '100000000.00', '200000000.00', '150000000.00', '100000000.00', '50000000.00', '300000000.00', '200000000.00', '500000000.00', '300000000.00', '2200000000.00', 33, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(35, 2026, 'quantity', 'ricoco', NULL, '1250.00', '625.00', '1875.00', '1250.00', '2500.00', '1875.00', '1250.00', '625.00', '3750.00', '2500.00', '6250.00', '3750.00', '27500.00', 34, '2026-02-05 10:06:55', '2026-02-05 10:06:55'),
(36, 2026, 'quantity', 'oem_supply', 'oem_etc', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', 0, '2026-02-05 10:22:43', '2026-02-05 10:22:43'),
(37, 2026, 'revenue', 'oem_supply', 'oem_etc', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', 0, '2026-02-05 10:22:49', '2026-02-05 10:22:49'),
(38, 2026, 'cost', 'oem_supply', 'oem_etc', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', 0, '2026-02-05 10:22:56', '2026-02-05 10:22:56');

-- Table: contractBusinessPlanHistory (0 rows)

-- Table: contractBusinessPlans (2 rows)
INSERT INTO `contractBusinessPlans` (`id`, `year`, `channel`, `subChannel`, `month1`, `month2`, `month3`, `month4`, `month5`, `month6`, `month7`, `month8`, `month9`, `month10`, `month11`, `month12`, `total`, `createdAt`, `updatedAt`, `actual1`, `actual2`, `actual3`, `actual4`, `actual5`, `actual6`, `actual7`, `actual8`, `actual9`, `actual10`, `actual11`, `actual12`, `actualTotal`) VALUES
(1, 2026, '내부채널', '샘플신청', 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, '2026-02-05 13:23:50', '2026-02-05 13:23:50', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(30001, 2026, '내부채널', '채널톡', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2026-02-05 13:59:45', '2026-02-05 13:59:45', 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5);

-- Table: contract_channels (1 rows)
INSERT INTO `contract_channels` (`id`, `name`, `isActive`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
(1, '기타', 1, 0, '2026-01-27 05:33:17', '2026-01-27 05:33:17');

-- Table: contract_records (66 rows)
INSERT INTO `contract_records` (`id`, `userId`, `channel`, `previousMonthCount`, `monthlyTarget`, `week1Count`, `week2Count`, `week3Count`, `week4Count`, `week5Count`, `totalCount`, `year`, `month`, `createdAt`, `updatedAt`, `subChannel`, `achievementRate`, `brand`) VALUES
('-6ojysh6V9oCtenf7NkZ5', 1, '외부채널', 15, 0, 0, 1, 0, 0, 0, 1, 2026, 1, '2026-01-26 19:20:24', '2026-01-27 06:40:40', '인플루언서공구', '0.0', 'bombom'),
('0ZOjRydVkkvX97Omb7bO9', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:18', '2026-02-12 11:03:18', '시공팀', '0.0', 'ricoco'),
('2iP3NzYwsgkPYV75a1xlt', 1, '외부채널', 2, 50, 0, 27, 3, 16, 0, 46, 2026, 1, '2026-01-26 19:20:21', '2026-02-03 06:57:01', '베이비페어', '92.0', 'bombom'),
('3lG2tPaO5E4ATL6b6kmLQ', 1, '외부채널', 17, 20, 9, 3, 11, 4, 0, 27, 2026, 2, '2026-02-03 06:59:39', '2026-03-03 07:41:21', '유아매장', '135.0', 'bombom'),
('3sUv7YKtYpSXTIGjKspHA', 1, '외부채널', 0, 50, 0, 17, 2, 3, 0, 22, 2026, 2, '2026-02-03 06:59:39', '2026-03-03 07:41:21', '인플루언서공구', '44.0', 'bombom'),
('3URprWzlO_MCHYqHOdLb6', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:18', '2026-02-12 11:03:18', '유아매장', '0.0', 'ricoco'),
('4wRzqhoGn7h4PplTfvIIV', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 2, '2026-02-12 11:09:22', '2026-02-12 11:09:22', '입주박람회', '0.0', 'ricoco'),
('7fa5DdYTyagKEaGS08T2P', 1, '외부채널', 0, 0, 1, 0, 0, 0, 0, 1, 2026, 2, '2026-02-03 06:59:39', '2026-02-11 12:12:16', '입주박람회', '0.0', 'bombom'),
('84e3R6y4Tw1C_KX0hkUj2', 1020001, '내부채널', 1, 5, 0, 1, 1, 0, 0, 2, 2026, 3, '2026-03-09 06:44:50', '2026-03-23 04:37:42', '샘플신청', '40.0', 'bombom'),
('85J_-IkQLuMuxt_Bj32iL', 1020001, '내부채널', 30, 25, 2, 10, 10, 8, 0, 30, 2026, 3, '2026-03-09 06:44:51', '2026-03-30 06:50:12', '채널톡', '120.0', 'bombom'),
('9027ve9VYIiCkV_oB172Z', 1, '외부채널', 46, 0, 2, 0, 0, 1, 0, 3, 2026, 2, '2026-02-03 06:59:38', '2026-03-03 07:41:20', '베이비페어', '0.0', 'bombom'),
('9GHfRfsZQGIq96OIxaI2w', 1, '내부채널', 3, 5, 1, 0, 0, 0, 0, 1, 2026, 1, '2026-01-26 19:20:15', '2026-01-27 06:40:38', '샘플신청', '20.0', 'bombom'),
('biZRiqJpNaBms9BL9VuSO', 1080001, '내부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:16', '2026-02-12 11:03:16', '상담전화', '0.0', 'ricoco'),
('bMizmQJA0AmP51a_NjbIl', 1080001, '내부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 2, '2026-02-12 11:09:20', '2026-02-12 11:09:20', '홈피문의', '0.0', 'ricoco'),
('BvIqu1B7pyYC2WpaHGzcl', 1, '외부채널', 48, 50, 4, 3, 33, 2, 0, 42, 2026, 1, '2026-01-26 19:20:29', '2026-02-03 06:57:03', '지사자체상담', '84.0', 'bombom'),
('C0qHytDS-KUo3aqXCcIBg', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:17', '2026-02-12 11:03:17', '라이브커머스', '0.0', 'ricoco'),
('Ce6T_cljI46Tcfy8qEof7', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:19', '2026-02-12 11:03:19', '입주박람회', '0.0', 'ricoco'),
('dDYlAPSHCr3gARkn5G0hU', 1, '외부채널', 0, 0, 0, 0, 5, 2, 0, 7, 2026, 1, '2026-01-26 19:20:22', '2026-02-03 06:57:01', '시공팀', '0.0', 'bombom'),
('DFkFx8QzM-F67DSPj6lDr', 1020001, '외부채널', 3, 5, 0, 2, 0, 1, 0, 3, 2026, 3, '2026-03-09 06:45:41', '2026-03-30 06:50:14', '시공팀', '60.0', 'bombom'),
('dnhrVW7zvxShtDMvBNRbT', 1080001, '내부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 2, '2026-02-12 11:09:19', '2026-02-12 11:09:19', '상담전화', '0.0', 'ricoco'),
('efABB9jtpqcsNhduRE3Wj', 1020001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 3, '2026-03-09 06:47:29', '2026-03-09 06:47:29', '지사자체상담', '0.0', 'ricoco'),
('Et9BbJ_XuQqzzLIE63C6J', 1020001, '외부채널', 39, 45, 22, 29, 0, 3, 0, 54, 2026, 3, '2026-03-09 06:45:42', '2026-03-30 06:50:15', '지사자체상담', '120.0', 'bombom'),
('eXRuzQ13tlka5YiYri7DR', 1, '외부채널', 43, 40, 0, 0, 1, 17, 0, 18, 2026, 2, '2026-02-03 06:59:38', '2026-03-03 07:41:20', '라이브커머스', '45.0', 'bombom'),
('F-83mgFf9CtowxL2D-kqX', 1020001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 3, '2026-03-09 06:47:27', '2026-03-09 06:47:27', '인플루언서공구', '0.0', 'ricoco'),
('FLg5w4crkYrZp8LtSXZFC', 1020001, '내부채널', 0, 0, 0, 0, 1, 1, 0, 2, 2026, 3, '2026-03-09 06:47:26', '2026-03-30 06:53:01', '홈피문의', '0.0', 'ricoco'),
('FsRJNyq_1oMR0lgGOOtfq', 1020001, '내부채널', 11, 20, 1, 2, 1, 1, 0, 5, 2026, 3, '2026-03-09 06:47:25', '2026-03-30 06:53:01', '채널톡', '25.0', 'ricoco'),
('Gvq3YhbUbVBA-m9gz8_fw', 1080001, '외부채널', 0, 0, 0, 1, 0, 0, 0, 1, 2026, 2, '2026-02-12 11:09:21', '2026-02-23 06:32:19', '베이비페어', '0.0', 'ricoco'),
('hH4VAX_OE3hobeA7c-Q91', 1020001, '외부채널', 27, 30, 9, 6, 8, 5, 0, 28, 2026, 3, '2026-03-09 06:45:41', '2026-03-30 06:50:14', '유아매장', '93.3', 'bombom'),
('hNTd1gz7VWkRNKPxSrOAM', 1080001, '내부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:17', '2026-02-12 11:03:17', '채널톡', '0.0', 'ricoco'),
('ITUwFnQolQTIVj0rrbAce', 1, '외부채널', 42, 45, 2, 1, 1, 35, 0, 39, 2026, 2, '2026-02-03 06:59:40', '2026-03-03 07:41:22', '지사자체상담', '86.7', 'bombom'),
('iTWP1FJpSSm14ipypnxre', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:19', '2026-02-12 11:03:19', '지사자체상담', '0.0', 'ricoco'),
('jhjScP_Jhlwn_JgMpsd2X', 1080001, '내부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 2, '2026-02-12 11:09:20', '2026-02-12 11:09:20', '샘플신청', '0.0', 'ricoco'),
('Jr1dAUamZipVxVSkdqeQk', 1, '내부채널', 30, 25, 11, 8, 4, 7, 0, 30, 2026, 2, '2026-02-03 06:57:48', '2026-03-03 07:41:19', '채널톡', '120.0', 'bombom'),
('krlbFazIQBxPNsdrpuLvK', 1, '내부채널', 27, 30, 18, 8, 9, 9, 0, 44, 2026, 1, '2026-01-26 19:20:18', '2026-02-03 06:57:00', '홈피문의', '146.7', 'bombom'),
('LxKwHILsOhGtbGY3X1zb2', 1, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-01-26 19:20:26', '2026-01-26 19:20:26', '입주박람회', '0.0', 'bombom'),
('M7IpQHXy2YyCFehqNhVl0', 1020001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 3, '2026-03-09 06:47:26', '2026-03-09 06:47:26', '베이비페어', '0.0', 'ricoco'),
('MPcMa0WgVJpK-gJPPd7AI', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 2, '2026-02-12 11:09:22', '2026-02-12 11:09:22', '유아매장', '0.0', 'ricoco'),
('nAMIaXIrqs69XExpS-Ter', 1080001, '외부채널', 0, 0, 2, 1, 0, 2, 0, 5, 2026, 2, '2026-02-12 11:09:20', '2026-03-03 07:42:51', '라이브커머스', '0.0', 'ricoco'),
('nJRyke5EYbfPAr-93RImB', 1020001, '외부채널', 1, 0, 0, 0, 0, 0, 0, 0, 2026, 3, '2026-03-09 06:45:42', '2026-03-09 06:45:42', '입주박람회', '0.0', 'bombom'),
('NUmQRWYDeNFLbXyrugbLY', 1080001, '내부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:17', '2026-02-12 11:03:17', '홈피문의', '0.0', 'ricoco'),
('p1mMGLFy4yXBCqy_HvwBl', 1, '내부채널', 23, 20, 6, 5, 2, 4, 0, 17, 2026, 2, '2026-02-03 06:57:48', '2026-03-03 07:41:19', '상담전화', '85.0', 'bombom'),
('pfkQoAJrNrAItljTr3Pb9', 1020001, '외부채널', 2, 5, 0, 0, 1, 0, 0, 1, 2026, 3, '2026-03-09 06:47:26', '2026-03-23 04:41:27', '라이브커머스', '20.0', 'ricoco'),
('pfO8gCg6NQDgG5I4N-UnZ', 1020001, '외부채널', 22, 50, 2, 0, 56, 48, 0, 106, 2026, 3, '2026-03-09 06:45:41', '2026-03-30 06:50:14', '인플루언서공구', '212.0', 'bombom'),
('rHnPrwsNYCGw9l9Z9ysXp', 1, '내부채널', 35, 45, 11, 6, 8, 5, 0, 30, 2026, 1, '2026-01-26 19:20:17', '2026-02-03 06:57:00', '채널톡', '66.7', 'bombom'),
('rl6YeyVcCR4cgq4WrOjpW', 1, '외부채널', 33, 40, 7, 4, 5, 1, 0, 17, 2026, 1, '2026-01-26 19:20:23', '2026-02-03 06:57:02', '유아매장', '42.5', 'bombom'),
('sEtKFGFy2PJEHDVRaoI-V', 1080001, '내부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:16', '2026-02-12 11:03:16', '샘플신청', '0.0', 'ricoco'),
('suGjr7iYetFG6L-dGcWhE', 1, '외부채널', 52, 25, 4, 0, 1, 38, 0, 43, 2026, 1, '2026-01-26 19:20:19', '2026-02-03 06:57:01', '라이브커머스', '172.0', 'bombom'),
('sWfQLAYksvyGZeXp1Fvnq', 1020001, '외부채널', 2, 5, 1, 0, 0, 0, 0, 1, 2026, 3, '2026-03-09 06:47:27', '2026-03-16 08:54:02', '유아매장', '20.0', 'ricoco'),
('Tc8yjavNVQQup2fW7jqHM', 1, '내부채널', 0, 0, 0, 1, 0, 0, 0, 1, 2026, 2, '2026-02-03 06:57:48', '2026-02-19 09:26:20', '샘플신청', '0.0', 'bombom'),
('TdJAxGTlhoJwUfdNcG1QL', 1, '외부채널', 7, 10, 0, 1, 0, 2, 0, 3, 2026, 2, '2026-02-03 06:59:39', '2026-03-03 07:41:21', '시공팀', '30.0', 'bombom'),
('TnH7nqZvi2Bqnphtq70_1', 1020001, '외부채널', 18, 30, 0, 24, 2, 17, 0, 43, 2026, 3, '2026-03-09 06:45:40', '2026-03-30 06:50:13', '라이브커머스', '143.3', 'bombom'),
('tUdLflz9dEToD5Tmb0KUJ', 1080001, '내부채널', 0, 0, 0, 1, 2, 2, 0, 5, 2026, 2, '2026-02-12 11:09:20', '2026-03-03 07:42:50', '채널톡', '0.0', 'ricoco'),
('u7nW8R524vEZW9g17kPTJ', 1020001, '내부채널', 29, 40, 7, 6, 3, 8, 0, 24, 2026, 3, '2026-03-09 06:44:51', '2026-03-30 06:50:13', '홈피문의', '60.0', 'bombom'),
('ulgknPNPsBrqXaKh4MLLW', 1020001, '내부채널', 3, 5, 0, 1, 0, 0, 0, 1, 2026, 3, '2026-03-09 06:47:25', '2026-03-16 08:54:19', '상담전화', '20.0', 'ricoco'),
('UlTLzrAfQpZ4-iXoofTav', 1020001, '외부채널', 3, 40, 0, 11, 50, 8, 0, 69, 2026, 3, '2026-03-09 06:45:40', '2026-03-30 06:50:13', '베이비페어', '172.5', 'bombom'),
('V3yR96LmPo4sLqoVHbz8N', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 2, '2026-02-12 11:09:22', '2026-02-12 11:09:22', '인플루언서공구', '0.0', 'ricoco'),
('vuRMXMz-chK47Wgnj-R1t', 1020001, '내부채널', 17, 20, 3, 3, 3, 6, 0, 15, 2026, 3, '2026-03-09 06:44:50', '2026-03-30 06:50:12', '상담전화', '75.0', 'bombom'),
('Wg-PhflWmR97tr7ouG1q9', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:18', '2026-02-12 11:03:18', '베이비페어', '0.0', 'ricoco'),
('Xj0UZ97Wgzkf5WvEKR71p', 1020001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 3, '2026-03-09 06:47:27', '2026-03-09 06:47:27', '시공팀', '0.0', 'ricoco'),
('xvefUAeaE6O_IuZk1jAGn', 1, '내부채널', 44, 40, 5, 7, 6, 11, 0, 29, 2026, 2, '2026-02-03 06:57:49', '2026-03-03 07:41:20', '홈피문의', '72.5', 'bombom'),
('Y3AVUFsUO14PopcJpHjzP', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 2, '2026-02-12 11:09:21', '2026-02-12 11:09:21', '시공팀', '0.0', 'ricoco'),
('Yd5te3OEBB24ClaiGVU2i', 1020001, '내부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 3, '2026-03-09 06:47:25', '2026-03-09 06:47:25', '샘플신청', '0.0', 'ricoco'),
('yr86jcCAmXSM-KR8jxdJx', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 2, '2026-02-12 11:09:23', '2026-02-12 11:09:23', '지사자체상담', '0.0', 'ricoco'),
('Yv7zG9-tvTRV0wZltn6Hg', 1, '내부채널', 21, 30, 6, 4, 6, 7, 0, 23, 2026, 1, '2026-01-26 19:20:14', '2026-02-03 06:56:59', '상담전화', '76.7', 'bombom'),
('za-atLEL5Nr946ugsNzar', 1020001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 3, '2026-03-09 06:47:28', '2026-03-09 06:47:28', '입주박람회', '0.0', 'ricoco'),
('zFOalUCf5ScLFoFDtUyeQ', 1080001, '외부채널', 0, 0, 0, 0, 0, 0, 0, 0, 2026, 1, '2026-02-12 11:03:19', '2026-02-12 11:03:19', '인플루언서공구', '0.0', 'ricoco');

-- Table: contract_sub_channels (0 rows)

-- Table: divisions (3 rows)
INSERT INTO `divisions` (`id`, `name`, `description`, `isActive`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
(1, '매트사업부', '시공매트사업부', 1, 1, '2026-01-26 17:49:31', '2026-01-26 17:49:31'),
(2, '제조사업부', 'TPU매트 제조사업', 1, 2, '2026-01-26 17:49:59', '2026-01-26 17:49:59'),
(30001, '임원', '', 1, 0, '2026-01-27 08:44:26', '2026-01-27 08:44:26');

-- Table: financial_balances (3 rows)
INSERT INTO `financial_balances` (`id`, `year`, `month`, `openingBalance`, `createdAt`, `updatedAt`) VALUES
('92ab1e37-5f2d-4b31-a0f8-6913439ad241', 2026, 3, 107486809, '2026-03-09 05:13:43', '2026-03-09 06:59:28'),
('9ca1489e-e8b2-4a6b-86b4-00de137cfe0e', 2026, 2, 208769087, '2026-03-09 05:13:43', '2026-03-09 06:59:17'),
('f798254a-1c35-11f1-849e-ba1dffd93246', 2026, 1, 312322075, '2026-03-10 08:02:33', '2026-03-10 08:02:33');

-- Table: financial_records (129 rows)
INSERT INTO `financial_records` (`id`, `year`, `month`, `week`, `category`, `type`, `amount`, `description`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
('023f7c6c-ba66-4c61-b373-326559265081', 2026, 1, 5, '기업018-법인비용', 'income', 10281918, '쿠팡페이주식회', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('052f683c-e15d-40ff-9202-9ec4c29de119', 2026, 3, 2, '기업040-시공비결재', 'income', 101840, '백동관', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('087a1260-04e5-4dae-919a-f4b5432e7db4', 2026, 1, 2, '지사매출-우리', 'expense', 50900, '코웨이렌탈01', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('0923bbd5-f70e-435f-88ea-2f6907e6f8f6', 2026, 2, 4, '기업040-시공비결재', 'income', 185560, NULL, 34, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('09cc37e6-bc71-4414-b710-6f7d0268eb52', 2026, 1, 2, '기업032-급여', 'income', 44000, '신도리코/오류입금반', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('0aafcb78-8cee-406e-8e74-c4463ae8da2a', 2026, 2, 4, '기업012-매장거래', 'income', 124594004, NULL, 28, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('0ee29c00-7d61-4c2d-88b7-8c82e590bba1', 2026, 1, 2, '기업018-법인비용', 'expense', 4500, 'SMS통지수수료', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('0fb82340-644a-4b2e-9c76-79f53598b1d4', 2026, 1, 3, '지사매출-우리', 'expense', 88000, '01224778338SKT', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('108f7f88-e5e3-4925-b15c-09b63f1665b7', 2026, 3, 4, '기업018-법인비용', 'income', 4278504, '쿠팡페이주식회', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('132b8ec4-2012-481a-80db-8589ea8af964', 2026, 1, 1, '비용계좌-우리', 'expense', 54777528, '하이패스0744', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('15365498-b3d8-4b83-be0a-46bc54bbadff', 2026, 2, 2, '기업018-법인비용', 'income', 47400, '빌리지베이비', 0, '2026-03-10 09:16:32', '2026-03-10 09:16:32'),
('1711dac7-8792-4637-ba10-094f429050fb', 2026, 2, 4, '지사매출-우리', 'income', 104910511, NULL, 40, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('1a182ff6-f69b-4912-8e9e-4a4e55ddf79c', 2026, 1, 3, '기업018-법인비용', 'expense', 44000, '이카운트월수수료', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('1b2ce306-5d68-4c89-b7b8-5bc1b79bccd3', 2026, 3, 3, '비용계좌-우리', 'expense', 203114165, '현대카드', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('1c7e5963-f122-450b-9764-25a43bcf3cdf', 2026, 2, 2, '기업032-급여', 'expense', 781238, '이자-32-00052 다음납입예정일-20260410', 0, '2026-03-10 09:16:32', '2026-03-10 09:16:32'),
('1de7fead-fc4f-4e2c-9d7f-a1cfd140e25f', 2026, 1, 2, '기업012-매장거래', 'income', 39639671, '오늘의집정산', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('1e705edc-5cb3-4fd0-80cb-84a202fd4708', 2026, 1, 3, '기업029_환기매출', 'income', 24084500, '(주)크림하우스', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('1fd468eb-976a-4402-b71b-8a83d5643318', 2026, 2, 2, '기업018-법인비용', 'expense', 4500, 'SMS통지수수료', 0, '2026-03-10 09:16:32', '2026-03-10 09:16:32'),
('226fb799-7dee-47db-8ca2-18104b1dcf91', 2026, 2, 3, '기업018-법인비용', 'expense', 10949929, NULL, 22, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('26462501-8f9b-4b77-9fa3-f259224a7524', 2026, 1, 1, '매트개인-우리', 'income', 39510000, '오단비', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('29a98179-f8ad-46d1-a199-5cf2111f698c', 2026, 2, 3, '기업018-법인비용', 'income', 577, NULL, 21, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('2a7261ce-8ec6-49bd-8a92-6bfb0af8a62d', 2026, 3, 4, '기업012-매장거래', 'income', 60132049, '오늘의집정산', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('2ac997ad-8011-48e9-b979-4036dc4b616e', 2026, 3, 2, '기업012-매장거래', 'income', 85208843, '스마트스토어정', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('2dab3dc0-4843-4020-9c51-c3ea5807ae5e', 2026, 3, 3, '기업040-시공비결재', 'income', 1297600, '최소라', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('30499e2b-ebcb-4318-9764-949ba5ab28a3', 2026, 3, 1, '기업018-법인비용', 'expense', 4400, '공동인증수수료', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('337af915-aab7-421f-8524-c309da63c420', 2026, 1, 1, '비용계좌-우리', 'income', 4872870, '오류분재입금', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('33cbc832-348c-4990-9386-04ad8d190b60', 2026, 1, 2, '기업018-법인비용', 'income', 624027, '쿠팡페이주식회', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('3606af2b-7fab-431a-ae90-e0ca9cfe5207', 2026, 1, 1, '기업032-급여', 'expense', 621028, '삼성화01035', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('377b96c3-e1dc-43ac-942d-0d3cd20a290b', 2026, 2, 1, '비용계좌-우리', 'income', 1296540, NULL, 6, '2026-03-09 06:56:17', '2026-03-09 06:56:17'),
('38052204-2d04-4995-a726-efc272f96966', 2026, 1, 4, '매트개인-우리', 'income', 43748820, '원지현', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('38516fa1-ae40-4705-a530-c7b79535e68c', 2026, 3, 2, '기업032-급여', 'expense', 782238, '이자-32-00052 다음납입예정일-20260410', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('407fc236-66f8-49a5-b5c4-3ed74e7b97b3', 2026, 3, 1, '우리-외화계좌', 'income', 18168500, 'BLACKCORP PTE. LTD.', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('430bd299-b939-44d2-8536-b1164ebdcc69', 2026, 1, 5, '기업012-매장거래', 'income', 33297260, '스마트스토어정', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('4624e9a0-2a8c-4856-8306-6aeb0f435528', 2026, 1, 3, '지사매출-우리', 'income', 120812048, '스마트스토어정산', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('46fff762-b223-458c-a6e4-9a8fd60cf75e', 2026, 3, 1, '기업040-시공비결재', 'income', 34000, '이동권', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('4746d560-8163-4d77-8aa8-e7060f81d088', 2026, 2, 4, '지사매출-우리', 'expense', 88000, NULL, 41, '2026-03-09 06:57:58', '2026-03-09 06:57:58'),
('47b0b37b-3ee5-4ba1-be55-58bfce56c79b', 2026, 3, 4, '기업018-법인비용', 'expense', 15240, 'LGU+대표번호', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('47ce9fa7-9d36-433c-a379-66bb2f25e198', 2026, 2, 4, '기업018-법인비용', 'expense', 15240, NULL, 31, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('482d83b8-842b-4d49-b006-69967f600f3b', 2026, 2, 1, '기업012-매장거래', 'income', 158477767, NULL, 1, '2026-03-09 06:56:17', '2026-03-09 06:56:17'),
('482e0b80-1aa0-4ba1-809b-6a1bcfb65283', 2026, 3, 4, '비용계좌-우리', 'income', 64258945, '옥토아이앤씨', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('487e8f2d-8a13-4aa6-bec6-d60c145ddfcf', 2026, 1, 3, '비용계좌-우리', 'income', 5159770, '예금결산이자', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('4a2a022c-915e-42d1-a3be-ba08ae5423e9', 2026, 3, 4, '지사매출-우리', 'income', 117618831, 'tosspayments', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('4b4dea65-76e4-4c19-98de-870518254d5c', 2026, 1, 4, '기업018-법인비용', 'expense', 15240, 'LGU+대표번호', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('4e951a30-ea36-4a7f-84e7-14886999a901', 2026, 2, 4, '기업032-급여', 'expense', 11897779, NULL, 33, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('50a6ce41-504e-4417-b760-97dcadc4a201', 2026, 3, 2, '우리-외화계좌', 'expense', 6920, 'FDT12026001130', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('5134461b-93d3-4e48-bfc3-e69c5a99334f', 2026, 3, 3, '기업012-매장거래', 'income', 88934648, '오늘의집정산', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('522f669b-ad51-4a63-915c-87f4a113dc85', 2026, 2, 2, '지사매출-우리', 'income', 17845827, 'tosspayments', 0, '2026-03-10 09:16:32', '2026-03-10 09:16:32'),
('52ffef67-fbde-4de4-ae01-bf5a38faa813', 2026, 2, 3, '비용계좌-우리', 'income', 17503774, NULL, 25, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('55ca9ce5-e179-420a-8315-085f6592db89', 2026, 1, 3, '기업040-시공비결재', 'income', 80000, '조준성', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('57a9d45b-c090-472d-b230-17a1d5ee7fd2', 2026, 1, 2, '기업040-시공비결재', 'income', 524720, '강은주', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('5b4f2e27-6d07-4de0-9ab8-729a2b732d8f', 2026, 3, 2, '기업018-법인비용', 'income', 2560096, '쿠팡페이주식회', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('5de56d93-2334-44aa-8db6-34b388adbbf3', 2026, 3, 3, '기업032-급여', 'expense', 540260, 'SK렌터카0', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('5e0d7de7-2cdf-4165-acfb-6565a3b518c5', 2026, 3, 1, '기업012-매장거래', 'income', 73160890, '스마트스토어정', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('609d7060-9fb6-4157-b5d4-6321effdea48', 2026, 1, 2, '우리-외화계좌', 'expense', 9440, 'FDT12026000142', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('6125b9c1-91bc-44cb-b85d-a424d9a13e12', 2026, 3, 3, '기업018-법인비용', 'expense', 44000, '이카운트월수수료', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('61bebd52-401b-4009-acb6-e819bf86b309', 2026, 1, 3, '매트개인-우리', 'income', 27707100, '이효진', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('65f42072-ca36-4814-be2d-e0c2c02a25f2', 2026, 3, 3, '매트개인-우리', 'income', 40658445, '박상미', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('67478095-5cac-4b6c-b6c8-5582ce297055', 2026, 3, 4, '매트개인-우리', 'income', 56566000, '김재홍', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('674fe2fe-1755-4eaa-9998-c9e1ade376f3', 2026, 2, 1, '지사매출-우리', 'income', 111836200, NULL, 8, '2026-03-09 06:56:17', '2026-03-09 06:56:17'),
('6cbb0eb3-ac74-4319-a80c-8a384c33c8c4', 2026, 1, 4, '지사매출-우리', 'income', 104263791, '스마트스토어정산', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('6d9cb825-090f-44f7-8c02-bdb7fa7f224a', 2026, 1, 4, '비용계좌-우리', 'expense', 281565853, 'FDT12026000281', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('6db5b1f6-5266-43ba-9fc9-34755e28ae8c', 2026, 3, 4, '기업032-급여', 'expense', 8713539, 'LGU+기업전화', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('79534291-6cba-4c22-baa5-b62a16106f64', 2026, 1, 2, '기업032-급여', 'expense', 990065, '신도리코임대', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('7eddfe1d-f77c-4c21-8993-5074e8f9e7d9', 2026, 3, 4, '매트개인-우리', 'expense', 64258945, '옥토아이앤씨', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('80f5f81f-7aed-4acf-a4be-0bfa0f9927fc', 2026, 3, 2, '지사매출-우리', 'expense', 52900, '코웨이렌탈03', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('8431ba32-2464-44bf-912a-8732fa784305', 2026, 1, 1, '기업012-매장거래', 'income', 73606984, '오늘의집정산', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('889a83b6-5c90-4e92-9eed-491322860f5b', 2026, 1, 2, '비용계좌-우리', 'income', 479200, '현대해상화재', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('8933010a-b24d-4919-ba57-ea296228ff09', 2026, 3, 1, '매트개인-우리', 'income', 39383000, '김성훈', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('896e7634-f2ca-47ad-bbfe-68a1a8018bbf', 2026, 1, 5, '매트개인-우리', 'income', 15428500, '황지은', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('8ae4d921-aa49-4c85-b0bf-37d86e3edb40', 2026, 2, 3, '비용계좌-우리', 'expense', 158479503, NULL, 26, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('8d2a71a2-a492-40c4-aeb0-7761ab12faa2', 2026, 1, 5, '기업032-급여', 'income', 11946300, '(주)지엠알그룹코리아', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('8dd5d755-2423-4a45-8ca1-739638dd4401', 2026, 2, 4, '우리-외화계좌', 'expense', 8500, NULL, 39, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('922e5092-99ab-4543-8386-c43091284936', 2026, 3, 2, '매트개인-우리', 'income', 41282000, '이지혜', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('9259c87f-123c-42c8-8a9d-23d9a40fc5de', 2026, 3, 2, '지사매출-우리', 'income', 130550968, '(주)브레이브', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('92e2597d-90d8-47f3-8d37-d33e00939c93', 2026, 3, 1, '비용계좌-우리', 'expense', 176978061, '하나주식회사 원아워', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('94c86483-8d4f-4e8c-a4cf-6335673645cb', 2026, 2, 2, '기업012-매장거래', 'income', 14361731, '오늘의집정산', 0, '2026-03-10 09:16:32', '2026-03-10 09:16:32'),
('94f0d507-5a96-4977-a4d7-672b2ee35e17', 2026, 3, 2, '기업029_환기매출', 'income', 17237000, '(주)크림하우스', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('95ac686e-4022-40b0-8ad9-31a397509228', 2026, 2, 1, '비용계좌-우리', 'expense', 112510966, NULL, 7, '2026-03-09 06:56:17', '2026-03-09 06:56:17'),
('9aae4166-9cd0-4ace-bef0-5e57eeb90dd9', 2026, 3, 1, '기업018-법인비용', 'income', 95762, '쿠팡페이주식회', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('9f03f555-417e-4700-8be6-c337997dffbc', 2026, 1, 3, '비용계좌-우리', 'expense', 200083254, '하나팩스2601', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('a0bec8f5-c3cb-4f5e-9539-e2dade52cc97', 2026, 3, 2, '기업018-법인비용', 'expense', 4500, 'SMS통지수수료', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('a141acc0-8ce1-4501-b6fc-62f9b09d5e61', 2026, 3, 1, '비용계좌-우리', 'income', 400000000, '주식회사꿈비', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('a16c29f1-585d-4153-b904-653fe374d3db', 2026, 2, 4, '매트개인-우리', 'expense', 5397000, NULL, 36, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('a3520179-e722-4fcd-ad79-2405aa19aded', 2026, 2, 4, '기업032-급여', 'income', 5483440, NULL, 32, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('a493a926-a7da-41fa-bc07-e1cb99bb4d52', 2026, 1, 2, '기업029_환기매출', 'income', 10395000, '홍산호(쥬다르)', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('a57a9020-c4d5-4339-80ae-e875cf57fe2a', 2026, 1, 3, '기업032-급여', 'expense', 592000, 'SK렌터카', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('a78e8aa9-1456-4063-bac0-eee46486501c', 2026, 2, 1, '매트개인-우리', 'income', 45603427, NULL, 5, '2026-03-09 06:56:17', '2026-03-09 06:56:17'),
('a9232c26-58f6-4a46-bcd4-90f516e56663', 2026, 3, 4, '지사매출-우리', 'expense', 88000, '01224778338SKT', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('a9c9e910-5eac-40ce-b1b8-c181a89fd2aa', 2026, 1, 3, '기업018-법인비용', 'income', 283, '2026년결산', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('a9d20db5-e06e-49eb-b3e6-8d79adf0d9d8', 2026, 2, 3, '지사매출-우리', 'income', 62991903, NULL, 27, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('b1a2d1e6-78a1-4ff8-b083-035c0d95a87a', 2026, 1, 3, '기업012-매장거래', 'income', 51674371, '오늘의집정산', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('b1f71877-3c6f-4623-a549-0ec0ab6b3222', 2026, 2, 1, '기업040-시공비결재', 'income', 166000, NULL, 4, '2026-03-09 06:56:17', '2026-03-09 06:56:17'),
('b4f15cc7-4e34-48c7-bc00-ffbda2edfae4', 2026, 2, 4, '매트개인-우리', 'income', 47062500, NULL, 35, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('b8624bcf-4161-4482-a618-99b0d715a993', 2026, 1, 1, '기업040-시공비결재', 'income', 165000, '정영철', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('b994f3a3-097e-4ead-b8e7-ae135c013e2a', 2026, 1, 5, '지사매출-우리', 'income', 57603651, '현대870270681', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('c19c5bc8-88e3-4767-9e0c-baf15b1d2a7c', 2026, 3, 4, '기업040-시공비결재', 'income', 870061, '김유라', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('c1a94d0d-4865-46e2-b57b-bcf22a5d2ba3', 2026, 2, 4, '기업018-법인비용', 'income', 13373069, NULL, 30, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('c2618d0b-9f28-44d7-8e7f-e89e79c5c923', 2026, 2, 3, '기업032-급여', 'expense', 669000, NULL, 23, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('c2c029ad-c2d4-4d69-b368-08a982032726', 2026, 1, 2, '매트개인-우리', 'income', 31740800, '채예솔', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('c3d0d8f0-0f35-4576-8adb-0448b087b771', 2026, 2, 3, '기업012-매장거래', 'income', 6897849, NULL, 20, '2026-03-09 06:56:17', '2026-03-09 06:56:17');
INSERT INTO `financial_records` (`id`, `year`, `month`, `week`, `category`, `type`, `amount`, `description`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
('c6afe74b-61c2-42ba-b3d2-a4c4d0d622e1', 2026, 1, 5, '비용계좌-우리', 'income', 3410000, '주식회사꿈비', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('c866ef7b-4697-4266-8ee4-b6270052f5e7', 2026, 2, 2, '비용계좌-우리', 'expense', 157075552, 'SMS수수료', 0, '2026-03-10 09:16:32', '2026-03-10 09:16:32'),
('c9fb7962-41a3-4098-a94c-3bd3b0d876a8', 2026, 1, 2, '비용계좌-우리', 'expense', 279663595, 'SMS수수료', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('caffe382-d2a9-4caf-9b45-4a9ec981b0c4', 2026, 2, 3, '매트개인-우리', 'income', 15789000, NULL, 24, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('d05766f6-a9b1-47db-8b28-e9c5f477d6c9', 2026, 3, 4, '기업032-급여', 'income', 3326, '2026년결산', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('d07850f2-a7ab-4953-80f8-75a08c948af0', 2026, 2, 1, '기업032-급여', 'expense', 621028, NULL, 3, '2026-03-09 06:56:17', '2026-03-09 06:56:17'),
('d7d66c3a-11fa-4385-90d8-30ce53143546', 2026, 1, 4, '기업032-급여', 'expense', 15326236, 'LGU+기업전화', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('d878541b-f0f3-426d-93c9-4c3435f44627', 2026, 2, 4, '비용계좌-우리', 'expense', 415908709, NULL, 38, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('d9b17c47-de40-41d7-9961-eab84273fb16', 2026, 3, 3, '기업032-급여', 'income', 5290319, '(주)지엠알그룹코리아', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('db840b6d-2769-435f-892f-73d899dd6134', 2026, 3, 2, '비용계좌-우리', 'expense', 318167691, '카카임해진', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('db9b6413-a0f1-4fbd-afb0-6a9930142973', 2026, 2, 2, '기업029_환기매출', 'income', 4950000, '홍산호(쥬다르)', 0, '2026-03-10 09:16:32', '2026-03-10 09:16:32'),
('dde1e1d9-4996-4187-b4f6-322d586c1996', 2026, 3, 1, '기업032-급여', 'expense', 621028, '삼성화03037', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('de56e7c9-9b62-43d2-a327-0db16102ac5f', 2026, 3, 1, '지사매출-우리', 'income', 150767082, '진성태(봄봄매트충정', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('e05ba6e6-b9e1-4c70-be73-fcbf9c41c672', 2026, 3, 3, '비용계좌-우리', 'income', 42995806, '예금결산이자', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('e0e05cb8-44bb-4f01-b9b5-4e3bddebbe36', 2026, 1, 4, '우리-외화계좌', 'expense', 7450, 'FDT12026000281', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('e5123060-4dbe-49b6-9862-5f7ea10ddc55', 2026, 3, 5, '매트개인-우리', 'income', 4070000, '강해정', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('e5e543c8-d9e0-4173-a87d-746d7936ded7', 2026, 3, 3, '지사매출-우리', 'income', 90797133, '예금결산이자', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('e7ea50c3-df87-4f3b-982c-039e423d504c', 2026, 1, 4, '기업012-매장거래', 'income', 104825170, '오늘의집정산', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('ec556bf5-deae-4982-857b-9528bbb2df06', 2026, 2, 1, '기업018-법인비용', 'income', 465348, NULL, 2, '2026-03-09 06:56:17', '2026-03-09 06:56:17'),
('ed2d7058-e7b8-4eba-81d9-a5b905cd0840', 2026, 3, 4, '비용계좌-우리', 'expense', 317827489, '중진공대출원리금', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('f181d4d2-118e-4ef5-a4aa-5e5eab51cd21', 2026, 1, 4, '우리-외화계좌', 'income', 1950, 'INFO PLAY ONKORNESIA', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('f21ad376-ca60-4f7b-94cc-52d3d984b22a', 2026, 2, 4, '기업012-매장거래', 'expense', 3608401, NULL, 29, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('f427b7fe-79f5-4d49-8031-274cfd128763', 2026, 3, 3, '기업018-법인비용', 'income', 299447, '쿠팡페이주식회', 0, '2026-03-30 04:17:05', '2026-03-30 04:17:05'),
('f7375553-7786-4685-b4d6-61db8865d62e', 2026, 1, 1, '기업018-법인비용', 'income', 16272, '쿠팡페이주식회', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('f7d8ffcd-6c46-4fdd-b2ad-5a99d0e423c8', 2026, 1, 2, '지사매출-우리', 'income', 120366110, 'tosspayments', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('fad31a41-d004-4109-97d2-1ec0de94dd4e', 2026, 1, 5, '비용계좌-우리', 'expense', 293748950, '신한정영철', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('fae34ff2-b424-4bc5-86b1-8ca95d6bba57', 2026, 1, 1, '지사매출-우리', 'income', 86618469, '신한0107248809', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57'),
('fced16ae-2839-452f-874e-688138e08349', 2026, 2, 4, '비용계좌-우리', 'income', 5397000, NULL, 37, '2026-03-09 06:57:29', '2026-03-09 06:57:29'),
('fffd1b5d-b3d3-4565-a64f-2607312a7bb8', 2026, 1, 4, '기업018-법인비용', 'income', 1106496, '(주)트라이씨클', 0, '2026-03-10 07:59:57', '2026-03-10 07:59:57');

-- Table: goals (0 rows)

-- Table: kpi_assignees (0 rows)

-- Table: kpi_indicators (55 rows)
INSERT INTO `kpi_indicators` (`id`, `kpiItemId`, `name`, `unit`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
(1, 2, '이벤트 노출수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(2, 2, '참여자수', '', 1, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(3, 2, '참여건당 비용', '', 2, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(4, 3, '상품건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(5, 3, '매출액', '', 1, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(6, 4, '진행건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(7, 5, '월간 홈페이지 방문자수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(8, 6, '월간 블로그 방문자수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(9, 7, '월간 프로필 방문자수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(10, 8, '월간 영상조회수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(11, 9, '노출당비용', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(12, 9, '클릭당비용', '', 1, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(13, 10, '노출당비용', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(14, 10, '클릭당비용', '', 1, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(15, 11, '게시글 수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(16, 11, '이벤트 참여수', '', 1, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(17, 12, '후기 건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(18, 13, '월간계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 14:34:23'),
(19, 13, '월간계약장수', '', 1, '2026-03-16 08:30:31', '2026-03-16 15:33:19'),
(20, 14, '월간계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 14:34:23'),
(21, 14, '월간계약장수', '', 1, '2026-03-16 08:30:31', '2026-03-16 15:33:19'),
(22, 15, '월간계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 14:34:23'),
(23, 15, '월간계약장수', '', 1, '2026-03-16 08:30:31', '2026-03-16 15:33:19'),
(24, 16, '월간계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 14:34:23'),
(25, 16, '월간계약장수', '', 1, '2026-03-16 08:30:31', '2026-03-16 15:33:19'),
(26, 17, '월간계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 14:34:23'),
(27, 17, '월간계약장수', '', 1, '2026-03-16 08:30:31', '2026-03-16 15:33:19'),
(28, 18, '월간계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 14:34:23'),
(29, 18, '월간계약장수', '', 1, '2026-03-16 08:30:31', '2026-03-16 15:33:19'),
(30, 19, '월간계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 14:34:23'),
(31, 19, '월간계약장수', '', 1, '2026-03-16 08:30:31', '2026-03-16 15:33:19'),
(32, 20, '월간시공 건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 15:29:28'),
(33, 21, '월간계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(34, 21, '월간계약장수', '', 1, '2026-03-16 08:30:31', '2026-03-16 15:33:19'),
(35, 22, '월간시공건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(36, 23, '월간계약장수', '', 0, '2026-03-16 08:30:31', '2026-03-16 15:33:19'),
(37, 24, '계약당 행사비용', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(38, 25, '계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(39, 25, '계약당 비용', '', 1, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(40, 26, '계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(41, 27, '행사당 계약 건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(42, 28, '행사당 계약 장수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(43, 29, '자체계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 15:31:31'),
(44, 30, '월별 매출관리', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(45, 31, '어린이집 매출 실적', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(46, 34, '장당 외주시공비용', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(47, 36, '월간계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 14:34:23'),
(48, 37, '매장별 계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(49, 39, '계약건수', '', 0, '2026-03-16 08:30:31', '2026-03-16 15:30:52'),
(50, 40, '주별 매출현황', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(51, 40, '제품별 매출현황', '', 1, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(52, 42, '거래처별 매출액', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(53, 54, '주간 재고 금액', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(54, 55, '주간 생산실적', '', 0, '2026-03-16 08:30:31', '2026-03-16 08:30:31'),
(30001, 39, '계약장수', '', 0, '2026-03-16 15:31:55', '2026-03-16 15:31:55');

-- Table: kpi_item_details (0 rows)

-- Table: kpi_items (58 rows)
INSERT INTO `kpi_items` (`id`, `division`, `department`, `person`, `category`, `task`, `goal`, `isActive`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
(1, '매트사업부', '마케팅팀', '미정', '컨텐츠기획', '컨텐츠기획', '상품 상세 기술서 기획', 1, 1, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(2, '매트사업부', '마케팅팀', '미정', '컨텐츠기획', '이벤트 관리', '월별 이벤트 운영', 1, 2, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(3, '매트사업부', '마케팅팀', '미정', '컨텐츠기획', '제품 및 서비스 컨셉 기획', '시공 및 시판제품 연결상품 기획', 1, 3, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(4, '매트사업부', '마케팅팀', '미정', '컨텐츠기획', '인플루언서, 협찬 관리', '메가 인플루언서 시공후기 유치', 1, 4, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(5, '매트사업부', '마케팅팀', '미정', '컨텐츠기획', '홈페이지', '채널활성화', 1, 5, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(6, '매트사업부', '마케팅팀', '미정', '컨텐츠기획', '블로그', '채널활성화', 1, 6, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(7, '매트사업부', '마케팅팀', '미정', '컨텐츠기획', '인스타그램', '채널활성화', 1, 7, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(8, '매트사업부', '마케팅팀', '미정', '컨텐츠기획', '유튜브', '채널활성화', 1, 8, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(9, '매트사업부', '마케팅팀', '미정', '퍼포먼스', '네이버광고 관리', 'ROI 최적화', 1, 9, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(10, '매트사업부', '마케팅팀', '미정', '퍼포먼스', '구글광고 관리', 'ROI 최적화', 1, 10, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(11, '매트사업부', '마케팅팀', '미정', '바이럴', '서포터즈 운영', '브랜드 인지도 향상', 1, 11, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(12, '매트사업부', '마케팅팀', '미정', '바이럴', '시공후기 관리', '브랜드 인지도 향상 및 지인소개', 1, 12, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(13, '매트사업부', '고객영업팀', '김소영', '봄봄 고객영업', '전화상담', '전화상담계약 건수 상승', 1, 13, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(14, '매트사업부', '고객영업팀', '김소영', '봄봄 고객영업', '샘플신청', '구매고객 계약전환', 1, 14, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(15, '매트사업부', '고객영업팀', '김소영', '봄봄 고객영업', '채널톡', '유입 고객 계약 전환', 1, 15, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(16, '매트사업부', '고객영업팀', '이정은', '봄봄 고객영업', '홈피문의', '유입 고객 계약 전환', 1, 16, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(17, '매트사업부', '고객영업팀', '미정', '봄봄 고객영업', '방문견적', '요청고객 계약 전환', 0, 17, '2026-03-16 08:29:49', '2026-03-16 17:28:47'),
(18, '매트사업부', '고객영업팀', '김경원', '꿈비 고객영업', '전화상담', '전화상담계약 건수 상승', 1, 18, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(19, '매트사업부', '고객영업팀', '김경원', '꿈비 고객영업', '채널톡', '유입 고객 계약 전환', 1, 19, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(20, '매트사업부', '고객영업팀', '이주홍', '꿈비 고객영업', '시공예약관리', '시공일정 최적화', 1, 20, '2026-03-16 08:29:49', '2026-03-16 17:03:41'),
(21, '매트사업부', '고객영업팀', '미정', '꿈비 고객영업', '방문견적', '요청고객 계약 전환', 0, 21, '2026-03-16 08:29:49', '2026-03-16 17:28:22'),
(22, '매트사업부', '고객영업팀', '이주홍', '시공관리', '시공일정 관리', '', 1, 22, '2026-03-16 08:29:49', '2026-03-16 17:04:10'),
(23, '매트사업부', '고객영업팀', '이주홍', '시공관리', '시공결과 입력', '', 1, 23, '2026-03-16 08:29:49', '2026-03-16 17:11:34'),
(24, '매트사업부', '채널영업팀', '신나라', '유아박람회', '행사진행업무', '행정업무 및 인원배치', 1, 24, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(25, '매트사업부', '채널영업팀', '신나라', '유아박람회', '실적관리', '견적 및 계약실적 관리', 1, 25, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(26, '매트사업부', '채널영업팀', '조희태', '공동구매', '인플루언서 시공 공구', '이벤트 효율 관리', 1, 26, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(27, '매트사업부', '채널영업팀', '신나라', '라이브쇼핑', '일정관리', '이벤트 효율 관리', 1, 27, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(28, '매트사업부', '채널영업팀', '신나라', '라이브쇼핑', '실적관리', '이벤트 효율 관리', 1, 28, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(29, '매트사업부', '채널영업팀', '조희태', '지사관리', '지사운영', '지사의 영업력 향상', 1, 29, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(30, '매트사업부', '채널영업팀', '조희태', '지사관리', '매출 입력 및 관리', '안정적 매출 상승', 1, 30, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(31, '매트사업부', '채널영업팀', '조희태', '어린이집', '견적서제출', '', 1, 31, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(32, '매트사업부', '채널영업팀', '조희태', '어린이집', '매출관리', '', 1, 32, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(33, '매트사업부', '채널영업팀', '신나라', '시공외주관리', '남부물류 재고관리', '', 1, 33, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(34, '매트사업부', '채널영업팀', '신나라', '시공외주관리', '시공실적입력 및 정산', '', 1, 34, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(35, '매트사업부', '채널영업팀', '신나라', '시공외주관리', '발주관리', '', 1, 35, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(36, '매트사업부', '채널영업팀', '조희태', '유아매장', '매장영업', '', 1, 36, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(37, '매트사업부', '채널영업팀', '조희태', '유아매장', '매출관리', '', 1, 37, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(38, '매트사업부', '채널영업팀', '서범주', '온라인', '주문 및 배송관리', '', 1, 38, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(39, '매트사업부', '채널영업팀', '서범주', '온라인', '인플루언서 온라인 공구', '', 1, 39, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(40, '매트사업부', '채널영업팀', '서범주', '온라인', '매출입력', '', 1, 40, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(41, '매트사업부', '채널영업팀', '지윤선', '온라인', '고객문의관리', '', 1, 41, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(42, '매트사업부', '채널영업팀', '신나라', 'OEM공급', '매출입력', '', 1, 42, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(43, '매트사업부', '채널영업팀', '신나라', 'OEM공급', '정산관리', '', 1, 43, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(44, '매트사업부', '관리팀', '신나라', '경리업무', '소모품구매', '', 1, 44, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(45, '매트사업부', '관리팀', '신나라', '경리업무', '지출 및 집행결의', '', 1, 45, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(46, '매트사업부', '관리팀', '신나라', '인사관리', '입퇴사관리', '', 1, 46, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(47, '매트사업부', '관리팀', '신나라', '인사관리', '급여정산', '', 1, 47, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(48, '매트사업부', '관리팀', '신나라', '인사관리', '근태관리', '', 1, 48, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(49, '제조사업부', '생산팀', '박영선', '현장관리', '자재관리', '', 1, 49, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(50, '제조사업부', '생산팀', '박영선', '현장관리', '인력운영', '', 1, 50, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(51, '제조사업부', '생산팀', '박영선', '현장관리', '장비관리', '', 1, 51, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(52, '제조사업부', '생산팀', '정시영', '생산관리', '외국인 근로자 관리', '', 1, 52, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(53, '제조사업부', '생산팀', '정시영', '생산관리', '자재발주', '', 1, 53, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(54, '제조사업부', '생산팀', '정시영', '생산관리', '재고관리', '', 1, 54, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(55, '제조사업부', '생산팀', '정시영', '생산관리', '생산실적관리', '', 1, 55, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(56, '제조사업부', '생산팀', '정시영', '생산관리', '생산일정 관리', '', 1, 56, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(57, '제조사업부', '구매', '미정', '구매관리', '발주관리', '', 1, 57, '2026-03-16 08:29:49', '2026-03-16 08:29:49'),
(58, '제조사업부', '구매', '미정', '구매관리', '입출고 관리', '', 1, 58, '2026-03-16 08:29:49', '2026-03-16 08:29:49');

-- Table: kpi_records (1 rows)
INSERT INTO `kpi_records` (`id`, `kpiIndicatorId`, `year`, `month`, `week`, `value`, `createdAt`, `updatedAt`) VALUES
(1, 18, 2026, 3, 3, '-1.00', '2026-03-19 04:41:36', '2026-03-19 04:41:36');

-- Table: kpi_targets (2 rows)
INSERT INTO `kpi_targets` (`id`, `kpiIndicatorId`, `year`, `month`, `monthlyTarget`, `previousActual`, `createdAt`, `updatedAt`) VALUES
(1, 19, 2026, 3, '3.00', '0.00', '2026-03-23 06:04:08', '2026-03-23 06:04:08'),
(30001, 37, 2026, 3, '2.00', '0.00', '2026-03-27 10:00:36', '2026-03-27 10:00:36');

-- Table: meeting_minutes (4 rows)
INSERT INTO `meeting_minutes` (`id`, `userId`, `meetingDate`, `title`, `location`, `attendees`, `content`, `decisions`, `actionItems`, `nextMeetingDate`, `createdAt`, `updatedAt`) VALUES
('fb0u8wwEL05-hV7RpXGiN', 390277, '2026-02-12 05:00:00', '일산 유아림 맘앤베이비엑스포', '링크맘 용인점 3층 회의실', '["박금진 전무","조희태 과장","꿈비 방승혁 팀장"]', '일산 유아림 맘앤베이비엑스포 슈슈비 클립매트 위탁 판매 건\n사전 홍보 건\n현재 슈슈비 인스타 계정은 신규 계정 생성이 필요한 상황으로 홍보효과가 미비할것으로 판단 : 방승혁 팀장\n기존 봄봄매트를 통해 인스타 홍보는 브랜드가 다르기 때문에 불가 : 박금진 전무\n1. 매트 세팅 후 전시장 행사 첫날 조희태 과장 자신 촬영 후 방승혁 팀장에게 전달하여 홍보 진행\n2. 주말에 가기 좋은 장소 등에 광고 홍보 진행 : 방승혁 팀장', '1. 매트 세팅 후 전시장 행사 첫 날 조희태 과장 박람회 부스 촬영 후 방승혁 팀장 전달 > 홍보 진행\n2. 샘플 25일에 물건 수령 후 오후 세팅 진행 : 조희태 과장', NULL, NULL, '2026-02-12 13:02:52', '2026-02-12 13:02:52'),
('IfrBmL0VVqq6P9mr-ThvY', 390277, '2026-02-10 05:00:00', '슈슈비 클립매트 박람회 위탁 판매 건', '링크맘 용인점 3층 회의실', '["박금진 전무, 조희태 과장, 신나라 과장, 링크맘 부천점 김창화 대표"]', '프로젝트명 : 킨텍스 유아림 맘앤베이비엑스포\n\n날짜 : 26년 2월 26일 ~ 3월 1일\n\n장소 : 킨텍스 / 2부스 참가\n\n참가비 : 링크맘 부천점 비용 지급\n※ 테이블 및 단말기 링크맘 부천점에서 지참\n\n백부스 : 링크맘 부천점 선 지급 후 옥토아이앤씨에서 정산 지급\n\n장당 금액 : 21,600원(배송비 무료)\n\n정산 방식 : 총 셀프매트 판매 금액의 수수료 13% 링크맘 부천점 지급\n\n마케팅 홍보 : 옥토아이앤씨 인스타 홍보 진행\n\n박람회 전시용 20장 + 샘플 4장 = 24장 지원\n', '업체 요청사항\n1. 트러스 부스 현수막 이미지 시안 제작 후 업체 전달\n2. 발주서 양식 작성 후 업체 전달\n3. 정산 방식 : 총 셀프매트 판매 금액이 수수료 13% 지급', NULL, NULL, '2026-02-10 13:30:11', '2026-02-11 04:39:33'),
('ot5xnv0tCjdpUtqxvJBKX', 390277, '2026-02-23 05:00:00', '2월 4주차 주간회의', '4층 회의실', '["한용희 상무","박금진 전무","서범주 팀장","이주홍 파트장","조희태 과장","신나라 과장","지윤선 대리"]', '1. 2월 3주차 실적 보고\n3주차 : 8.46억 달성(시공 : 3.66억 / 제조공급 : 0.5억 / 온라인판매 : 3.46억)\n4주차 : 10.41억 달성예정(시공 : 4.6억 / 제조공급 : 0.5억 / 온라인판매 : 4.46억 / 리코코 : 0.85억)\n\n인플루언서 공동구매 : 20건 계약 완료\n> 지지부부 및 이가연님 공동구매 진행 확인 필요 > 조희태 과장\n> 추가 인플루언서 발굴 필요\n\n송채림 대리 퇴사 건 추가 인원 충원서 결재 작성 > 서범주 팀장\n\n2. 피코베리 발주 건 출고\n1) 출고 및 납품 관련 협의 진행 필요 : 서범주 팀장\n2) 현재 필름 보관량이 2가지 색상 타입 각 3,000장씩 보고 추후 각 9,000장씩 생산 되는 필름 물량 입고 예정\n필름 롯트가 달라지면 색상 차이가 나기 때문에 에르모어 발주를 받을 때 물량 나누어서 발주 되도록 협조 요청 > 서범주 팀장\n\n3. 슈슈비 오프라인 판매 행사\n1) 일산 - 킨텍스 유아림 맘앤 엑스포 베이비페어 슈슈비 오프라인 판매 행사 진행 26년 2월 26일 ~ 3월 1일\n\n4. 라이브방송\n1) 2월 26일 라이브방송 진행 > 마곡 원아워 > 신나라 과장, 송채림 대리\n\n5. 리코코 영업계획 활성화\n1) 3월부터 매출 실적이 누적되어 있는 매출 실적이 저조 할 것으로 예상 : 한용희 상무\n2) 한용희 상무 : 영업 계획 철저하게 세워서 진행 > 현재는 라이브방송에만 의존하는 구조를 개선 필요 : 고객 & 채널영업팀 회의\n', NULL, NULL, '2026-03-03 05:00:00', '2026-02-23 13:54:03', '2026-02-23 13:54:37'),
('pSF2_lElhzmMg0rtZ4sjx', 390277, '2026-02-04 05:00:00', '고양, 안성 스타필드 링크맘 팝업건', '협력룸', '["서범주 팀장","조희태 과장"]', '고양 스타필드에서 4월 22까지 ~ 5월 4일까지 30평 내외 팝업스토어 진행\n옥토 x 링크맘 x 꿈비 x 가이아 행사 참여 진행\n1) 옥토는 계약금 30만원 수수료로 지급\n2) 30평 중 3평정도 봄봄매트 전시 60*60 및 120*120 전시 120*120 사이즈는 샘플이 나오고 전시가 되는 경우 전시 진행\n> 봄봄매트 3평 내외 공간 요청\n> 셀프 시공매트는 링크맘 PB 상품으로 전시 예정\n3) 인력 운영 관련해서 이야기 해야되며, 4월 30일 ~ 5월 1일 코베 코엑스 베이비페어 참석으로 인력 운영에 옥토는 어려움이 있어 가이아 측에 행사 진행 전 미팅 후 상담 내용 가이아 측에서 대체 업무 진행\n4) 철거는 5월 4일 오후 10시 끝나고 행사 종료 후 철거 진행해야되며, 가이아 측에서 임시보관 추후 확인 회수 관련 일정 협의 필요\n', '1) 행사 인력 운영 확인 요청\n', '[{"task":"매트 전시 및 상담 미팅","assignee":"조희태","dueDate":"2026-04-22"}]', NULL, '2026-02-04 11:46:28', '2026-02-04 11:46:28');

-- Table: monthly_messages (2 rows)
INSERT INTO `monthly_messages` (`id`, `userId`, `year`, `month`, `message`, `authorName`, `createdAt`, `updatedAt`) VALUES
('10b2b8d2-eec3-4aed-a3b6-3b59b78c5a38', 1, 2026, 2, '이달은 공장 신규 라인 증설이 본격적으로 진행되는 달입니다. 영업 또한 설 연휴 전까지 바쁜 일정이 이어질 것으로 보입니다. 각자의 자리에서 새로운 환경에 적응하며 최선을 다해주시는 모든 분들께 감사드리며, 진심으로 응원합니다.', '경식 윤', '2026-02-03 08:46:18', '2026-02-03 08:46:18'),
('7cc6b043-527f-4239-8c0c-d72f652b2cea', 1, 2026, 3, '1분기를 마무리하는 3월입니다. 신제품 출시와 업무 조정으로 바쁜 나날이 이어지고 있지만, 다가오는 봄처럼 따뜻한 마음으로 서로를 격려하며 즐겁고 의미 있는 한 달을 함께 만들어가면 좋겠습니다.', '경식 윤', '2026-03-10 07:51:10', '2026-03-10 07:51:10');

-- Table: positions (4 rows)
INSERT INTO `positions` (`id`, `name`, `description`, `isActive`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
(1, '팀장', '', 1, 0, '2026-01-26 17:51:23', '2026-01-26 17:51:23'),
(2, '팀원', '', 1, 0, '2026-01-26 17:51:31', '2026-01-26 17:51:31'),
(3, '파트장', '', 1, 0, '2026-01-26 17:51:38', '2026-01-26 17:51:38'),
(4, '임원', '', 1, 0, '2026-01-26 17:51:51', '2026-01-26 17:51:51');

-- Table: quarterly_reviews (0 rows)

-- Table: ranks (7 rows)
INSERT INTO `ranks` (`id`, `name`, `level`, `description`, `isActive`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
(1, '사원', 1, '', 1, 0, '2026-01-26 17:52:07', '2026-01-26 17:52:39'),
(2, '주임', 2, '', 1, 0, '2026-01-26 17:52:18', '2026-01-26 17:52:45'),
(3, '대리', 3, '', 1, 0, '2026-01-26 17:52:24', '2026-01-26 17:52:51'),
(4, '과장', 4, '', 1, 0, '2026-01-26 17:52:30', '2026-01-26 17:52:57'),
(5, '차장', 5, '', 1, 0, '2026-01-26 17:53:08', '2026-01-26 17:53:08'),
(6, '부장', 6, '', 1, 0, '2026-01-26 17:53:18', '2026-01-26 17:53:18'),
(7, '임원', 7, '', 1, 0, '2026-01-26 17:53:32', '2026-01-26 17:53:32');

-- Table: reports (1 rows)
INSERT INTO `reports` (`id`, `reportType`, `reportScope`, `targetUserId`, `targetTeamId`, `targetDivisionId`, `year`, `month`, `week`, `title`, `content`, `summary`, `nextPlan`, `issues`, `generatedBy`, `reportStatus`, `createdAt`, `updatedAt`) VALUES
(180001, 'monthly', 'team', NULL, 2, NULL, 2026, 3, NULL, '[월간보고서] 고객영업팀 - 2026년 3월', '{"teamName":"고객영업팀","kpiOverview":{"totalMembers":4,"totalTasks":8,"totalIndicators":11,"indicatorsWithTarget":0,"avgAchievementRate":0,"achieved":0,"nearTarget":0,"belowTarget":0,"memberAchievements":[{"name":"지윤선","avgRate":0,"taskCount":1,"indicatorCount":0},{"name":"이정은","avgRate":0,"taskCount":1,"indicatorCount":0},{"name":"김소영","avgRate":0,"taskCount":3,"indicatorCount":0},{"name":"이주홍","avgRate":0,"taskCount":3,"indicatorCount":0}],"categoryAchievements":[]},"memberDetails":[{"name":"지윤선","taskDetails":[{"category":"온라인","task":"고객문의관리","department":"채널영업팀","previousEvaluation":"","currentPlan":"","execution":"","indicators":[]}]},{"name":"이정은","taskDetails":[{"category":"봄봄 고객영업","task":"홈피문의","department":"고객영업팀","previousEvaluation":"","currentPlan":"","execution":"","indicators":[{"name":"월간계약건수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0},{"name":"월간계약장수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0}]}]},{"name":"김소영","taskDetails":[{"category":"봄봄 고객영업","task":"전화상담","department":"고객영업팀","previousEvaluation":"","currentPlan":"","execution":"","indicators":[{"name":"월간계약건수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0},{"name":"월간계약장수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0}]},{"category":"봄봄 고객영업","task":"샘플신청","department":"고객영업팀","previousEvaluation":"","currentPlan":"","execution":"","indicators":[{"name":"월간계약건수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0},{"name":"월간계약장수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0}]},{"category":"봄봄 고객영업","task":"채널톡","department":"고객영업팀","previousEvaluation":"","currentPlan":"","execution":"","indicators":[{"name":"월간계약건수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0},{"name":"월간계약장수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0}]}]},{"name":"이주홍","taskDetails":[{"category":"꿈비 고객영업","task":"시공예약관리","department":"고객영업팀","previousEvaluation":"","currentPlan":"","execution":"","indicators":[{"name":"월간시공 건수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0}]},{"category":"시공관리","task":"시공일정 관리","department":"고객영업팀","previousEvaluation":"","currentPlan":"","execution":"","indicators":[{"name":"월간시공건수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0}]},{"category":"시공관리","task":"시공결과 입력","department":"고객영업팀","previousEvaluation":"","currentPlan":"","execution":"","indicators":[{"name":"월간계약장수","unit":"","monthlyTotal":0,"monthlyTarget":0,"achievementRate":0}]}]}],"period":"2026년 3월","generatedAt":"2026-03-17T04:15:42.816Z"}', NULL, NULL, NULL, 1, 'draft', '2026-03-17 08:15:42', '2026-03-17 08:15:42');

-- Table: sales_categories (1 rows)
INSERT INTO `sales_categories` (`id`, `name`, `division`, `isActive`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
(1, '봄봄시공', '시공', 1, 0, '2026-01-27 05:09:02', '2026-01-27 05:09:02');

-- Table: sales_events (28 rows)
INSERT INTO `sales_events` (`id`, `userId`, `title`, `description`, `eventDate`, `endDate`, `isAllDay`, `eventType`, `color`, `division`, `reminderDays`, `createdAt`, `updatedAt`) VALUES
('0b956072-a8db-48c1-b3a2-0d448aa62352', 390277, '[봄봄매트] 부산지사 부산세메세코리아 베이비페어', NULL, '2026-03-12 04:00:00', '2026-03-15 04:00:00', 1, 'promotion', '#279608', NULL, 0, '2026-03-10 06:59:39', '2026-03-10 06:59:47'),
('0bc818c8-5d4a-4407-8288-e0cdc7c4495b', 1080001, '[슈슈비] 공동구매 (포포네)', NULL, '2026-02-09 05:00:00', '2026-02-18 05:00:00', 1, 'other', '#3b82f6', NULL, 0, '2026-02-10 09:44:22', '2026-02-10 09:44:22'),
('0c566aa5-dbba-47e7-95ba-3981636c6eb4', 390277, '[리코코] 네이버라이브방송 600', NULL, '2026-03-18 04:00:00', NULL, 1, 'promotion', '#680576', NULL, 0, '2026-03-10 07:04:37', '2026-03-10 07:04:37'),
('0ce385d5-0e49-46ea-a631-b1b6633761aa', 390277, '[슈슈비] 인플루언서 공동구매(하나맘)', NULL, '2026-03-10 04:00:00', '2026-03-15 04:00:00', 1, 'promotion', '#3b82f6', NULL, 0, '2026-03-10 06:57:52', '2026-03-10 06:58:16'),
('2ebb868d-a30b-4fdf-873b-3121a17da0c6', 1080001, '[슈슈비] 공동구매 (솔맘)', NULL, '2026-02-02 05:00:00', '2026-02-08 05:00:00', 1, 'other', '#3b82f6', NULL, 0, '2026-02-10 09:44:43', '2026-02-10 09:44:43'),
('4243d6e2-267c-4327-81c1-635b2009cc2d', 390277, '[봄봄매트] 충청지사 충청코베 베이비페어', NULL, '2026-03-26 04:00:00', '2026-03-29 04:00:00', 1, 'promotion', '#036d18', NULL, 0, '2026-03-10 07:09:11', '2026-03-10 07:09:11'),
('43cb60cf-8c01-4906-a353-2836cf92551f', 390277, '[리코코] 네이버라이브방송 1000', NULL, '2026-03-27 04:00:00', NULL, 1, 'promotion', '#34067a', NULL, 0, '2026-03-10 07:03:53', '2026-03-10 07:03:53'),
('4a3bcf2d-2fb3-485b-abbb-f3778ed6837d', 390277, '[봄봄매트] 부산지사 창원베이비페어', NULL, '2026-04-02 04:00:00', '2026-04-05 04:00:00', 1, 'promotion', '#3b82f6', NULL, 0, '2026-03-10 08:09:27', '2026-03-10 08:09:27'),
('4cc4f685-b0a2-4977-a216-d291b812e261', 1080001, '[슈슈비] 공동구매 (엘쓰맘)', NULL, '2026-02-23 05:00:00', '2026-03-01 05:00:00', 1, 'other', '#3b82f6', NULL, 0, '2026-02-10 09:45:17', '2026-02-10 09:45:17'),
('4e85e530-04ec-4f9d-bd03-f781de8072fb', 390277, '[봄봄매트] 네이버라이브방송 11:00', NULL, '2026-04-14 04:00:00', NULL, 1, 'promotion', '#ff0000', NULL, 0, '2026-03-10 08:15:26', '2026-03-27 12:30:50'),
('59da0665-89dd-4d0a-bfef-5a70abba71cd', 1, '[베이비페어] 대구 베키(대구지사)', NULL, '2026-02-26 05:00:00', '2026-03-01 05:00:00', 1, 'other', '#3b82f6', NULL, 0, '2026-02-03 08:55:58', '2026-02-03 09:07:08'),
('65b4dbfd-7ef1-4bb8-978d-48ad5adb867d', 1, '네이버라이브 방송', '11시', '2026-02-25 05:00:00', NULL, 1, 'other', '#3b82f6', NULL, 0, '2026-02-03 08:55:13', '2026-02-03 08:55:30'),
('680675f6-f131-4be2-a5d2-26fb15c570ee', 390277, '[리코코] 네이버라이브방송 1000 11:00', NULL, '2026-04-22 04:00:00', NULL, 1, 'promotion', '#ff0000', NULL, 0, '2026-03-10 08:16:15', '2026-03-10 08:16:15'),
('6caa513e-a36b-4924-aaa7-c477c86fe875', 390277, '[봄봄매트] 부산 코베 베이비페어', NULL, '2026-04-16 04:00:00', '2026-04-19 04:00:00', 1, 'promotion', '#3b82f6', NULL, 0, '2026-03-10 08:10:23', '2026-03-10 08:16:34'),
('6cac6eee-adb2-4649-affc-5c84d1699f66', 390277, '[봄봄] 주원맘 인플루언서 공동구매 1200', NULL, '2026-05-25 04:00:00', '2026-05-31 04:00:00', 1, 'other', '#3b82f6', NULL, 0, '2026-03-27 12:29:48', '2026-03-27 12:29:48'),
('87e97f5d-8ca8-4f78-8a1e-f4a5ae5b4d17', 390277, '[봄봄매트] 네이버라이브방송 11시', NULL, '2026-03-11 04:00:00', NULL, 1, 'promotion', '#f73b3b', NULL, 0, '2026-03-10 06:58:50', '2026-03-10 06:58:56'),
('8c45d2e7-9f55-49e4-badf-67cc97bfe81f', 390277, '[봄봄매트] 인천 코베 베이비페어', NULL, '2026-03-12 04:00:00', '2026-03-15 04:00:00', 1, 'promotion', '#af06b2', NULL, 0, '2026-03-10 07:00:18', '2026-03-10 07:00:34'),
('92eb2d45-a74c-4ec7-8288-6550c33b81a4', 390277, '고양 스타필크 링크맘 행사', NULL, '2026-04-22 04:00:00', '2026-05-04 04:00:00', 1, 'promotion', '#fa05b9', NULL, 0, '2026-03-10 08:11:11', '2026-03-10 08:11:11'),
('a45c4bf4-ae84-486f-96c4-e6ca4d76b90c', 390277, '[봄봄매트] 주원맘 인플루언서 공동구매', NULL, '2026-03-16 04:00:00', '2026-03-22 04:00:00', 1, 'promotion', '#cc9705', NULL, 0, '2026-03-10 07:01:24', '2026-03-10 07:02:14'),
('b0b82d19-4837-4052-b4af-f93915fe047f', 390277, '[봄봄매트] 네이버 라이브방송 11시', NULL, '2026-03-25 04:00:00', NULL, 1, 'promotion', '#c60606', NULL, 0, '2026-03-10 07:03:14', '2026-03-10 07:03:14'),
('b4dfe916-144f-43be-bf6c-2eaec503ac18', 390277, '[리코코] 네이버라이브방송 1000', NULL, '2026-03-06 05:00:00', NULL, 1, 'other', '#5d0896', NULL, 0, '2026-03-10 07:05:13', '2026-03-10 07:05:13'),
('b6a63b7e-e66f-4d8a-9d86-f1a40a7c42d9', 390277, '[봄봄매트] 수원 코베 베이비페어', NULL, '2026-03-19 04:00:00', '2026-03-22 04:00:00', 1, 'promotion', '#c806cb', NULL, 0, '2026-03-10 07:02:07', '2026-03-10 07:02:07'),
('b9199043-9313-4f8a-8ecb-10399fc05f67', 390277, '[봄봄매트] 서울 코베 베이비페어', NULL, '2026-04-30 04:00:00', '2026-05-03 04:00:00', 1, 'promotion', '#01b20d', NULL, 0, '2026-03-10 08:11:56', '2026-03-10 08:16:28'),
('c34d338d-063f-4c21-a8b0-016528a9b056', 390277, '[슈슈비] 디살 인플루언서 공동구매', NULL, '2026-03-23 04:00:00', '2026-03-29 04:00:00', 1, 'promotion', '#3b82f6', NULL, 0, '2026-03-10 07:02:45', '2026-03-10 07:02:45'),
('c4c181c2-0d0a-430d-a503-34924ab21362', 390277, '[리코코] 네이버라이브방송 11:00', NULL, '2026-04-08 04:00:00', NULL, 1, 'promotion', '#ff2600', NULL, 0, '2026-03-10 08:14:20', '2026-03-10 08:15:41'),
('d8163d1a-762e-4736-bd95-b8149b32f6e1', 1080001, '[슈슈비] 켈리맘 공동구매 (03.16~03.22)', NULL, '2026-03-16 04:00:00', NULL, 1, 'other', '#3b82f6', NULL, 0, '2026-03-22 12:16:14', '2026-03-22 12:16:14'),
('e557adc7-ce77-45a5-99b3-c7295a10194a', 1, '인플루언서공동구매(이아록님)', NULL, '2026-02-09 05:00:00', '2026-02-15 05:00:00', 1, 'other', '#3b82f6', NULL, 0, '2026-02-03 08:54:36', '2026-02-03 09:06:57'),
('fce89ab3-cd51-4d64-aa4f-cffac42667ad', 390277, '[봄봄매트] 오꾸맘 인플루언서 공동구매 사이즈 600 & 1200', NULL, '2026-06-15 04:00:00', '2026-06-21 04:00:00', 1, 'promotion', '#3b82f6', NULL, 0, '2026-03-27 12:30:32', '2026-03-27 12:30:32');

-- Table: sales_items (1 rows)
INSERT INTO `sales_items` (`id`, `categoryId`, `name`, `isActive`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
(1, 1, '본사', 1, 0, '2026-01-27 05:09:58', '2026-01-27 05:09:58');

-- Table: sales_records (33 rows)
INSERT INTO `sales_records` (`id`, `userId`, `division`, `productGroup`, `monthlyTarget`, `previousMonthSales`, `week1Sales`, `week2Sales`, `week3Sales`, `week4Sales`, `week5Sales`, `cumulativeSales`, `achievementRate`, `year`, `month`, `createdAt`, `updatedAt`) VALUES
('_CUtuevuO520YnWXLnCwF', 1080001, 'ricoco', '온라인매출', 10000000, 0, 7508545, 10345565, 9337394, 2879030, 0, 30070534, '300.7', 2026, 1, '2026-02-12 11:03:13', '2026-02-13 06:43:47'),
('_Hbpzf8cVXrp7i1-M84D9', 1080001, 'manufacturing', '기타', 0, 0, 1528681, 4224000, 5720035, 3820992, 0, 15293708, '0.0', 2026, 3, '2026-03-09 04:43:43', '2026-03-30 07:58:20'),
('1n-bvOeWv3d2q1J7JojJy', 1, 'bombom', '본사', 400000000, 351425108, 138692046, 73638598, 109513888, 63875677, 0, 385720209, '96.4', 2026, 1, '2026-01-26 19:19:40', '2026-02-03 06:19:27'),
('2xultegoodEE4BBpacsiw', 1, 'bombom', '본사', 400000000, 385720209, 112774901, 105400450, 57254084, 65769538, 0, 341198973, '85.3', 2026, 2, '2026-02-03 06:28:18', '2026-03-03 07:58:06'),
('361aLTk0iRQQ1oxR2FxwG', 1, 'manufacturing', '시공외주', 0, 0, 2976364, 3784145, 1079636, 2596363, 0, 10436508, '0.0', 2026, 2, '2026-03-04 08:27:20', '2026-03-04 08:27:20'),
('3ndaal4WPLJRwbzsy0kw3', 1, 'bombom', '지사', 200000000, 165560914, 36127730, 47128846, 8171819, 30900004, 0, 122328399, '61.2', 2026, 2, '2026-02-03 06:28:19', '2026-03-03 07:58:06'),
('9tZZ1CAHxGfp5SrBC5YdG', 1, 'manufacturing', '에르모어', 0, 0, 36300000, 2175000, 8190000, 14175000, 0, 60840000, '0.0', 2026, 3, '2026-03-17 06:17:22', '2026-03-30 08:01:45'),
('A_u67w-dwPKmTMpY-jvWX', 1, 'online', '기타', 0, 11107443, 0, 1296540, 0, 456750, 0, 1753290, '0.0', 2026, 1, '2026-01-26 19:20:13', '2026-02-02 05:22:51'),
('cMDlf_p-dGSqd3lqQD2y7', 1080001, 'manufacturing', '리코코', 37500000, 0, 0, 0, 0, 0, 0, 0, '0.0', 2026, 3, '2026-03-09 04:43:42', '2026-03-30 07:58:20'),
('dKZZ1uxJkhpSIL-h_u6Dx', 1, 'manufacturing', '크림하우스', 20000000, 20129800, 8477000, 5017600, 5390000, 3900400, 0, 22785000, '113.9', 2026, 2, '2026-02-03 06:29:26', '2026-03-03 07:57:33'),
('DlzYGCdyOqAtTGJk4phAE', 1080001, 'online', '슈슈비', 300000000, 0, 103440288, 84026374, 317037083, 138256698, 0, 642760443, '214.3', 2026, 3, '2026-03-09 04:42:55', '2026-03-30 08:01:44'),
('Dp--C1y35En7C_bjrMDDD', 1, 'bombom', '지사', 200000000, 221556820, 44042727, 25692274, 37129546, 58696367, 0, 165560914, '82.8', 2026, 1, '2026-01-26 19:19:41', '2026-02-03 06:19:47'),
('HzHmVENUE4OTefXlCWHkM', 1, 'manufacturing', '기타', 30000000, 23819552, 1979700, 1034091, 583590, 1744636, 0, 5342017, '17.8', 2026, 1, '2026-01-26 19:20:09', '2026-02-02 05:20:41'),
('jZcFOuFLdYHUZXfniv375', 1, 'online', '슈슈비', 300000000, 301753024, 71792006, 130242054, 66479114, 58857791, 0, 327370965, '109.1', 2026, 1, '2026-01-26 19:20:12', '2026-02-02 05:19:34'),
('kddJyJ7fi5cAa_GIOJsZm', 1020001, 'ricoco', '온라인매출', 0, 0, 5495700, 0, 0, 0, 0, 5495700, '0.0', 2026, 3, '2026-03-09 06:47:21', '2026-03-09 08:25:03'),
('lEuxvxYjg4ZELqTjVzmSC', 1, 'manufacturing', '리코코', 20000000, 0, 28952000, 0, 0, 0, 0, 28952000, '144.8', 2026, 2, '2026-02-03 06:29:26', '2026-03-04 08:27:18'),
('lJqwKrEn2RebFrNzA7bS7', 1080001, 'online', '봄봄', 108000000, 0, 24147951, 24086225, 13887064, 6597666, 0, 68718906, '63.6', 2026, 3, '2026-03-09 04:42:55', '2026-03-30 07:58:19'),
('MFaRTpJImNLMO6Yzzg1Ab', 1, 'manufacturing', '기타', 10000000, 5342017, 1074500, 1080682, 137135, 12045500, 0, 14337817, '143.4', 2026, 2, '2026-02-03 06:29:27', '2026-03-04 08:27:19'),
('mIRqRkCDIiMoLJ5rebqah', 1, 'online', '봄봄', 100000000, 73703608, 21282854, 15062935, 54661348, 39260297, 0, 130267434, '130.3', 2026, 1, '2026-01-26 19:20:10', '2026-02-02 05:19:10'),
('mxoYkQnwYwfsCwbcUSnCi', 1080001, 'ricoco', '시공매출', 90000000, 0, 4193970, 4797860, 775428, 363840, 0, 10131098, '11.3', 2026, 1, '2026-02-12 11:03:12', '2026-02-13 06:43:46'),
('NeE4kmP36MW6LHI21XaC5', 1080001, 'manufacturing', '크림하우스', 36720600, 0, 9790200, 3998400, 6213200, 3959200, 0, 23961000, '65.3', 2026, 3, '2026-03-09 04:43:43', '2026-03-30 07:58:20'),
('oHHmLTMn7PH7K-WXeS4kV', 1, 'online', '봄봄', 100000000, 130267434, 24952986, 17995326, 16813249, 20183941, 0, 79945502, '79.9', 2026, 2, '2026-02-03 06:30:13', '2026-03-03 07:55:38'),
('P-g-ltZq-KYW4h64uZ1Wh', 1, 'manufacturing', '리코코', 0, 0, 0, 0, 0, 0, 0, 0, '0.0', 2026, 1, '2026-01-26 19:20:06', '2026-01-26 19:20:06'),
('p0XwU7AQ65es7-kUXGyFd', 1, 'online', '기타', 0, 1753290, 196926, 0, 0, 0, 0, 196926, '0.0', 2026, 2, '2026-02-03 06:30:14', '2026-02-11 10:40:59'),
('pVNgFkYfcD13bZqXguz9z', 1080001, 'ricoco', '시공매출', 45000000, 0, 52613010, 17100228, 2299710, 11722201, 0, 83735149, '186.1', 2026, 2, '2026-02-12 11:09:15', '2026-03-03 07:59:40'),
('r_Q5hg7qReiJt9UxeyVtK', 1080001, 'ricoco', '온라인매출', 5000000, 0, 5879231, 4686494, 126483, 0, 0, 10692208, '213.8', 2026, 2, '2026-02-12 11:09:16', '2026-02-23 08:42:07'),
('r4fR23bhepiw-iwHvs6Jn', 1, 'manufacturing', '피코베리', 0, 0, 0, 0, 0, 37410000, 0, 37410000, '0.0', 2026, 2, '2026-03-04 08:20:18', '2026-03-04 08:20:18'),
('r9omTMQT222SuvH-A8bCT', 1, 'manufacturing', '크림하우스', 20000000, 20981800, 6439200, 5047000, 4419800, 4223800, 0, 20129800, '100.6', 2026, 1, '2026-01-26 19:20:08', '2026-02-02 05:21:13'),
('tdP6L6YE2P1CKbr9Lmzlx', 1080001, 'online', '기타', 15000000, 0, 7122960, 0, 24616, 0, 0, 7147576, '47.7', 2026, 3, '2026-03-09 04:42:55', '2026-03-30 07:52:32'),
('TUY5WXlBRB98LMnCKvX6d', 1080001, 'bombom', '본사', 478800000, 0, 120331790, 88557580, 89225899, 104666226, 0, 402781495, '84.1', 2026, 3, '2026-03-09 04:42:30', '2026-03-30 07:58:18'),
('tYpYSsi7hMZGu7K696t9S', 1020001, 'ricoco', '시공매출', 0, 0, 0, 15194270, 17375423, 5915910, 0, 38485603, '0.0', 2026, 3, '2026-03-09 06:47:20', '2026-03-30 06:22:34'),
('XOYgmvMFQyg5fTZXLPEkS', 1, 'online', '슈슈비', 300000000, 327370965, 103105813, 64260274, 119202125, 51772369, 0, 338340581, '112.8', 2026, 2, '2026-02-03 06:30:14', '2026-03-03 07:55:38'),
('zqp7d1WVYZgcp2WXKa36s', 1080001, 'bombom', '지사', 200000000, 0, 67929093, 22201362, 58741821, 54279550, 0, 203151826, '101.6', 2026, 3, '2026-03-09 04:42:30', '2026-03-30 08:04:20');

-- Table: task_attachments (3 rows)
INSERT INTO `task_attachments` (`id`, `taskId`, `userId`, `fileName`, `fileKey`, `url`, `mimeType`, `fileSize`, `createdAt`) VALUES
(30001, 'GD2O5yiQAUomIxljqQYRy', 1, '신규라인_비용내역_정리.xlsx', 'task-attachments/GD2O5yiQAUomIxljqQYRy/towv0mwt-신규라인_비용내역_정리.xlsx', 'https://d2xsxph8kpxj0f.cloudfront.net/310519663257283404/LBTFCENZjm3KAvBMhoEbjE/task-attachments/GD2O5yiQAUomIxljqQYRy/towv0mwt-신규라인_비용내역_정리.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 12819, '2026-03-26 10:49:20'),
(30002, 'GD2O5yiQAUomIxljqQYRy', 1, '신규라인_비용내역.pptx', 'task-attachments/GD2O5yiQAUomIxljqQYRy/z5qas4zf-신규라인_비용내역.pptx', 'https://d2xsxph8kpxj0f.cloudfront.net/310519663257283404/LBTFCENZjm3KAvBMhoEbjE/task-attachments/GD2O5yiQAUomIxljqQYRy/z5qas4zf-신규라인_비용내역.pptx', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 71226, '2026-03-26 10:56:07'),
(60002, 'x7HlC3RAhNfa3zZAEeDua', 1, '1200사이즈_원가분석.pptx', 'task-attachments/x7HlC3RAhNfa3zZAEeDua/12gctgf0-1200사이즈_원가분석.pptx', 'https://d2xsxph8kpxj0f.cloudfront.net/310519663257283404/LBTFCENZjm3KAvBMhoEbjE/task-attachments/x7HlC3RAhNfa3zZAEeDua/12gctgf0-1200사이즈_원가분석.pptx', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 90981, '2026-03-31 04:42:48');

-- Table: task_progress_logs (15 rows)
INSERT INTO `task_progress_logs` (`id`, `taskId`, `logDate`, `content`, `createdAt`, `updatedAt`) VALUES
(6, 'lKPEhHfz_t6KAg7mUzsxA', '2026-02-06 05:00:00', '1차안 발표', '2026-02-02 12:47:18', '2026-02-02 12:47:18'),
(150001, 'Uy0D8tfVPvJ8MIQc6JFeE', '2026-02-20 04:39:33', '창원 > 베이비룸 M에서 B로 변경\n최재형 부장, 윤서원 차장에게 제품 배송 관련 내용 리마인드 진행 완료\n출력물 > 박금진 전무님 전달\n리플렛 & 견적서는 박금진 전무님 직접 김포물류에서 수령\n토이빌리지 > 포멕스 부스 설치 완료', '2026-02-20 05:40:46', '2026-02-20 05:40:46'),
(180002, 'uevfNE8w6lPigQPQp8Opw', '2026-02-23 07:35:06', '박금진 전무님 지시사항\n그루미 소파 전달 대전 토이빌리지로 택배로 보내라고 하셔 최재형 부장에게 전달', '2026-02-23 07:35:41', '2026-02-23 07:35:41'),
(210003, '82rJq4mmDmOjjme0QRzQA', '2026-02-17 05:00:00', '금형 제작 요청', '2026-02-23 14:14:59', '2026-02-23 14:14:59'),
(270003, 'bilbGrnO8_ed2enpF7PVh', '2026-02-23 05:00:00', '방승현팀장 미팅', '2026-02-24 07:32:45', '2026-02-24 07:32:45'),
(330001, '4fdaPt4KTpXhHaEoq3uOH', '2026-03-03 11:50:23', '총 계약건수 50건 > 4건 내외는 링크맘으로 계약 변경을 희망하시어 지사측에 안내 완료\n사은품 비용까지 링크맘에서 부담도 리마인드 언급', '2026-03-03 11:51:11', '2026-03-03 11:51:11'),
(390001, '6SblyzDuChGvqBux2kQxp', '2026-03-03 11:52:46', '총 계약건수 9건 / 장수 : 200장\n3월 20~23일 발송 예정\n출고가 앞당겨지는 경우 최재형 부장 언급 요청', '2026-03-10 06:44:54', '2026-03-10 06:44:54'),
(390002, '6SblyzDuChGvqBux2kQxp', '2026-02-20 05:00:00', '현수막 및 X배너 시안 업체 전달\n주문서 링크맘 부천점 자체 주문서 사용', '2026-03-10 06:44:54', '2026-03-10 06:44:54'),
(390003, '6SblyzDuChGvqBux2kQxp', '2026-03-09 04:00:00', '추가 구매 58장으로\n총 발주 수량 258장', '2026-03-10 06:44:54', '2026-03-10 06:44:54'),
(390005, 'NQSdHpn7N-X2nr5EVeI0T', '2026-02-20 04:38:33', '1인시공 투입이 현재 어려울 것으로 판단되어 교육 추가 진행 후 투입 예정 > 21팀 추가 교육 및 23팀 최종 확인 후 계약 진행', '2026-03-10 06:45:34', '2026-03-10 06:45:34'),
(390006, 'NQSdHpn7N-X2nr5EVeI0T', '2026-03-05 05:00:00', '계약완료', '2026-03-10 06:45:34', '2026-03-10 06:45:34'),
(420001, 'Pr_oamW2ccDEuU6yPiYv8', '2026-03-12 11:07:29', '인력 운영 계획 공유', '2026-03-12 11:07:42', '2026-03-12 11:07:42'),
(450001, '2-BMCno8xcxVF0dwldCPS', '2026-02-19 05:00:00', '시스템개발업체 수정요청', '2026-03-17 07:35:54', '2026-03-17 07:35:54'),
(480001, 'WzZ2c8830kSabVt4te-KA', '2026-03-09 04:00:00', '3월 25일 재시공 진행 후 인플루언서 공동구매 진행예정', '2026-03-30 09:54:29', '2026-03-30 09:54:29'),
(480002, 'WzZ2c8830kSabVt4te-KA', '2026-03-30 09:54:18', '지지부부 공동구매 의향은 없음', '2026-03-30 09:54:29', '2026-03-30 09:54:29');

-- Table: tasks (36 rows)
INSERT INTO `tasks` (`id`, `userId`, `number`, `title`, `department`, `assignee`, `schedule`, `details`, `status`, `createdAt`, `updatedAt`, `startDate`, `dueDate`) VALUES
('_bPwSsNArYFLy9-Av4aYG', 390277, 4, '슈슈비 매트 킨텍스 박람회 위탁 판매 미팅', '채널영업팀', '조희태', '', '링크맘 부천상동점 슈슈비 셀프 매트 킨텍스 박람회 위탁 판매 미팅 건', 'completed', '2026-02-06 12:40:40', '2026-02-12 12:56:33', '2026-02-10 05:00:00', '2026-02-10 05:00:00'),
('-zE5To2bDSd19P5Ou6rpu', 390277, 5, '샘플박스 스티커 변경 수정', '채널영업팀', '조희태', '', '샘플박스스티커 갤럭시 화이트 & 네이처 스티커 자료 부재로 고상일 실장 수정 요청\n폼텍 > 발주 필요 > 지출결의서 작성 > 수령 후 스티커 인쇄', 'completed', '2026-02-10 06:28:20', '2026-02-20 04:38:14', '2026-02-10 05:00:00', '2026-02-19 05:00:00'),
('2-BMCno8xcxVF0dwldCPS', 1, 37, '고객상담 프로세스 재 점검', '매트사업부', '이주홍', '', '[CRM 고객 DB 관리 프로세스 적용안]\n\n1. 견적 상담 완료\n -유비(시스템) 입력일 기준으로 관리 시작\n\n2. D+2 리마인드 문자 발송\n -상담 완료일(유비 입력일) 기준 2일 후 리마인드 문자 전송\n -문자에 대한 고객 피드백 내용 기록\n\n3. 문자 발송일 기준 D+2 아웃콜 진행\n -문자 발송일로부터 2일 후 유선 상담(아웃콜) 시도\n -통화 결과 및 상담 내용 DB 이력 기록\n\n4. DB 상태 분류 및 후속 관리\n -상담 결과에 따라 DB 상태 구분\n -추가 컨택 필요 고객 (재콜 일정 등록)\n -상담 종료 고객 (종결 처리)\n -상태값 업데이트 후 CRM에서 지속 관리', 'completed', '2026-02-12 08:27:56', '2026-03-31 04:49:07', NULL, '2026-03-17 04:00:00'),
('3WZXb-RY60rpDcGB8Mt2M', 1, 33, '26년 사업계획 리뷰 & 공유', '', '', '', '', 'completed', '2026-02-05 06:18:01', '2026-03-27 03:16:01', NULL, NULL),
('4fdaPt4KTpXhHaEoq3uOH', 390277, 14, '[대구지사]대구 베키 행사 진행', '채널영업팀', '조희태', '', '대구 베키 베이비페어 계약 건수 확인\n박금진 전무 1일 참관', 'completed', '2026-02-24 13:26:16', '2026-03-03 11:50:19', '2026-02-26 05:00:00', '2026-03-01 05:00:00'),
('6SblyzDuChGvqBux2kQxp', 390277, 10, '일산 유아림 맘앤 베이비엑스포 슈슈비 클립매트 위탁판매', '채널영업팀', '조희태', '', '슈슈비 클립매트 유아림 맘앤베이비엑스포 위탁판매 건\n2월 25일 김포물류 매트 수령 및 오후 2~3시 설치 진행\n', 'completed', '2026-02-20 04:43:38', '2026-03-10 06:44:57', '2026-02-26 05:00:00', '2026-03-01 05:00:00'),
('82rJq4mmDmOjjme0QRzQA', 1, 40, '클립형 펜트리매트  제작', '', '', '', '', 'in-progress', '2026-02-13 09:10:53', '2026-02-23 14:11:45', NULL, NULL),
('bilbGrnO8_ed2enpF7PVh', 1, 39, '유입경로별 마케팅 계획 수립 : 리코코, 봄봄', '지원팀', '', '', '유입경로\n1. 홈페이지문의\n2. 채널톡\n3. 인스타그램\n4. 상담전화\n5. 샘플신청', 'in-progress', '2026-02-12 08:38:36', '2026-02-24 07:32:45', '2026-02-09 05:00:00', '2026-03-06 05:00:00'),
('Cr48wKUjishIdsEpTNOeI', 1, 9, '2026년 인센티브 제안 확정', '', '', '', '연간목표(매출액,영업이익)달성 시 직원별 인센티브 금액 확정. 150억 / 15억', 'completed', '2026-01-26 08:55:01', '2026-03-27 03:16:20', NULL, NULL),
('dl2AhRkRLyPfdtRkEDCOG', 390277, 15, '주원맘 인플루언서 공동구매', '채널영업팀', '조희태', '', '주원맘 인플루언서 공동구매 행사 진행\n장당 : 28,500원\n시공비 : 70장 이상 무료시공, 미만 10만원 일부지역 지역 시공비 적용\n사은품 : 배민 3만원 상품권\n시공 후기 작성 시 이마트 5만원 상품권 증정', 'completed', '2026-03-12 11:35:32', '2026-03-30 09:54:08', '2026-03-16 04:00:00', '2026-03-22 04:00:00'),
('E47FKRC1Kjz127ccgIzkt', 390277, 1, '수원 코베 베이비페어', '채널영업팀', '조희태', '26.01.29 ~ 26.02.01', '수원 코베 베이비페어 박람회 행사 진행 목표 건수 : 30건\n총 계약 건수 : 19건', 'completed', '2026-01-30 11:41:30', '2026-02-06 12:04:34', NULL, NULL),
('f0Ev8ExOFN4kvWZok8-D5', 1, 30, '링크맘 재고 사은품 활용', '매트사업부', '', '', '부진재고 해소 방안\n1. 인플루언서공구 - 평형별 \n2. 라이브커머스 \n3. 전시회', 'completed', '2026-02-03 07:18:36', '2026-03-31 04:49:03', NULL, NULL),
('fesZ41EToWx8KgVKxCbvh', 1, 34, '슈슈비  상표권 등록 검토', '', '', '', '', 'pending', '2026-02-05 11:51:22', '2026-02-05 11:51:22', NULL, NULL),
('GD2O5yiQAUomIxljqQYRy', 1, 46, '신규라인 투자비용 정리', '', '', '', '', 'in-progress', '2026-03-26 10:48:46', '2026-03-26 10:56:14', '2026-03-26 04:00:00', '2026-03-26 04:00:00'),
('huMM2HY4jJvCXwLkFkTSu', 1, 25, '라인 증설 후 제품생산 계획 수립', '', '', '3월말', '1. 신규 라인 생산 개시 일 - 3월 20일 \n2. 120 신제품 출시일 - 4월 1일 \n3. 리코코 클립매트 생산- 3월 20일 ', 'in-progress', '2026-01-26 12:50:16', '2026-03-17 07:36:07', '2026-02-02 05:00:00', '2026-03-31 04:00:00'),
('hYlrPi9xAbtzmT7v2eZDJ', 1, 11, '베이비룸 제품 리뉴얼', '', '', '', '50센치 사이즈 매트 단종에 따라 60센치 매트에 맞는 신규 금형 제작 여부 검토\n클립매트 호환제품으로 변경', 'in-progress', '2026-01-26 08:55:01', '2026-02-24 07:34:18', NULL, NULL),
('idXuGEGfiAp79Rr8yJUSb', 1, 13, '매트 프로모션 스킴 세팅 - 채널별', '', '', '', '판매 채널별 프로모션 정책 확정 및 공유', 'in-progress', '2026-01-26 08:55:02', '2026-03-27 03:16:15', NULL, NULL),
('iftqf53xPMuWcixgkKpoP', 390277, 11, '링크맘 의정부직영점 베이비룸 발주', '채널영업팀', '조희태', '', '1. 링크맘 의정부직영점 베이비룸 발주 건 출고 오더 작성\n2. 링크맘 의정부 단가 관련 통화완료 판매 단가의 수수료 16% 제외하고 지급\n제품 설명 완료, 시공매트와 호환되지 않는거 고객 문의 시 안내 요청', 'completed', '2026-02-23 07:37:06', '2026-02-24 13:23:41', '2026-02-23 05:00:00', '2026-02-25 05:00:00'),
('iidVq056W7DzsnENGLaVx', 390277, 12, '송도 코베 베이비페어 운영 계획', '채널영업팀', '조희태', '', '1. 목표 계약 30건\n2. 세팅 및 인원 운영 인력계획 공지(완료)\n3. 프로모션 내용 공지 필요\n4. 물류팀 일정 공지 필요', 'completed', '2026-02-24 13:25:14', '2026-03-30 09:54:13', '2026-03-12 04:00:00', '2026-03-15 04:00:00'),
('iJDiyumm5fv7a-qT0LC7-', 390277, 2, '외주 시공팀 신규 계약', '채널영업팀', '조희태', '26.02.09', '신규 시공팀 26팀 임해진 팀장 계약 완료, 시공팀 유비플러스, 잔디(메신저), 고객응대, 매트 계약진행방법 교육 진행 완료\n공구 및 단말기 남부물류 (전) 25팀 차광호 팀장 사용 건 사용 진행', 'completed', '2026-02-06 12:06:32', '2026-02-06 12:06:32', '2026-02-06 05:00:00', '2026-02-06 05:00:00'),
('IuwuLVLlKI_jG6axodhoA', 1, 19, '화관법 신고', '제조사업부', '정시영차장', '3월', '신규공장 세팅 후 진행예정으로 컨설팅 업체 방문 예정', 'pending', '2026-01-26 08:55:03', '2026-01-26 08:55:03', NULL, NULL),
('lKPEhHfz_t6KAg7mUzsxA', 1, 10, '조직별 KPI와 OKR 제시', '', '', '', '개인별, 팀별 업무명세를 확정하고 목표 제시', 'in-progress', '2026-01-26 08:55:01', '2026-02-02 06:16:36', NULL, NULL),
('NgSs1_BvlMPogISfADLYY', 1, 41, '리코코 샘플박스 제작 테스트', '', '', '', '', 'pending', '2026-02-14 05:03:12', '2026-02-23 14:35:24', NULL, NULL),
('NQSdHpn7N-X2nr5EVeI0T', 390277, 6, '정태영 외주 시공팀 신규 계약', '채널영업팀', '조희태', '2월 24일', '정태영 예비시공팀 22팀, 23팀 시공평가서 확인 및 계약여부 진행확인', 'completed', '2026-02-10 09:59:02', '2026-03-10 06:45:37', '2026-02-24 05:00:00', NULL),
('ntebW6CtRuYvkhCp-PpR9', 390277, 7, '링크맘 부천점 유아림 베이비페어 협조 요청 건', '채널영업팀', '조희태', '', '1. 트러스 부스 현수막 이미지 시안 전달 > 제작중 > 박금진 전무님 컨펌 > 업체 전달완료\n2. 발주서 양식 전달(완료)', 'completed', '2026-02-11 04:41:35', '2026-02-20 04:38:09', '2026-02-11 05:00:00', '2026-02-19 05:00:00'),
('oeXKqC57BrgXEqPDMWSIP', 1, 28, '신규 필름 개발', '', '', '2월중', '프리미엄원단 개발 - 바이오 코팅  PU원단', 'in-progress', '2026-02-02 16:46:09', '2026-03-17 06:29:34', '2026-02-02 05:00:00', NULL),
('ONgVTMHjYWeVK5pY8PN30', 1, 17, '신규공장 보험가입', '', '', '2월말', '삼성화재 문의', 'pending', '2026-01-26 08:55:02', '2026-01-26 08:55:02', NULL, NULL),
('pek5vgwcCjWKGK4tpvS9j', 1, 3, '신규생산라인 진행사항 확인', '제조사업부', '오인석이사', '', '예정일정\n1. 테스트발포 : 설 이전\n2. 양산 테스트 : 3월 1일 \n3. 양산 시작 : 3월 15일 이후', 'in-progress', '2026-01-26 08:54:59', '2026-02-03 09:06:29', NULL, NULL),
('poVuDbQ37S34TZLdjUDMu', 1, 48, '원료 공급처 개발 - 중국', '', '', '', '', 'in-progress', '2026-03-31 04:47:50', '2026-03-31 04:47:58', NULL, NULL),
('Pr_oamW2ccDEuU6yPiYv8', 390277, 13, '수원 코베 베이비페어 운영 계획', '', '', '', '1. 목표 계약 30건\n2. 세팅 및 인원 운영 인력계획 공지(완료)\n3. 프로모션 내용 공지 필요\n4. 물류팀 일정 공지 필요', 'completed', '2026-02-24 13:25:39', '2026-03-30 09:54:12', '2026-03-19 04:00:00', '2026-03-22 04:00:00'),
('RkCMMw3bN1FuXVMIf4Bf9', 1, 44, '신규직원 채용 현황', '', '', '', '[용인본사]\n고객영업- 3명(마곡2명포함)\n채널영업-3명(사직2명포함)\n영업지원-1명\n관리-1명\n마케팅-1명\n\n[제조사업부]\n포장라인 한국인 - 1명\n생산관리 - 1명', 'in-progress', '2026-03-09 04:22:32', '2026-03-26 14:15:33', NULL, NULL),
('uevfNE8w6lPigQPQp8Opw', 390277, 8, '대전 토이빌리지 백부스 및 배너 시안 송부', '채널영업팀', '조희태', '', '시안 업체 > 백부스 및 배너 시안 송부\n19일 매트 오더 작성 후 샘플 4곳 발송', 'completed', '2026-02-12 12:58:01', '2026-02-13 06:16:54', '2026-02-12 05:00:00', '2026-02-19 05:00:00'),
('Uy0D8tfVPvJ8MIQc6JFeE', 390277, 3, '링크맘 대리점 POP 출력', '채널영업팀', '조희태', '', '링크맘\n창원 > 매트 12장 , 베이비룸 M(크림)\n대구 > 매트 6장\n포항 > 매트 6장\n토이플러스\n대전 > 매트 20장 설치 진행, 포멕스 + 켈지로 제작진행, 고상일 실장에게 시안 의뢰', 'completed', '2026-02-06 12:22:30', '2026-02-24 13:23:35', '2026-02-09 05:00:00', '2026-02-27 05:00:00'),
('WzZ2c8830kSabVt4te-KA', 390277, 9, '지지부부 인플루언서 공동구매 진행', '채널영업팀', '조희태', '', '지지부부 인플루언서 공동구매 진행 관련 건 특이사항 확인 후 진행\n서울 시공 장소는 현재 소음 이슈로 용인으로 이사 예정\n서울 본시공 시 무상으로 진행 건으로\n용인으로 재시공 시 재시공 비용 및 신규 매트 비용 발생 안내\n예상 견적 금액 발송', 'completed', '2026-02-12 13:24:19', '2026-03-30 09:54:30', '2026-02-12 05:00:00', NULL),
('x7HlC3RAhNfa3zZAEeDua', 1, 47, '1200 신제품 가격검토', '', '', '', '', 'in-progress', '2026-03-26 10:55:48', '2026-03-26 10:55:48', NULL, '2026-03-26 04:00:00'),
('ZpQWC7-0G9K7oCRxS5OfP', 1, 24, '브랜드간 영업전략', '', '', '2월중', '리코코, 봄봄, 슈슈비 브랜드별 독립적인 영업전략    \n주력채널, 스펙, 가격', 'pending', '2026-01-26 12:39:06', '2026-01-28 12:32:22', NULL, NULL);

-- Table: teams (5 rows)
INSERT INTO `teams` (`id`, `divisionId`, `name`, `description`, `isActive`, `sortOrder`, `createdAt`, `updatedAt`) VALUES
(1, 1, '채널영업팀', '', 1, 2, '2026-01-26 17:50:17', '2026-01-26 17:50:17'),
(2, 1, '고객영업팀', '', 1, 1, '2026-01-26 17:50:33', '2026-01-26 17:50:33'),
(3, 1, '관리팀', '인사 및 총무', 1, 4, '2026-01-26 17:51:08', '2026-03-16 15:34:53'),
(30001, 30001, '마케팅팀', '', 1, 3, '2026-03-16 15:34:47', '2026-03-16 15:34:47'),
(30002, 2, '생산관리팀', '', 1, 0, '2026-03-16 15:35:19', '2026-03-16 15:35:19');

-- Table: users (23 rows)
INSERT INTO `users` (`id`, `openId`, `name`, `email`, `loginMethod`, `role`, `createdAt`, `updatedAt`, `lastSignedIn`, `divisionId`, `teamId`, `positionId`, `rankId`, `isProfileComplete`, `koreanName`, `canEditSales`, `canEditFinancial`) VALUES
(1, 'faJYzqDrbUnfSvhyqq2exo', '경식 윤', 'timyun816@gmail.com', 'google', 'admin', '2026-01-26 08:42:31', '2026-03-31 17:23:22', '2026-03-31 17:23:23', 30001, NULL, 4, 7, 1, '윤경식', 0, 0),
(390243, 'bUwvDywRYMKcoiF2dniG3T', 'Chuhyun CHO', 'neg25love@gmail.com', 'google', 'user', '2026-01-27 07:28:33', '2026-01-27 07:28:34', '2026-01-27 07:28:35', NULL, NULL, NULL, NULL, 0, NULL, 0, 0),
(390252, 'JwBmCaBpBKnf7LY46YnJSL', 'cofla1026', 'cofla1026@naver.com', 'email', 'user', '2026-01-27 07:29:02', '2026-01-27 07:29:42', '2026-01-27 07:29:43', NULL, NULL, NULL, NULL, 0, NULL, 0, 0),
(390256, 'NUQ9P8CN7S6UvJvF2DE2aD', 'YSJI', 'YSJI@octoinc.co.kr', 'email', 'user', '2026-01-27 07:29:07', '2026-03-31 12:35:33', '2026-03-31 12:35:34', 1, 2, 2, 3, 1, '지윤선', 0, 0),
(390269, 'R3TmZkV2Z7PmUoMtMyJWy2', 'jkkim', 'jkkim@octoinc.co.kr', 'email', 'user', '2026-01-27 07:29:36', '2026-03-18 09:49:29', '2026-03-18 09:49:28', 1, 3, 2, 4, 1, '김진경', 0, 0),
(390277, 'GjpQTRDJPmZ35k5YmD6JzR', 'htchoi', 'htchoi@octoinc.co.kr', 'email', 'user', '2026-01-27 07:29:51', '2026-03-31 12:01:26', '2026-03-31 12:01:26', 1, 1, 2, 4, 1, '조희태', 1, 0),
(390280, 'ZE2eSxUzbcfuwjYzNMddmH', '정은 이', 'jelee@octoinc.co.kr', 'microsoft', 'user', '2026-01-27 07:29:54', '2026-02-06 07:09:15', '2026-02-06 07:09:16', 1, 2, 2, 4, 1, '이정은', 0, 0),
(390333, 'ECsRoNbHUAoffPbfFaBBw2', 'kjpark', 'kjpark@octoinc.co.kr', 'email', 'user', '2026-01-27 07:37:07', '2026-03-31 12:28:30', '2026-03-31 12:28:31', 1, NULL, 4, 7, 1, '박금진', 0, 0),
(420063, 'kMYNWRrr3GNCAQBSbagSSN', 'sykim', 'sykim@octoinc.co.kr', 'email', 'user', '2026-01-27 08:04:29', '2026-03-26 12:33:14', '2026-03-26 12:33:14', 1, 2, 2, 4, 1, '김소영', 0, 0),
(450001, 'JXQ6KVazT34E4nJSJeKBjN', 'swyun', 'swyun@octoinc.co.kr', 'email', 'user', '2026-01-27 08:20:14', '2026-01-30 18:24:33', '2026-01-30 18:24:33', NULL, NULL, NULL, NULL, 0, NULL, 0, 0),
(450200, 'hcq8V23aiyGpVEvHJWoyYu', 'syjung', 'syjung@octoinc.co.kr', 'email', 'user', '2026-01-27 08:58:17', '2026-02-05 09:21:32', '2026-02-05 09:21:32', NULL, NULL, NULL, NULL, 0, NULL, 0, 0),
(510002, '5za34k63TJmvdgLiTFKvdQ', '인석 오', 'ohis0763@gmail.com', 'google', 'user', '2026-01-27 10:45:49', '2026-01-27 16:33:59', '2026-01-27 16:34:00', NULL, NULL, NULL, NULL, 0, NULL, 0, 0),
(660001, 'gw63PbydkkH6V4Sz5Fh3mL', 'han1367', 'han1367@hanmail.net', 'email', 'user', '2026-01-27 13:56:04', '2026-03-23 13:29:55', '2026-03-23 13:29:53', 30001, NULL, 4, 7, 1, '한용희', 0, 0),
(660028, 'i3vmte6dqRiRZsrH6h7sQJ', 'jhchoi', 'jhchoi@octoinc.co.kr', 'email', 'user', '2026-01-27 14:10:48', '2026-01-28 04:15:54', '2026-01-28 04:15:55', NULL, NULL, NULL, NULL, 0, NULL, 0, 0),
(750015, 'eknqJSj58rvpmxrJpX58dJ', 'isoh', 'isoh@octoinc.co.kr', 'email', 'user', '2026-01-27 16:38:48', '2026-01-31 12:39:50', '2026-01-31 12:39:50', NULL, NULL, NULL, NULL, 0, NULL, 0, 0),
(990003, 'S28pzh7RYsgWRmjRGEXhWr', '상순 백', 'octobombom7@gmail.com', 'google', 'user', '2026-01-28 06:43:30', '2026-01-28 06:44:46', '2026-01-28 06:44:47', NULL, NULL, 4, 7, 1, '백상순', 0, 0),
(1020001, '6yFEvYwLvLxVyFpmZjWLbB', '주홍 이', 'ljh8370a@gmail.com', 'google', 'user', '2026-01-28 06:59:45', '2026-03-31 13:19:59', '2026-03-31 13:20:00', 1, 2, 3, 5, 1, '이주홍', 1, 0),
(1080001, 'h5e9b2AvHLCbdwXxQ3DR6T', 'bjseo', 'bjseo@octoinc.co.kr', 'email', 'user', '2026-01-28 07:41:46', '2026-03-31 06:39:56', '2026-03-31 06:39:56', 1, 1, 1, 4, 1, '서범주', 1, 0),
(5670055, 'RoT5DKTAArNDgZoNYb7oXE', 'rlarod1110', 'rlarod1110@naver.com', 'email', 'user', '2026-02-11 10:06:39', '2026-03-19 05:37:35', '2026-03-19 05:37:35', NULL, NULL, NULL, NULL, 0, NULL, 0, 0),
(6180029, 'ZeCpTZ9LyP5Ao9YgjVqYSE', 'nrshin', 'nrshin@octoinc.co.kr', 'email', 'user', '2026-02-12 13:08:02', '2026-03-31 12:24:36', '2026-03-31 12:24:37', 1, 1, 2, 4, 1, '신나라', 0, 0),
(11310002, 'KGPiZCgHNfuNG6UdDpNVfK', 'hyerim kim', 'rlagpfla1119@gmail.com', 'google', 'user', '2026-03-18 09:52:51', '2026-03-20 12:02:29', '2026-03-20 12:02:29', 1, 3, 2, 2, 1, '김혜림', 0, 0),
(12090003, 'LScRAnX2rHLMkFuavdFhTy', 'md', 'md@ggumbi.com', 'email', 'user', '2026-03-23 08:22:40', '2026-03-23 13:05:56', '2026-03-23 13:05:56', NULL, NULL, NULL, NULL, 0, NULL, 0, 0),
(12570001, 'cJHZqSmcD2Q6MDukgUw5GQ', 'hole-man', 'hole-man@nate.com', 'email', 'user', '2026-03-26 09:07:23', '2026-03-27 16:45:40', '2026-03-27 16:45:41', NULL, NULL, 4, 7, 1, '박영건', 1, 1);

SET FOREIGN_KEY_CHECKS = 1;
