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
