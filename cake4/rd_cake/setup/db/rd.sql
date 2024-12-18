-- MariaDB dump 10.19  Distrib 10.6.16-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: rd
-- ------------------------------------------------------
-- Server version	10.6.16-MariaDB-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accel_arrivals`
--

DROP TABLE IF EXISTS `accel_arrivals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accel_arrivals` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mac` varchar(255) NOT NULL,
  `vendor` varchar(255) DEFAULT NULL,
  `last_contact` datetime DEFAULT NULL,
  `last_contact_from_ip` varchar(30) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accel_arrivals`
--

LOCK TABLES `accel_arrivals` WRITE;
/*!40000 ALTER TABLE `accel_arrivals` DISABLE KEYS */;
/*!40000 ALTER TABLE `accel_arrivals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accel_profile_entries`
--

DROP TABLE IF EXISTS `accel_profile_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accel_profile_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accel_profile_id` int(11) NOT NULL,
  `section` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `no_key_flag` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accel_profile_entries`
--

LOCK TABLES `accel_profile_entries` WRITE;
/*!40000 ALTER TABLE `accel_profile_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `accel_profile_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accel_profiles`
--

DROP TABLE IF EXISTS `accel_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accel_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cloud_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `base_config` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accel_profiles`
--

LOCK TABLES `accel_profiles` WRITE;
/*!40000 ALTER TABLE `accel_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `accel_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accel_servers`
--

DROP TABLE IF EXISTS `accel_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accel_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cloud_id` int(11) NOT NULL,
  `accel_profile_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `mac` varchar(255) NOT NULL,
  `pppoe_interface` varchar(10) NOT NULL,
  `nas_identifier` varchar(32) NOT NULL,
  `server_type` enum('standalone','mesh','ap_profile') DEFAULT 'standalone',
  `config_fetched` datetime DEFAULT NULL,
  `last_contact` datetime DEFAULT NULL,
  `last_contact_from_ip` varchar(30) NOT NULL DEFAULT '',
  `restart_service_flag` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accel_servers`
--

LOCK TABLES `accel_servers` WRITE;
/*!40000 ALTER TABLE `accel_servers` DISABLE KEYS */;
/*!40000 ALTER TABLE `accel_servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accel_sessions`
--

DROP TABLE IF EXISTS `accel_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accel_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accel_server_id` int(11) NOT NULL,
  `netns` varchar(255) NOT NULL DEFAULT '',
  `vrf` varchar(255) NOT NULL DEFAULT '',
  `ifname` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(255) NOT NULL DEFAULT '',
  `ip` varchar(32) NOT NULL DEFAULT '',
  `ip6` varchar(32) NOT NULL DEFAULT '',
  `ip6_dp` varchar(32) NOT NULL DEFAULT '',
  `type` varchar(32) NOT NULL DEFAULT '',
  `state` varchar(32) NOT NULL DEFAULT '',
  `uptime` varchar(32) NOT NULL DEFAULT '',
  `uptime_raw` int(11) NOT NULL DEFAULT 0,
  `calling_sid` varchar(32) NOT NULL DEFAULT '',
  `called_sid` varchar(32) NOT NULL DEFAULT '',
  `sid` varchar(32) NOT NULL DEFAULT '',
  `comp` varchar(32) NOT NULL DEFAULT '',
  `rx_bytes` varchar(32) NOT NULL DEFAULT '',
  `tx_bytes` varchar(32) NOT NULL DEFAULT '',
  `rx_bytes_raw` int(11) NOT NULL DEFAULT 0,
  `tx_bytes_raw` int(11) NOT NULL DEFAULT 0,
  `rx_pkts` int(11) NOT NULL DEFAULT 0,
  `tx_pkts` int(11) NOT NULL DEFAULT 0,
  `inbound_if` varchar(32) NOT NULL DEFAULT '',
  `service_name` varchar(32) NOT NULL DEFAULT '',
  `rate_limit` varchar(32) NOT NULL DEFAULT '',
  `disconnect_flag` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accel_sessions`
--

LOCK TABLES `accel_sessions` WRITE;
/*!40000 ALTER TABLE `accel_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `accel_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accel_stats`
--

DROP TABLE IF EXISTS `accel_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accel_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accel_server_id` int(11) NOT NULL,
  `version` varchar(255) NOT NULL,
  `uptime` varchar(255) NOT NULL,
  `cpu` varchar(255) NOT NULL,
  `mem` varchar(255) NOT NULL,
  `core` text NOT NULL,
  `sessions_active` int(11) NOT NULL,
  `sessions` text NOT NULL,
  `pppoe` text NOT NULL,
  `radius1` text NOT NULL,
  `radius2` text NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accel_stats`
--

LOCK TABLES `accel_stats` WRITE;
/*!40000 ALTER TABLE `accel_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `accel_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actions` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `na_id` int(10) NOT NULL,
  `action` enum('execute') DEFAULT 'execute',
  `command` varchar(500) DEFAULT '',
  `status` enum('awaiting','fetched','replied') DEFAULT 'awaiting',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions`
--

LOCK TABLES `actions` WRITE;
/*!40000 ALTER TABLE `actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `node_id` int(11) DEFAULT NULL,
  `mesh_id` int(11) DEFAULT NULL,
  `ap_id` int(11) DEFAULT NULL,
  `ap_profile_id` int(11) DEFAULT NULL,
  `detected` timestamp NOT NULL DEFAULT current_timestamp(),
  `acknowledged` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `resolved` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_actions`
--

DROP TABLE IF EXISTS `ap_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_actions` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `ap_id` int(10) NOT NULL,
  `action` enum('execute','execute_and_reply') DEFAULT 'execute',
  `command` varchar(500) DEFAULT '',
  `status` enum('awaiting','fetched','replied') DEFAULT 'awaiting',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `reply` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_actions`
--

LOCK TABLES `ap_actions` WRITE;
/*!40000 ALTER TABLE `ap_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_ap_profile_entries`
--

DROP TABLE IF EXISTS `ap_ap_profile_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_ap_profile_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_id` int(11) NOT NULL,
  `ap_profile_entry_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ap_ap_profile_entries_ap_id` (`ap_id`),
  KEY `idx_ap_ap_profile_entries_ap_profile_entry_id` (`ap_profile_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_ap_profile_entries`
--

LOCK TABLES `ap_ap_profile_entries` WRITE;
/*!40000 ALTER TABLE `ap_ap_profile_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_ap_profile_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_connection_settings`
--

DROP TABLE IF EXISTS `ap_connection_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_connection_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_id` int(11) DEFAULT NULL,
  `grouping` varchar(25) DEFAULT NULL,
  `name` varchar(25) DEFAULT NULL,
  `value` varchar(40) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_connection_settings`
--

LOCK TABLES `ap_connection_settings` WRITE;
/*!40000 ALTER TABLE `ap_connection_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_connection_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_loads`
--

DROP TABLE IF EXISTS `ap_loads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_loads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_id` int(11) DEFAULT NULL,
  `mem_total` int(11) DEFAULT NULL,
  `mem_free` int(11) DEFAULT NULL,
  `uptime` varchar(255) DEFAULT NULL,
  `system_time` varchar(255) NOT NULL,
  `load_1` float(2,2) NOT NULL,
  `load_2` float(2,2) NOT NULL,
  `load_3` float(2,2) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_loads`
--

LOCK TABLES `ap_loads` WRITE;
/*!40000 ALTER TABLE `ap_loads` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_loads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_profile_entries`
--

DROP TABLE IF EXISTS `ap_profile_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_profile_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_profile_id` int(11) DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  `hidden` tinyint(1) NOT NULL DEFAULT 0,
  `isolate` tinyint(1) NOT NULL DEFAULT 0,
  `encryption` enum('none','wep','psk','psk2','wpa','wpa2','ppsk') DEFAULT 'none',
  `special_key` varchar(100) NOT NULL DEFAULT '',
  `auth_server` varchar(255) NOT NULL DEFAULT '',
  `auth_secret` varchar(255) NOT NULL DEFAULT '',
  `dynamic_vlan` tinyint(1) NOT NULL DEFAULT 0,
  `frequency_band` enum('both','two','five','five_upper','five_lower') DEFAULT 'both',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `chk_maxassoc` tinyint(1) NOT NULL DEFAULT 0,
  `maxassoc` int(6) DEFAULT 100,
  `macfilter` enum('disable','allow','deny') DEFAULT 'disable',
  `permanent_user_id` int(11) NOT NULL,
  `nasid` varchar(255) NOT NULL DEFAULT '',
  `auto_nasid` tinyint(1) NOT NULL DEFAULT 0,
  `accounting` tinyint(1) NOT NULL DEFAULT 1,
  `default_vlan` int(10) NOT NULL DEFAULT 100,
  `default_key` varchar(255) NOT NULL DEFAULT '12345678',
  `hotspot2_enable` tinyint(1) NOT NULL DEFAULT 0,
  `hotspot2_profile_id` int(11) DEFAULT NULL,
  `ieee802r` tinyint(1) NOT NULL DEFAULT 0,
  `mobility_domain` varchar(4) NOT NULL DEFAULT 'abba',
  `ft_over_ds` tinyint(1) NOT NULL DEFAULT 0,
  `ft_pskgenerate_local` tinyint(1) NOT NULL DEFAULT 1,
  `apply_to_all` tinyint(1) NOT NULL DEFAULT 1,
  `realm_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_profile_entries`
--

LOCK TABLES `ap_profile_entries` WRITE;
/*!40000 ALTER TABLE `ap_profile_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_profile_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_profile_entry_schedules`
--

DROP TABLE IF EXISTS `ap_profile_entry_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_profile_entry_schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_profile_entry_id` int(11) DEFAULT NULL,
  `action` enum('off','on') DEFAULT 'off',
  `mo` tinyint(1) NOT NULL DEFAULT 0,
  `tu` tinyint(1) NOT NULL DEFAULT 0,
  `we` tinyint(1) NOT NULL DEFAULT 0,
  `th` tinyint(1) NOT NULL DEFAULT 0,
  `fr` tinyint(1) NOT NULL DEFAULT 0,
  `sa` tinyint(1) NOT NULL DEFAULT 0,
  `su` tinyint(1) NOT NULL DEFAULT 0,
  `event_time` varchar(10) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_profile_entry_schedules`
--

LOCK TABLES `ap_profile_entry_schedules` WRITE;
/*!40000 ALTER TABLE `ap_profile_entry_schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_profile_entry_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_profile_exit_ap_profile_entries`
--

DROP TABLE IF EXISTS `ap_profile_exit_ap_profile_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_profile_exit_ap_profile_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_profile_exit_id` int(11) NOT NULL,
  `ap_profile_entry_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_profile_exit_ap_profile_entries`
--

LOCK TABLES `ap_profile_exit_ap_profile_entries` WRITE;
/*!40000 ALTER TABLE `ap_profile_exit_ap_profile_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_profile_exit_ap_profile_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_profile_exit_captive_portals`
--

DROP TABLE IF EXISTS `ap_profile_exit_captive_portals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_profile_exit_captive_portals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_profile_exit_id` int(11) NOT NULL,
  `radius_1` varchar(128) NOT NULL,
  `radius_2` varchar(128) NOT NULL DEFAULT '',
  `radius_secret` varchar(128) NOT NULL,
  `radius_nasid` varchar(128) NOT NULL,
  `uam_url` varchar(255) NOT NULL,
  `uam_secret` varchar(255) NOT NULL,
  `walled_garden` varchar(255) NOT NULL,
  `swap_octets` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `mac_auth` tinyint(1) NOT NULL DEFAULT 0,
  `proxy_enable` tinyint(1) NOT NULL DEFAULT 0,
  `proxy_ip` varchar(128) NOT NULL DEFAULT '',
  `proxy_port` int(11) NOT NULL DEFAULT 3128,
  `proxy_auth_username` varchar(128) NOT NULL DEFAULT '',
  `proxy_auth_password` varchar(128) NOT NULL DEFAULT '',
  `coova_optional` varchar(255) NOT NULL DEFAULT '',
  `dns_manual` tinyint(1) NOT NULL DEFAULT 0,
  `dns1` varchar(128) NOT NULL DEFAULT '',
  `dns2` varchar(128) NOT NULL DEFAULT '',
  `uamanydns` tinyint(1) NOT NULL DEFAULT 0,
  `dnsparanoia` tinyint(1) NOT NULL DEFAULT 0,
  `dnsdesk` tinyint(1) NOT NULL DEFAULT 0,
  `ap_profile_exit_upstream_id` int(11) DEFAULT NULL,
  `softflowd_enabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_profile_exit_captive_portals`
--

LOCK TABLES `ap_profile_exit_captive_portals` WRITE;
/*!40000 ALTER TABLE `ap_profile_exit_captive_portals` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_profile_exit_captive_portals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_profile_exit_pppoe_servers`
--

DROP TABLE IF EXISTS `ap_profile_exit_pppoe_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_profile_exit_pppoe_servers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ap_profile_exit_id` int(11) NOT NULL,
  `accel_profile_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_profile_exit_pppoe_servers`
--

LOCK TABLES `ap_profile_exit_pppoe_servers` WRITE;
/*!40000 ALTER TABLE `ap_profile_exit_pppoe_servers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_profile_exit_pppoe_servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_profile_exit_settings`
--

DROP TABLE IF EXISTS `ap_profile_exit_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_profile_exit_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_profile_exit_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_profile_exit_settings`
--

LOCK TABLES `ap_profile_exit_settings` WRITE;
/*!40000 ALTER TABLE `ap_profile_exit_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_profile_exit_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_profile_exits`
--

DROP TABLE IF EXISTS `ap_profile_exits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_profile_exits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_profile_id` int(11) DEFAULT NULL,
  `type` enum('bridge','tagged_bridge','nat','captive_portal','openvpn_bridge','tagged_bridge_l3','pppoe_server') DEFAULT NULL,
  `vlan` int(4) DEFAULT NULL,
  `auto_dynamic_client` tinyint(1) NOT NULL DEFAULT 0,
  `realm_list` varchar(128) NOT NULL DEFAULT '',
  `auto_login_page` tinyint(1) NOT NULL DEFAULT 0,
  `dynamic_detail_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `openvpn_server_id` int(11) DEFAULT NULL,
  `proto` enum('static','dhcp','dhcpv6') DEFAULT 'dhcp',
  `ipaddr` varchar(50) NOT NULL DEFAULT '',
  `netmask` varchar(50) NOT NULL DEFAULT '',
  `gateway` varchar(50) NOT NULL DEFAULT '',
  `dns_1` varchar(50) NOT NULL DEFAULT '',
  `dns_2` varchar(50) NOT NULL DEFAULT '',
  `apply_firewall_profile` tinyint(1) NOT NULL DEFAULT 0,
  `firewall_profile_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_profile_exits`
--

LOCK TABLES `ap_profile_exits` WRITE;
/*!40000 ALTER TABLE `ap_profile_exits` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_profile_exits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_profile_settings`
--

DROP TABLE IF EXISTS `ap_profile_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_profile_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_profile_id` int(11) DEFAULT NULL,
  `password` varchar(128) NOT NULL,
  `heartbeat_interval` int(5) NOT NULL DEFAULT 60,
  `heartbeat_dead_after` int(5) NOT NULL DEFAULT 600,
  `password_hash` varchar(100) NOT NULL DEFAULT '',
  `tz_name` varchar(128) NOT NULL DEFAULT 'America/New York',
  `tz_value` varchar(128) NOT NULL DEFAULT 'EST5EDT,M3.2.0,M11.1.0',
  `country` varchar(5) NOT NULL DEFAULT 'US',
  `gw_dhcp_timeout` int(5) NOT NULL DEFAULT 120,
  `gw_use_previous` tinyint(1) NOT NULL DEFAULT 1,
  `gw_auto_reboot` tinyint(1) NOT NULL DEFAULT 1,
  `gw_auto_reboot_time` int(5) NOT NULL DEFAULT 600,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `syslog1_ip` varchar(50) NOT NULL DEFAULT '',
  `syslog1_port` varchar(10) NOT NULL DEFAULT '514',
  `syslog2_ip` varchar(50) NOT NULL DEFAULT '',
  `syslog2_port` varchar(10) NOT NULL DEFAULT '514',
  `syslog3_ip` varchar(50) NOT NULL DEFAULT '',
  `syslog3_port` varchar(10) NOT NULL DEFAULT '514',
  `report_adv_enable` tinyint(1) NOT NULL DEFAULT 1,
  `report_adv_proto` enum('https','http') DEFAULT 'http',
  `report_adv_light` int(5) DEFAULT 60,
  `report_adv_full` int(5) DEFAULT 600,
  `report_adv_sampling` int(5) DEFAULT 60,
  `enable_schedules` tinyint(1) NOT NULL DEFAULT 0,
  `schedule_id` int(11) DEFAULT NULL,
  `vlan_enable` tinyint(1) NOT NULL DEFAULT 0,
  `vlan_range_or_list` enum('range','list') DEFAULT 'range',
  `vlan_start` int(10) NOT NULL DEFAULT 100,
  `vlan_end` int(10) NOT NULL DEFAULT 101,
  `vlan_list` varchar(255) NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_profile_settings`
--

LOCK TABLES `ap_profile_settings` WRITE;
/*!40000 ALTER TABLE `ap_profile_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_profile_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_profile_specifics`
--

DROP TABLE IF EXISTS `ap_profile_specifics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_profile_specifics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_profile_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_profile_specifics`
--

LOCK TABLES `ap_profile_specifics` WRITE;
/*!40000 ALTER TABLE `ap_profile_specifics` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_profile_specifics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_profiles`
--

DROP TABLE IF EXISTS `ap_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `enable_alerts` tinyint(1) NOT NULL DEFAULT 1,
  `enable_overviews` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_profiles`
--

LOCK TABLES `ap_profiles` WRITE;
/*!40000 ALTER TABLE `ap_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_static_entry_overrides`
--

DROP TABLE IF EXISTS `ap_static_entry_overrides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_static_entry_overrides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_id` int(11) NOT NULL,
  `ap_profile_entry_id` int(11) NOT NULL,
  `item` varchar(64) NOT NULL,
  `value` varchar(64) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_static_entry_overrides`
--

LOCK TABLES `ap_static_entry_overrides` WRITE;
/*!40000 ALTER TABLE `ap_static_entry_overrides` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_static_entry_overrides` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_stations`
--

DROP TABLE IF EXISTS `ap_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_stations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_id` int(11) DEFAULT NULL,
  `ap_profile_entry_id` int(11) DEFAULT NULL,
  `radio_number` tinyint(3) NOT NULL DEFAULT 0,
  `frequency_band` enum('two','five_lower','five_upper') DEFAULT 'two',
  `mac` varchar(17) NOT NULL,
  `tx_bytes` bigint(20) NOT NULL,
  `rx_bytes` bigint(20) NOT NULL,
  `tx_packets` bigint(20) NOT NULL,
  `rx_packets` bigint(20) NOT NULL,
  `tx_bitrate` int(11) NOT NULL,
  `rx_bitrate` int(11) NOT NULL,
  `authenticated` tinyint(2) NOT NULL DEFAULT 1,
  `authorized` tinyint(2) NOT NULL DEFAULT 1,
  `tdls_peer` tinyint(2) NOT NULL DEFAULT 1,
  `preamble` varchar(255) NOT NULL,
  `tx_failed` int(11) NOT NULL,
  `wmm_wme` tinyint(2) NOT NULL DEFAULT 0,
  `tx_retries` int(11) NOT NULL,
  `mfp` tinyint(2) NOT NULL DEFAULT 1,
  `signal_now` int(11) NOT NULL,
  `signal_avg` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ap_stations_ap_id` (`ap_id`),
  KEY `idx_ap_stations_ap_profile_entry_id` (`ap_profile_entry_id`),
  KEY `idx_ap_stations_modified` (`modified`)
) ENGINE=InnoDB AUTO_INCREMENT=583 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_stations`
--

LOCK TABLES `ap_stations` WRITE;
/*!40000 ALTER TABLE `ap_stations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_systems`
--

DROP TABLE IF EXISTS `ap_systems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_systems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7741 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_systems`
--

LOCK TABLES `ap_systems` WRITE;
/*!40000 ALTER TABLE `ap_systems` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_systems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_uptm_histories`
--

DROP TABLE IF EXISTS `ap_uptm_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_uptm_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_id` int(11) DEFAULT NULL,
  `ap_state` tinyint(1) NOT NULL DEFAULT 0,
  `state_datetime` datetime NOT NULL,
  `report_datetime` datetime NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_uptm_histories`
--

LOCK TABLES `ap_uptm_histories` WRITE;
/*!40000 ALTER TABLE `ap_uptm_histories` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_uptm_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_wifi_settings`
--

DROP TABLE IF EXISTS `ap_wifi_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ap_wifi_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=228 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_wifi_settings`
--

LOCK TABLES `ap_wifi_settings` WRITE;
/*!40000 ALTER TABLE `ap_wifi_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_wifi_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applied_fup_components`
--

DROP TABLE IF EXISTS `applied_fup_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applied_fup_components` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `profile_fup_component_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applied_fup_components`
--

LOCK TABLES `applied_fup_components` WRITE;
/*!40000 ALTER TABLE `applied_fup_components` DISABLE KEYS */;
/*!40000 ALTER TABLE `applied_fup_components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aps`
--

DROP TABLE IF EXISTS `aps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_profile_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `mac` varchar(255) NOT NULL,
  `hardware` varchar(255) DEFAULT NULL,
  `last_contact_from_ip` varchar(255) DEFAULT NULL,
  `last_contact` datetime DEFAULT NULL,
  `on_public_maps` tinyint(1) NOT NULL DEFAULT 0,
  `lat` double DEFAULT NULL,
  `lon` double DEFAULT NULL,
  `photo_file_name` varchar(128) NOT NULL DEFAULT 'logo.png',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `config_fetched` datetime DEFAULT NULL,
  `lan_proto` varchar(30) NOT NULL DEFAULT '',
  `lan_ip` varchar(30) NOT NULL DEFAULT '',
  `lan_gw` varchar(30) NOT NULL DEFAULT '',
  `gateway` enum('none','lan','3g','wifi','wifi_static','wifi_ppp','wifi_pppoe','wan_static','wan_ppp','wan_pppoe') DEFAULT 'none',
  `reboot_flag` tinyint(1) NOT NULL DEFAULT 0,
  `tree_tag_id` int(11) DEFAULT NULL,
  `enable_alerts` tinyint(1) NOT NULL DEFAULT 1,
  `enable_overviews` tinyint(1) NOT NULL DEFAULT 1,
  `enable_schedules` tinyint(1) NOT NULL DEFAULT 0,
  `schedule_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aps`
--

LOCK TABLES `aps` WRITE;
/*!40000 ALTER TABLE `aps` DISABLE KEYS */;
/*!40000 ALTER TABLE `aps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_mesh_daily_summaries`
--

DROP TABLE IF EXISTS `ar_mesh_daily_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_mesh_daily_summaries` (
  `id` int(11) NOT NULL,
  `mesh_id` int(11) NOT NULL,
  `the_date` date NOT NULL,
  `tree_tag_id` int(11) DEFAULT NULL,
  `mesh_name` varchar(255) DEFAULT NULL,
  `min_clients` bigint(20) DEFAULT 0,
  `max_clients` bigint(20) DEFAULT 0,
  `min_nodes` bigint(20) DEFAULT 0,
  `max_nodes` bigint(20) DEFAULT 0,
  `min_lv_nodes` bigint(20) DEFAULT 0,
  `max_lv_nodes` bigint(20) DEFAULT 0,
  `min_lv_nodes_down` bigint(20) DEFAULT 0,
  `max_lv_nodes_down` bigint(20) DEFAULT 0,
  `min_nodes_down` bigint(20) DEFAULT 0,
  `max_nodes_down` bigint(20) DEFAULT 0,
  `min_nodes_up` bigint(20) DEFAULT 0,
  `max_nodes_up` bigint(20) DEFAULT 0,
  `min_dual_radios` bigint(20) DEFAULT 0,
  `max_dual_radios` bigint(20) DEFAULT 0,
  `min_single_radios` bigint(20) DEFAULT 0,
  `max_single_radios` bigint(20) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_ar_mesh_daily_summaries_mesh_id_the_date` (`mesh_id`,`the_date`),
  KEY `idx_ar_mesh_daily_summaries_mesh_id` (`mesh_id`),
  KEY `idx_ar_mesh_daily_summaries_tree_tag_id` (`tree_tag_id`),
  KEY `idx_ar_mesh_daily_summaries_the_date` (`the_date`),
  KEY `idx_ar_mesh_daily_summaries_mesh_name` (`mesh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_mesh_daily_summaries`
--

LOCK TABLES `ar_mesh_daily_summaries` WRITE;
/*!40000 ALTER TABLE `ar_mesh_daily_summaries` DISABLE KEYS */;
/*!40000 ALTER TABLE `ar_mesh_daily_summaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_node_ibss_connections`
--

DROP TABLE IF EXISTS `ar_node_ibss_connections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_node_ibss_connections` (
  `id` int(11) NOT NULL,
  `node_id` int(11) DEFAULT NULL,
  `station_node_id` int(11) DEFAULT NULL,
  `vendor` varchar(255) DEFAULT NULL,
  `mac` varchar(17) NOT NULL,
  `tx_bytes` bigint(20) NOT NULL,
  `rx_bytes` bigint(20) NOT NULL,
  `tx_packets` int(11) NOT NULL,
  `rx_packets` int(11) NOT NULL,
  `tx_bitrate` int(11) NOT NULL,
  `rx_bitrate` int(11) NOT NULL,
  `tx_extra_info` varchar(255) NOT NULL,
  `rx_extra_info` varchar(255) NOT NULL,
  `authenticated` enum('yes','no') DEFAULT 'no',
  `authorized` enum('yes','no') DEFAULT 'no',
  `tdls_peer` varchar(255) NOT NULL,
  `preamble` enum('long','short') DEFAULT 'long',
  `tx_failed` int(11) NOT NULL,
  `inactive_time` int(11) NOT NULL,
  `WMM_WME` enum('yes','no') DEFAULT 'no',
  `tx_retries` int(11) NOT NULL,
  `MFP` enum('yes','no') DEFAULT 'no',
  `signal_now` int(11) NOT NULL,
  `signal_avg` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ar_node_ibss_connections_node_id` (`node_id`),
  KEY `idx_ar_node_ibss_connections_station_node_id` (`station_node_id`),
  KEY `idx_ar_node_ibss_connections_modified` (`modified`),
  KEY `idx_ar_node_ibss_connections_mac` (`mac`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_node_ibss_connections`
--

LOCK TABLES `ar_node_ibss_connections` WRITE;
/*!40000 ALTER TABLE `ar_node_ibss_connections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ar_node_ibss_connections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_node_stations`
--

DROP TABLE IF EXISTS `ar_node_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_node_stations` (
  `id` int(11) NOT NULL,
  `node_id` int(11) DEFAULT NULL,
  `mesh_entry_id` int(11) DEFAULT NULL,
  `vendor` varchar(255) DEFAULT NULL,
  `mac` varchar(17) NOT NULL,
  `tx_bytes` bigint(20) NOT NULL,
  `rx_bytes` bigint(20) NOT NULL,
  `tx_packets` int(11) NOT NULL,
  `rx_packets` int(11) NOT NULL,
  `tx_bitrate` int(11) NOT NULL,
  `rx_bitrate` int(11) NOT NULL,
  `tx_extra_info` varchar(255) NOT NULL,
  `rx_extra_info` varchar(255) NOT NULL,
  `authenticated` enum('yes','no') DEFAULT 'no',
  `authorized` enum('yes','no') DEFAULT 'no',
  `tdls_peer` varchar(255) NOT NULL,
  `preamble` enum('long','short') DEFAULT 'long',
  `tx_failed` int(11) NOT NULL,
  `inactive_time` int(11) NOT NULL,
  `WMM_WME` enum('yes','no') DEFAULT 'no',
  `tx_retries` int(11) NOT NULL,
  `MFP` enum('yes','no') DEFAULT 'no',
  `signal_now` int(11) NOT NULL,
  `signal_avg` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ar_node_stations_node_id` (`node_id`),
  KEY `idx_ar_node_stations_mesh_entry_id` (`mesh_entry_id`),
  KEY `idx_ar_node_stations_modified` (`modified`),
  KEY `idx_ar_node_stations_mac` (`mac`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_node_stations`
--

LOCK TABLES `ar_node_stations` WRITE;
/*!40000 ALTER TABLE `ar_node_stations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ar_node_stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_node_uptm_histories`
--

DROP TABLE IF EXISTS `ar_node_uptm_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_node_uptm_histories` (
  `id` int(11) NOT NULL,
  `node_id` int(11) DEFAULT NULL,
  `node_state` tinyint(1) NOT NULL DEFAULT 0,
  `state_datetime` datetime NOT NULL,
  `report_datetime` datetime NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ar_node_uptm_histories_node_id` (`node_id`),
  KEY `idx_ar_node_uptm_histories_modified` (`modified`),
  KEY `idx_ar_node_uptm_histories_node_state` (`node_state`),
  KEY `idx_ar_node_uptm_histories_state_datetime` (`state_datetime`),
  KEY `idx_ar_node_uptm_histories_report_datetime` (`report_datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_node_uptm_histories`
--

LOCK TABLES `ar_node_uptm_histories` WRITE;
/*!40000 ALTER TABLE `ar_node_uptm_histories` DISABLE KEYS */;
/*!40000 ALTER TABLE `ar_node_uptm_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auto_devices`
--

DROP TABLE IF EXISTS `auto_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auto_devices` (
  `mac` varchar(17) NOT NULL,
  `username` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`mac`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auto_devices`
--

LOCK TABLES `auto_devices` WRITE;
/*!40000 ALTER TABLE `auto_devices` DISABLE KEYS */;
/*!40000 ALTER TABLE `auto_devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checks`
--

DROP TABLE IF EXISTS `checks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `value` varchar(40) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checks`
--

LOCK TABLES `checks` WRITE;
/*!40000 ALTER TABLE `checks` DISABLE KEYS */;
/*!40000 ALTER TABLE `checks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_macs`
--

DROP TABLE IF EXISTS `client_macs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client_macs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mac` varchar(17) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mac` (`mac`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_macs`
--

LOCK TABLES `client_macs` WRITE;
/*!40000 ALTER TABLE `client_macs` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_macs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_admins`
--

DROP TABLE IF EXISTS `cloud_admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cloud_admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cloud_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_admins`
--

LOCK TABLES `cloud_admins` WRITE;
/*!40000 ALTER TABLE `cloud_admins` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_settings`
--

DROP TABLE IF EXISTS `cloud_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cloud_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cloud_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cloud_settings_cloud_id` (`cloud_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_settings`
--

LOCK TABLES `cloud_settings` WRITE;
/*!40000 ALTER TABLE `cloud_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clouds`
--

DROP TABLE IF EXISTS `clouds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clouds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `description` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `lat` decimal(11,8) DEFAULT NULL,
  `lng` decimal(11,8) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clouds`
--

LOCK TABLES `clouds` WRITE;
/*!40000 ALTER TABLE `clouds` DISABLE KEYS */;
/*!40000 ALTER TABLE `clouds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coa_requests`
--

DROP TABLE IF EXISTS `coa_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coa_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `multiple_gateways` tinyint(1) NOT NULL DEFAULT 0,
  `avp_json` text DEFAULT NULL,
  `result` text DEFAULT NULL,
  `status` enum('awaiting','fetched','replied') DEFAULT 'awaiting',
  `request_type` enum('coa','pod') DEFAULT 'coa',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coa_requests`
--

LOCK TABLES `coa_requests` WRITE;
/*!40000 ALTER TABLE `coa_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `coa_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `alpha_2_code` varchar(2) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=246 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (1,'Afghanistan','AF','2020-06-02 08:25:01','2020-06-02 08:25:01'),(2,'Aland Islands','AX','2020-06-02 08:25:01','2020-06-02 08:25:01'),(3,'Albania','AL','2020-06-02 08:25:01','2020-06-02 08:25:01'),(4,'Algeria','DZ','2020-06-02 08:25:01','2020-06-02 08:25:01'),(5,'American Samoa','AS','2020-06-02 08:25:01','2020-06-02 08:25:01'),(6,'Andorra','AD','2020-06-02 08:25:01','2020-06-02 08:25:01'),(7,'Angola','AO','2020-06-02 08:25:01','2020-06-02 08:25:01'),(8,'Anguilla','AI','2020-06-02 08:25:01','2020-06-02 08:25:01'),(9,'Antarctica','AQ','2020-06-02 08:25:01','2020-06-02 08:25:01'),(10,'Antigua And Barbuda','AG','2020-06-02 08:25:01','2020-06-02 08:25:01'),(11,'Argentina','AR','2020-06-02 08:25:01','2020-06-02 08:25:01'),(12,'Armenia','AM','2020-06-02 08:25:01','2020-06-02 08:25:01'),(13,'Aruba','AW','2020-06-02 08:25:01','2020-06-02 08:25:01'),(14,'Australia','AU','2020-06-02 08:25:01','2020-06-02 08:25:01'),(15,'Austria','AT','2020-06-02 08:25:01','2020-06-02 08:25:01'),(16,'Azerbaijan','AZ','2020-06-02 08:25:01','2020-06-02 08:25:01'),(17,'Bahamas','BS','2020-06-02 08:25:01','2020-06-02 08:25:01'),(18,'Bahrain','BH','2020-06-02 08:25:01','2020-06-02 08:25:01'),(19,'Bangladesh','BD','2020-06-02 08:25:01','2020-06-02 08:25:01'),(20,'Barbados','BB','2020-06-02 08:25:01','2020-06-02 08:25:01'),(21,'Belarus','BY','2020-06-02 08:25:01','2020-06-02 08:25:01'),(22,'Belgium','BE','2020-06-02 08:25:01','2020-06-02 08:25:01'),(23,'Belize','BZ','2020-06-02 08:25:01','2020-06-02 08:25:01'),(24,'Benin','BJ','2020-06-02 08:25:01','2020-06-02 08:25:01'),(25,'Bermuda','BM','2020-06-02 08:25:01','2020-06-02 08:25:01'),(26,'Bhutan','BT','2020-06-02 08:25:01','2020-06-02 08:25:01'),(27,'Bolivia','BO','2020-06-02 08:25:01','2020-06-02 08:25:01'),(28,'Bosnia And Herzegovina','BA','2020-06-02 08:25:01','2020-06-02 08:25:01'),(29,'Botswana','BW','2020-06-02 08:25:01','2020-06-02 08:25:01'),(30,'Bouvet Island','BV','2020-06-02 08:25:01','2020-06-02 08:25:01'),(31,'Brazil','BR','2020-06-02 08:25:01','2020-06-02 08:25:01'),(32,'British Indian Ocean Territory','IO','2020-06-02 08:25:01','2020-06-02 08:25:01'),(33,'Brunei Darussalam','BN','2020-06-02 08:25:01','2020-06-02 08:25:01'),(34,'Bulgaria','BG','2020-06-02 08:25:01','2020-06-02 08:25:01'),(35,'Burkina Faso','BF','2020-06-02 08:25:01','2020-06-02 08:25:01'),(36,'Burundi','BI','2020-06-02 08:25:01','2020-06-02 08:25:01'),(37,'Cambodia','KH','2020-06-02 08:25:01','2020-06-02 08:25:01'),(38,'Cameroon','CM','2020-06-02 08:25:01','2020-06-02 08:25:01'),(39,'Canada','CA','2020-06-02 08:25:01','2020-06-02 08:25:01'),(40,'Cape Verde','CV','2020-06-02 08:25:01','2020-06-02 08:25:01'),(41,'Cayman Islands','KY','2020-06-02 08:25:01','2020-06-02 08:25:01'),(42,'Central African Republic','CF','2020-06-02 08:25:01','2020-06-02 08:25:01'),(43,'Chad','TD','2020-06-02 08:25:01','2020-06-02 08:25:01'),(44,'Chile','CL','2020-06-02 08:25:01','2020-06-02 08:25:01'),(45,'China','CN','2020-06-02 08:25:01','2020-06-02 08:25:01'),(46,'Christmas Island','CX','2020-06-02 08:25:01','2020-06-02 08:25:01'),(47,'Cocos (Keeling) Islands','CC','2020-06-02 08:25:01','2020-06-02 08:25:01'),(48,'Colombia','CO','2020-06-02 08:25:01','2020-06-02 08:25:01'),(49,'Comoros','KM','2020-06-02 08:25:01','2020-06-02 08:25:01'),(50,'Congo','CG','2020-06-02 08:25:01','2020-06-02 08:25:01'),(51,'Congo, Democratic Republic','CD','2020-06-02 08:25:01','2020-06-02 08:25:01'),(52,'Cook Islands','CK','2020-06-02 08:25:01','2020-06-02 08:25:01'),(53,'Costa Rica','CR','2020-06-02 08:25:01','2020-06-02 08:25:01'),(54,'Cote D\'Ivoire','CI','2020-06-02 08:25:01','2020-06-02 08:25:01'),(55,'Croatia','HR','2020-06-02 08:25:01','2020-06-02 08:25:01'),(56,'Cuba','CU','2020-06-02 08:25:01','2020-06-02 08:25:01'),(57,'Cyprus','CY','2020-06-02 08:25:01','2020-06-02 08:25:01'),(58,'Czech Republic','CZ','2020-06-02 08:25:01','2020-06-02 08:25:01'),(59,'Denmark','DK','2020-06-02 08:25:01','2020-06-02 08:25:01'),(60,'Djibouti','DJ','2020-06-02 08:25:01','2020-06-02 08:25:01'),(61,'Dominica','DM','2020-06-02 08:25:01','2020-06-02 08:25:01'),(62,'Dominican Republic','DO','2020-06-02 08:25:01','2020-06-02 08:25:01'),(63,'Ecuador','EC','2020-06-02 08:25:01','2020-06-02 08:25:01'),(64,'Egypt','EG','2020-06-02 08:25:01','2020-06-02 08:25:01'),(65,'El Salvador','SV','2020-06-02 08:25:01','2020-06-02 08:25:01'),(66,'Equatorial Guinea','GQ','2020-06-02 08:25:01','2020-06-02 08:25:01'),(67,'Eritrea','ER','2020-06-02 08:25:01','2020-06-02 08:25:01'),(68,'Estonia','EE','2020-06-02 08:25:01','2020-06-02 08:25:01'),(69,'Ethiopia','ET','2020-06-02 08:25:01','2020-06-02 08:25:01'),(70,'Falkland Islands (Malvinas)','FK','2020-06-02 08:25:01','2020-06-02 08:25:01'),(71,'Faroe Islands','FO','2020-06-02 08:25:01','2020-06-02 08:25:01'),(72,'Fiji','FJ','2020-06-02 08:25:01','2020-06-02 08:25:01'),(73,'Finland','FI','2020-06-02 08:25:01','2020-06-02 08:25:01'),(74,'France','FR','2020-06-02 08:25:01','2020-06-02 08:25:01'),(75,'French Guiana','GF','2020-06-02 08:25:01','2020-06-02 08:25:01'),(76,'French Polynesia','PF','2020-06-02 08:25:01','2020-06-02 08:25:01'),(77,'French Southern Territories','TF','2020-06-02 08:25:01','2020-06-02 08:25:01'),(78,'Gabon','GA','2020-06-02 08:25:01','2020-06-02 08:25:01'),(79,'Gambia','GM','2020-06-02 08:25:01','2020-06-02 08:25:01'),(80,'Georgia','GE','2020-06-02 08:25:01','2020-06-02 08:25:01'),(81,'Germany','DE','2020-06-02 08:25:01','2020-06-02 08:25:01'),(82,'Ghana','GH','2020-06-02 08:25:01','2020-06-02 08:25:01'),(83,'Gibraltar','GI','2020-06-02 08:25:01','2020-06-02 08:25:01'),(84,'Greece','GR','2020-06-02 08:25:01','2020-06-02 08:25:01'),(85,'Greenland','GL','2020-06-02 08:25:01','2020-06-02 08:25:01'),(86,'Grenada','GD','2020-06-02 08:25:01','2020-06-02 08:25:01'),(87,'Guadeloupe','GP','2020-06-02 08:25:01','2020-06-02 08:25:01'),(88,'Guam','GU','2020-06-02 08:25:01','2020-06-02 08:25:01'),(89,'Guatemala','GT','2020-06-02 08:25:01','2020-06-02 08:25:01'),(90,'Guernsey','GG','2020-06-02 08:25:01','2020-06-02 08:25:01'),(91,'Guinea','GN','2020-06-02 08:25:01','2020-06-02 08:25:01'),(92,'Guinea-Bissau','GW','2020-06-02 08:25:01','2020-06-02 08:25:01'),(93,'Guyana','GY','2020-06-02 08:25:01','2020-06-02 08:25:01'),(94,'Haiti','HT','2020-06-02 08:25:01','2020-06-02 08:25:01'),(95,'Heard Island & Mcdonald Islands','HM','2020-06-02 08:25:01','2020-06-02 08:25:01'),(96,'Holy See (Vatican City State)','VA','2020-06-02 08:25:01','2020-06-02 08:25:01'),(97,'Honduras','HN','2020-06-02 08:25:01','2020-06-02 08:25:01'),(98,'Hong Kong','HK','2020-06-02 08:25:01','2020-06-02 08:25:01'),(99,'Hungary','HU','2020-06-02 08:25:01','2020-06-02 08:25:01'),(100,'Iceland','IS','2020-06-02 08:25:01','2020-06-02 08:25:01'),(101,'India','IN','2020-06-02 08:25:01','2020-06-02 08:25:01'),(102,'Indonesia','ID','2020-06-02 08:25:01','2020-06-02 08:25:01'),(103,'Iran, Islamic Republic Of','IR','2020-06-02 08:25:01','2020-06-02 08:25:01'),(104,'Iraq','IQ','2020-06-02 08:25:01','2020-06-02 08:25:01'),(105,'Ireland','IE','2020-06-02 08:25:01','2020-06-02 08:25:01'),(106,'Isle Of Man','IM','2020-06-02 08:25:01','2020-06-02 08:25:01'),(107,'Israel','IL','2020-06-02 08:25:01','2020-06-02 08:25:01'),(108,'Italy','IT','2020-06-02 08:25:01','2020-06-02 08:25:01'),(109,'Jamaica','JM','2020-06-02 08:25:01','2020-06-02 08:25:01'),(110,'Japan','JP','2020-06-02 08:25:01','2020-06-02 08:25:01'),(111,'Jersey','JE','2020-06-02 08:25:01','2020-06-02 08:25:01'),(112,'Jordan','JO','2020-06-02 08:25:02','2020-06-02 08:25:02'),(113,'Kazakhstan','KZ','2020-06-02 08:25:02','2020-06-02 08:25:02'),(114,'Kenya','KE','2020-06-02 08:25:02','2020-06-02 08:25:02'),(115,'Kiribati','KI','2020-06-02 08:25:02','2020-06-02 08:25:02'),(116,'Korea','KR','2020-06-02 08:25:02','2020-06-02 08:25:02'),(117,'Kuwait','KW','2020-06-02 08:25:02','2020-06-02 08:25:02'),(118,'Kyrgyzstan','KG','2020-06-02 08:25:02','2020-06-02 08:25:02'),(119,'Lao People\'s Democratic Republic','LA','2020-06-02 08:25:02','2020-06-02 08:25:02'),(120,'Latvia','LV','2020-06-02 08:25:02','2020-06-02 08:25:02'),(121,'Lebanon','LB','2020-06-02 08:25:02','2020-06-02 08:25:02'),(122,'Lesotho','LS','2020-06-02 08:25:02','2020-06-02 08:25:02'),(123,'Liberia','LR','2020-06-02 08:25:02','2020-06-02 08:25:02'),(124,'Libyan Arab Jamahiriya','LY','2020-06-02 08:25:02','2020-06-02 08:25:02'),(125,'Liechtenstein','LI','2020-06-02 08:25:02','2020-06-02 08:25:02'),(126,'Lithuania','LT','2020-06-02 08:25:02','2020-06-02 08:25:02'),(127,'Luxembourg','LU','2020-06-02 08:25:02','2020-06-02 08:25:02'),(128,'Macao','MO','2020-06-02 08:25:02','2020-06-02 08:25:02'),(129,'Macedonia','MK','2020-06-02 08:25:02','2020-06-02 08:25:02'),(130,'Madagascar','MG','2020-06-02 08:25:02','2020-06-02 08:25:02'),(131,'Malawi','MW','2020-06-02 08:25:02','2020-06-02 08:25:02'),(132,'Malaysia','MY','2020-06-02 08:25:02','2020-06-02 08:25:02'),(133,'Maldives','MV','2020-06-02 08:25:02','2020-06-02 08:25:02'),(134,'Mali','ML','2020-06-02 08:25:02','2020-06-02 08:25:02'),(135,'Malta','MT','2020-06-02 08:25:02','2020-06-02 08:25:02'),(136,'Marshall Islands','MH','2020-06-02 08:25:02','2020-06-02 08:25:02'),(137,'Martinique','MQ','2020-06-02 08:25:02','2020-06-02 08:25:02'),(138,'Mauritania','MR','2020-06-02 08:25:02','2020-06-02 08:25:02'),(139,'Mauritius','MU','2020-06-02 08:25:02','2020-06-02 08:25:02'),(140,'Mayotte','YT','2020-06-02 08:25:02','2020-06-02 08:25:02'),(141,'Mexico','MX','2020-06-02 08:25:02','2020-06-02 08:25:02'),(142,'Micronesia, Federated States Of','FM','2020-06-02 08:25:02','2020-06-02 08:25:02'),(143,'Moldova','MD','2020-06-02 08:25:02','2020-06-02 08:25:02'),(144,'Monaco','MC','2020-06-02 08:25:02','2020-06-02 08:25:02'),(145,'Mongolia','MN','2020-06-02 08:25:02','2020-06-02 08:25:02'),(146,'Montenegro','ME','2020-06-02 08:25:02','2020-06-02 08:25:02'),(147,'Montserrat','MS','2020-06-02 08:25:02','2020-06-02 08:25:02'),(148,'Morocco','MA','2020-06-02 08:25:02','2020-06-02 08:25:02'),(149,'Mozambique','MZ','2020-06-02 08:25:02','2020-06-02 08:25:02'),(150,'Myanmar','MM','2020-06-02 08:25:02','2020-06-02 08:25:02'),(151,'Namibia','NA','2020-06-02 08:25:02','2020-06-02 08:25:02'),(152,'Nauru','NR','2020-06-02 08:25:02','2020-06-02 08:25:02'),(153,'Nepal','NP','2020-06-02 08:25:02','2020-06-02 08:25:02'),(154,'Netherlands','NL','2020-06-02 08:25:02','2020-06-02 08:25:02'),(155,'Netherlands Antilles','AN','2020-06-02 08:25:02','2020-06-02 08:25:02'),(156,'New Caledonia','NC','2020-06-02 08:25:02','2020-06-02 08:25:02'),(157,'New Zealand','NZ','2020-06-02 08:25:02','2020-06-02 08:25:02'),(158,'Nicaragua','NI','2020-06-02 08:25:02','2020-06-02 08:25:02'),(159,'Niger','NE','2020-06-02 08:25:02','2020-06-02 08:25:02'),(160,'Nigeria','NG','2020-06-02 08:25:02','2020-06-02 08:25:02'),(161,'Niue','NU','2020-06-02 08:25:02','2020-06-02 08:25:02'),(162,'Norfolk Island','NF','2020-06-02 08:25:02','2020-06-02 08:25:02'),(163,'Northern Mariana Islands','MP','2020-06-02 08:25:02','2020-06-02 08:25:02'),(164,'Norway','NO','2020-06-02 08:25:02','2020-06-02 08:25:02'),(165,'Oman','OM','2020-06-02 08:25:02','2020-06-02 08:25:02'),(166,'Pakistan','PK','2020-06-02 08:25:02','2020-06-02 08:25:02'),(167,'Palau','PW','2020-06-02 08:25:02','2020-06-02 08:25:02'),(168,'Palestinian Territory, Occupied','PS','2020-06-02 08:25:02','2020-06-02 08:25:02'),(169,'Panama','PA','2020-06-02 08:25:02','2020-06-02 08:25:02'),(170,'Papua New Guinea','PG','2020-06-02 08:25:02','2020-06-02 08:25:02'),(171,'Paraguay','PY','2020-06-02 08:25:02','2020-06-02 08:25:02'),(172,'Peru','PE','2020-06-02 08:25:02','2020-06-02 08:25:02'),(173,'Philippines','PH','2020-06-02 08:25:02','2020-06-02 08:25:02'),(174,'Pitcairn','PN','2020-06-02 08:25:02','2020-06-02 08:25:02'),(175,'Poland','PL','2020-06-02 08:25:02','2020-06-02 08:25:02'),(176,'Portugal','PT','2020-06-02 08:25:02','2020-06-02 08:25:02'),(177,'Puerto Rico','PR','2020-06-02 08:25:02','2020-06-02 08:25:02'),(178,'Qatar','QA','2020-06-02 08:25:02','2020-06-02 08:25:02'),(179,'Reunion','RE','2020-06-02 08:25:02','2020-06-02 08:25:02'),(180,'Romania','RO','2020-06-02 08:25:02','2020-06-02 08:25:02'),(181,'Russian Federation','RU','2020-06-02 08:25:02','2020-06-02 08:25:02'),(182,'Rwanda','RW','2020-06-02 08:25:02','2020-06-02 08:25:02'),(183,'Saint Barthelemy','BL','2020-06-02 08:25:03','2020-06-02 08:25:03'),(184,'Saint Helena','SH','2020-06-02 08:25:03','2020-06-02 08:25:03'),(185,'Saint Kitts And Nevis','KN','2020-06-02 08:25:03','2020-06-02 08:25:03'),(186,'Saint Lucia','LC','2020-06-02 08:25:03','2020-06-02 08:25:03'),(187,'Saint Martin','MF','2020-06-02 08:25:03','2020-06-02 08:25:03'),(188,'Saint Pierre And Miquelon','PM','2020-06-02 08:25:03','2020-06-02 08:25:03'),(189,'Saint Vincent And Grenadines','VC','2020-06-02 08:25:03','2020-06-02 08:25:03'),(190,'Samoa','WS','2020-06-02 08:25:03','2020-06-02 08:25:03'),(191,'San Marino','SM','2020-06-02 08:25:03','2020-06-02 08:25:03'),(192,'Sao Tome And Principe','ST','2020-06-02 08:25:03','2020-06-02 08:25:03'),(193,'Saudi Arabia','SA','2020-06-02 08:25:03','2020-06-02 08:25:03'),(194,'Senegal','SN','2020-06-02 08:25:03','2020-06-02 08:25:03'),(195,'Serbia','RS','2020-06-02 08:25:03','2020-06-02 08:25:03'),(196,'Seychelles','SC','2020-06-02 08:25:03','2020-06-02 08:25:03'),(197,'Sierra Leone','SL','2020-06-02 08:25:03','2020-06-02 08:25:03'),(198,'Singapore','SG','2020-06-02 08:25:03','2020-06-02 08:25:03'),(199,'Slovakia','SK','2020-06-02 08:25:03','2020-06-02 08:25:03'),(200,'Slovenia','SI','2020-06-02 08:25:03','2020-06-02 08:25:03'),(201,'Solomon Islands','SB','2020-06-02 08:25:03','2020-06-02 08:25:03'),(202,'Somalia','SO','2020-06-02 08:25:03','2020-06-02 08:25:03'),(203,'South Africa','ZA','2020-06-02 08:25:03','2020-06-02 08:25:03'),(204,'South Georgia And Sandwich Isl.','GS','2020-06-02 08:25:03','2020-06-02 08:25:03'),(205,'Spain','ES','2020-06-02 08:25:03','2020-06-02 08:25:03'),(206,'Sri Lanka','LK','2020-06-02 08:25:03','2020-06-02 08:25:03'),(207,'Sudan','SD','2020-06-02 08:25:03','2020-06-02 08:25:03'),(208,'Suriname','SR','2020-06-02 08:25:03','2020-06-02 08:25:03'),(209,'Svalbard And Jan Mayen','SJ','2020-06-02 08:25:03','2020-06-02 08:25:03'),(210,'Swaziland','SZ','2020-06-02 08:25:03','2020-06-02 08:25:03'),(211,'Sweden','SE','2020-06-02 08:25:03','2020-06-02 08:25:03'),(212,'Switzerland','CH','2020-06-02 08:25:03','2020-06-02 08:25:03'),(213,'Syrian Arab Republic','SY','2020-06-02 08:25:03','2020-06-02 08:25:03'),(214,'Taiwan','TW','2020-06-02 08:25:03','2020-06-02 08:25:03'),(215,'Tajikistan','TJ','2020-06-02 08:25:03','2020-06-02 08:25:03'),(216,'Tanzania','TZ','2020-06-02 08:25:03','2020-06-02 08:25:03'),(217,'Thailand','TH','2020-06-02 08:25:03','2020-06-02 08:25:03'),(218,'Timor-Leste','TL','2020-06-02 08:25:03','2020-06-02 08:25:03'),(219,'Togo','TG','2020-06-02 08:25:03','2020-06-02 08:25:03'),(220,'Tokelau','TK','2020-06-02 08:25:03','2020-06-02 08:25:03'),(221,'Tonga','TO','2020-06-02 08:25:03','2020-06-02 08:25:03'),(222,'Trinidad And Tobago','TT','2020-06-02 08:25:03','2020-06-02 08:25:03'),(223,'Tunisia','TN','2020-06-02 08:25:03','2020-06-02 08:25:03'),(224,'Turkey','TR','2020-06-02 08:25:03','2020-06-02 08:25:03'),(225,'Turkmenistan','TM','2020-06-02 08:25:03','2020-06-02 08:25:03'),(226,'Turks And Caicos Islands','TC','2020-06-02 08:25:03','2020-06-02 08:25:03'),(227,'Tuvalu','TV','2020-06-02 08:25:03','2020-06-02 08:25:03'),(228,'Uganda','UG','2020-06-02 08:25:03','2020-06-02 08:25:03'),(229,'Ukraine','UA','2020-06-02 08:25:03','2020-06-02 08:25:03'),(230,'United Arab Emirates','AE','2020-06-02 08:25:03','2020-06-02 08:25:03'),(231,'United Kingdom','GB','2020-06-02 08:25:03','2020-06-02 08:25:03'),(232,'United States','US','2020-06-02 08:25:03','2020-06-02 08:25:03'),(233,'United States Outlying Islands','UM','2020-06-02 08:25:03','2020-06-02 08:25:03'),(234,'Uruguay','UY','2020-06-02 08:25:03','2020-06-02 08:25:03'),(235,'Uzbekistan','UZ','2020-06-02 08:25:03','2020-06-02 08:25:03'),(236,'Vanuatu','VU','2020-06-02 08:25:03','2020-06-02 08:25:03'),(237,'Venezuela','VE','2020-06-02 08:25:03','2020-06-02 08:25:03'),(238,'Viet Nam','VN','2020-06-02 08:25:03','2020-06-02 08:25:03'),(239,'Virgin Islands, British','VG','2020-06-02 08:25:03','2020-06-02 08:25:03'),(240,'Virgin Islands, U.S.','VI','2020-06-02 08:25:03','2020-06-02 08:25:03'),(241,'Wallis And Futuna','WF','2020-06-02 08:25:03','2020-06-02 08:25:03'),(242,'Western Sahara','EH','2020-06-02 08:25:03','2020-06-02 08:25:03'),(243,'Yemen','YE','2020-06-02 08:25:03','2020-06-02 08:25:03'),(244,'Zambia','ZM','2020-06-02 08:25:03','2020-06-02 08:25:03'),(245,'Zimbabwe','ZW','2020-06-02 08:25:03','2020-06-02 08:25:03');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_collector_otps`
--

DROP TABLE IF EXISTS `data_collector_otps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_collector_otps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_collector_id` int(11) NOT NULL,
  `status` enum('otp_awaiting','otp_confirmed') DEFAULT 'otp_awaiting',
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_collector_otps`
--

LOCK TABLES `data_collector_otps` WRITE;
/*!40000 ALTER TABLE `data_collector_otps` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_collector_otps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_collectors`
--

DROP TABLE IF EXISTS `data_collectors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_collectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_detail_id` int(11) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `mac` varchar(36) NOT NULL,
  `cp_mac` varchar(36) DEFAULT NULL,
  `public_ip` varchar(36) DEFAULT NULL,
  `nasid` varchar(255) DEFAULT NULL,
  `ssid` varchar(255) DEFAULT NULL,
  `is_mobile` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `phone` varchar(36) NOT NULL DEFAULT '',
  `dn` varchar(36) NOT NULL DEFAULT '',
  `phone_opt_in` tinyint(1) NOT NULL DEFAULT 0,
  `email_opt_in` tinyint(1) NOT NULL DEFAULT 0,
  `first_name` char(50) NOT NULL DEFAULT '',
  `last_name` char(50) NOT NULL DEFAULT '',
  `gender` enum('male','female','not_recorded') DEFAULT 'not_recorded',
  `birthday` datetime DEFAULT NULL,
  `company` char(50) NOT NULL DEFAULT '',
  `address` char(50) NOT NULL DEFAULT '',
  `city` char(50) NOT NULL DEFAULT '',
  `country` char(50) NOT NULL DEFAULT '',
  `room` char(50) NOT NULL DEFAULT '',
  `custom1` char(50) NOT NULL DEFAULT '',
  `custom2` char(50) NOT NULL DEFAULT '',
  `custom3` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_collectors`
--

LOCK TABLES `data_collectors` WRITE;
/*!40000 ALTER TABLE `data_collectors` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_collectors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `last_accept_time` datetime DEFAULT NULL,
  `last_reject_time` datetime DEFAULT NULL,
  `last_accept_nas` varchar(128) DEFAULT NULL,
  `last_reject_nas` varchar(128) DEFAULT NULL,
  `last_reject_message` varchar(255) DEFAULT NULL,
  `permanent_user_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `perc_time_used` int(6) DEFAULT NULL,
  `perc_data_used` int(6) DEFAULT NULL,
  `data_used` bigint(20) DEFAULT NULL,
  `data_cap` bigint(20) DEFAULT NULL,
  `time_used` int(12) DEFAULT NULL,
  `time_cap` int(12) DEFAULT NULL,
  `time_cap_type` enum('hard','soft') DEFAULT 'soft',
  `data_cap_type` enum('hard','soft') DEFAULT 'soft',
  `realm` varchar(100) NOT NULL DEFAULT '',
  `realm_id` int(11) DEFAULT NULL,
  `profile` varchar(100) NOT NULL DEFAULT '',
  `profile_id` int(11) DEFAULT NULL,
  `from_date` datetime DEFAULT NULL,
  `to_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_client_macs`
--

DROP TABLE IF EXISTS `dynamic_client_macs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_client_macs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_client_id` int(11) DEFAULT NULL,
  `client_mac_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dc_mac` (`dynamic_client_id`,`client_mac_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_client_macs`
--

LOCK TABLES `dynamic_client_macs` WRITE;
/*!40000 ALTER TABLE `dynamic_client_macs` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_client_macs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_client_realms`
--

DROP TABLE IF EXISTS `dynamic_client_realms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_client_realms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_client_id` int(11) NOT NULL,
  `realm_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_client_realms`
--

LOCK TABLES `dynamic_client_realms` WRITE;
/*!40000 ALTER TABLE `dynamic_client_realms` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_client_realms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_client_settings`
--

DROP TABLE IF EXISTS `dynamic_client_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_client_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_client_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_client_settings`
--

LOCK TABLES `dynamic_client_settings` WRITE;
/*!40000 ALTER TABLE `dynamic_client_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_client_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_client_states`
--

DROP TABLE IF EXISTS `dynamic_client_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_client_states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_client_id` char(36) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_client_states`
--

LOCK TABLES `dynamic_client_states` WRITE;
/*!40000 ALTER TABLE `dynamic_client_states` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_client_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_clients`
--

DROP TABLE IF EXISTS `dynamic_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `nasidentifier` varchar(128) NOT NULL DEFAULT '',
  `calledstationid` varchar(128) NOT NULL DEFAULT '',
  `last_contact` datetime DEFAULT NULL,
  `last_contact_ip` varchar(128) NOT NULL DEFAULT '',
  `timezone` varchar(255) NOT NULL DEFAULT '',
  `monitor` enum('off','heartbeat','socket') DEFAULT 'off',
  `session_auto_close` tinyint(1) NOT NULL DEFAULT 0,
  `session_dead_time` int(5) NOT NULL DEFAULT 3600,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `on_public_maps` tinyint(1) NOT NULL DEFAULT 0,
  `lat` double DEFAULT NULL,
  `lon` double DEFAULT NULL,
  `photo_file_name` varchar(128) NOT NULL DEFAULT 'logo.png',
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `data_limit_active` tinyint(1) NOT NULL DEFAULT 0,
  `data_limit_amount` float(14,3) NOT NULL DEFAULT 1.000,
  `data_limit_unit` enum('kb','mb','gb','tb') DEFAULT 'mb',
  `data_limit_reset_on` int(3) NOT NULL DEFAULT 1,
  `data_limit_reset_hour` int(3) NOT NULL DEFAULT 0,
  `data_limit_reset_minute` int(3) NOT NULL DEFAULT 0,
  `data_used` bigint(20) DEFAULT NULL,
  `data_limit_cap` enum('hard','soft') DEFAULT 'hard',
  `daily_data_limit_active` tinyint(1) NOT NULL DEFAULT 0,
  `daily_data_limit_amount` float(14,3) NOT NULL DEFAULT 1.000,
  `daily_data_limit_unit` enum('kb','mb','gb','tb') DEFAULT 'mb',
  `daily_data_limit_cap` enum('hard','soft') DEFAULT 'hard',
  `daily_data_limit_reset_hour` int(3) NOT NULL DEFAULT 0,
  `daily_data_limit_reset_minute` int(3) NOT NULL DEFAULT 0,
  `daily_data_used` bigint(20) DEFAULT NULL,
  `default_vlan` int(10) NOT NULL DEFAULT 100,
  `default_key` varchar(255) NOT NULL DEFAULT '12345678',
  `type` varchar(30) DEFAULT 'other',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_clients`
--

LOCK TABLES `dynamic_clients` WRITE;
/*!40000 ALTER TABLE `dynamic_clients` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_detail_ctcs`
--

DROP TABLE IF EXISTS `dynamic_detail_ctcs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_detail_ctcs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_detail_id` int(11) DEFAULT NULL,
  `connect_check` tinyint(1) NOT NULL DEFAULT 0,
  `connect_username` char(50) NOT NULL DEFAULT '',
  `connect_suffix` char(50) NOT NULL DEFAULT 'nasid',
  `connect_delay` int(3) NOT NULL DEFAULT 0,
  `connect_only` tinyint(1) NOT NULL DEFAULT 0,
  `cust_info_check` tinyint(1) NOT NULL DEFAULT 0,
  `ci_resupply_interval` int(4) NOT NULL DEFAULT 0,
  `ci_first_name` tinyint(1) NOT NULL DEFAULT 0,
  `ci_first_name_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_last_name` tinyint(1) NOT NULL DEFAULT 0,
  `ci_last_name_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_email` tinyint(1) NOT NULL DEFAULT 0,
  `ci_email_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_email_opt_in` tinyint(1) NOT NULL DEFAULT 0,
  `ci_email_opt_in_txt` char(50) NOT NULL DEFAULT 'Send Promotional Email',
  `ci_gender` tinyint(1) NOT NULL DEFAULT 0,
  `ci_gender_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_birthday` tinyint(1) NOT NULL DEFAULT 0,
  `ci_birthday_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_company` tinyint(1) NOT NULL DEFAULT 0,
  `ci_company_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_address` tinyint(1) NOT NULL DEFAULT 0,
  `ci_address_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_city` tinyint(1) NOT NULL DEFAULT 0,
  `ci_city_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_country` tinyint(1) NOT NULL DEFAULT 0,
  `ci_country_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_phone` tinyint(1) NOT NULL DEFAULT 0,
  `ci_phone_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_phone_opt_in` tinyint(1) NOT NULL DEFAULT 0,
  `ci_phone_opt_in_txt` char(50) NOT NULL DEFAULT 'Send Promotional SMS',
  `ci_room` tinyint(1) NOT NULL DEFAULT 0,
  `ci_room_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_custom1` tinyint(1) NOT NULL DEFAULT 0,
  `ci_custom1_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_custom1_txt` char(50) NOT NULL DEFAULT 'Custom One',
  `ci_custom2` tinyint(1) NOT NULL DEFAULT 0,
  `ci_custom2_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_custom2_txt` char(50) NOT NULL DEFAULT 'Custom Two',
  `ci_custom3` tinyint(1) NOT NULL DEFAULT 0,
  `ci_custom3_required` tinyint(1) NOT NULL DEFAULT 0,
  `ci_custom3_txt` char(50) NOT NULL DEFAULT 'Custom Three',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `ci_phone_otp` tinyint(1) NOT NULL DEFAULT 0,
  `ci_email_otp` tinyint(1) NOT NULL DEFAULT 0,
  `permanent_user_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_detail_ctcs`
--

LOCK TABLES `dynamic_detail_ctcs` WRITE;
/*!40000 ALTER TABLE `dynamic_detail_ctcs` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_detail_ctcs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_detail_languages`
--

DROP TABLE IF EXISTS `dynamic_detail_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_detail_languages` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `iso_code` varchar(2) DEFAULT NULL,
  `rtl` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_detail_languages`
--

LOCK TABLES `dynamic_detail_languages` WRITE;
/*!40000 ALTER TABLE `dynamic_detail_languages` DISABLE KEYS */;
INSERT INTO `dynamic_detail_languages` VALUES (5,'English','en',0,'2021-03-29 14:00:47','2021-03-29 14:00:47'),(6,'German','de',0,'2021-03-29 14:05:36','2021-03-29 14:05:36');
/*!40000 ALTER TABLE `dynamic_detail_languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_detail_mobiles`
--

DROP TABLE IF EXISTS `dynamic_detail_mobiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_detail_mobiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_detail_id` int(11) DEFAULT NULL,
  `mobile_only` tinyint(1) NOT NULL DEFAULT 0,
  `content` text NOT NULL DEFAULT '',
  `android_enable` tinyint(1) NOT NULL DEFAULT 0,
  `android_href` varchar(255) NOT NULL DEFAULT '',
  `android_text` varchar(255) NOT NULL DEFAULT '',
  `android_content` text NOT NULL DEFAULT '',
  `apple_enable` tinyint(1) NOT NULL DEFAULT 0,
  `apple_href` varchar(255) NOT NULL DEFAULT '',
  `apple_text` varchar(255) NOT NULL DEFAULT '',
  `apple_content` text NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_detail_mobiles`
--

LOCK TABLES `dynamic_detail_mobiles` WRITE;
/*!40000 ALTER TABLE `dynamic_detail_mobiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_detail_mobiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_detail_prelogins`
--

DROP TABLE IF EXISTS `dynamic_detail_prelogins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_detail_prelogins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mac` varchar(64) NOT NULL DEFAULT '',
  `nasid` varchar(64) NOT NULL DEFAULT '',
  `dynamic_detail_id` int(11) NOT NULL,
  `completed` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_detail_prelogins`
--

LOCK TABLES `dynamic_detail_prelogins` WRITE;
/*!40000 ALTER TABLE `dynamic_detail_prelogins` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_detail_prelogins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_detail_social_logins`
--

DROP TABLE IF EXISTS `dynamic_detail_social_logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_detail_social_logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_detail_id` int(11) NOT NULL,
  `profile_id` int(11) NOT NULL,
  `realm_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `enable` tinyint(1) NOT NULL DEFAULT 0,
  `record_info` tinyint(1) NOT NULL DEFAULT 0,
  `special_key` varchar(100) NOT NULL DEFAULT '',
  `secret` varchar(100) NOT NULL DEFAULT '',
  `type` enum('voucher','user') DEFAULT 'voucher',
  `extra_name` varchar(100) NOT NULL DEFAULT '',
  `extra_value` varchar(100) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_detail_social_logins`
--

LOCK TABLES `dynamic_detail_social_logins` WRITE;
/*!40000 ALTER TABLE `dynamic_detail_social_logins` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_detail_social_logins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_detail_trans_keys`
--

DROP TABLE IF EXISTS `dynamic_detail_trans_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_detail_trans_keys` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `dynamic_detail_id` int(11) DEFAULT -1,
  `name` varchar(50) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_detail_trans_keys`
--

LOCK TABLES `dynamic_detail_trans_keys` WRITE;
/*!40000 ALTER TABLE `dynamic_detail_trans_keys` DISABLE KEYS */;
INSERT INTO `dynamic_detail_trans_keys` VALUES (5,-1,'ok_button','2021-03-29 14:01:07','2021-03-29 14:01:07');
/*!40000 ALTER TABLE `dynamic_detail_trans_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_detail_translations`
--

DROP TABLE IF EXISTS `dynamic_detail_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_detail_translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_detail_language_id` int(11) DEFAULT NULL,
  `dynamic_detail_trans_key_id` int(11) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_detail_translations`
--

LOCK TABLES `dynamic_detail_translations` WRITE;
/*!40000 ALTER TABLE `dynamic_detail_translations` DISABLE KEYS */;
INSERT INTO `dynamic_detail_translations` VALUES (1,5,5,'OK','2021-03-29 14:01:39','2021-03-29 14:01:39');
/*!40000 ALTER TABLE `dynamic_detail_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_details`
--

DROP TABLE IF EXISTS `dynamic_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `icon_file_name` varchar(128) NOT NULL DEFAULT 'logo.png',
  `phone` varchar(14) NOT NULL DEFAULT '',
  `fax` varchar(14) NOT NULL DEFAULT '',
  `cell` varchar(14) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `url` varchar(128) NOT NULL DEFAULT '',
  `street_no` char(10) NOT NULL DEFAULT '',
  `street` char(50) NOT NULL DEFAULT '',
  `town_suburb` char(50) NOT NULL DEFAULT '',
  `city` char(50) NOT NULL DEFAULT '',
  `country` char(50) NOT NULL DEFAULT '',
  `lat` double DEFAULT NULL,
  `lon` double DEFAULT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `t_c_check` tinyint(1) NOT NULL DEFAULT 0,
  `t_c_url` char(50) NOT NULL DEFAULT '',
  `redirect_check` tinyint(1) NOT NULL DEFAULT 0,
  `redirect_url` char(200) NOT NULL DEFAULT '',
  `slideshow_check` tinyint(1) NOT NULL DEFAULT 0,
  `seconds_per_slide` int(3) NOT NULL DEFAULT 30,
  `connect_check` tinyint(1) NOT NULL DEFAULT 0,
  `connect_username` char(50) NOT NULL DEFAULT '',
  `connect_suffix` char(50) NOT NULL DEFAULT 'nasid',
  `connect_delay` int(3) NOT NULL DEFAULT 0,
  `connect_only` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `user_login_check` tinyint(1) NOT NULL DEFAULT 1,
  `voucher_login_check` tinyint(1) NOT NULL DEFAULT 0,
  `auto_suffix_check` tinyint(1) NOT NULL DEFAULT 0,
  `auto_suffix` char(200) NOT NULL DEFAULT '',
  `usage_show_check` tinyint(1) NOT NULL DEFAULT 1,
  `usage_refresh_interval` int(3) NOT NULL DEFAULT 120,
  `theme` char(200) NOT NULL DEFAULT 'Default',
  `register_users` tinyint(1) NOT NULL DEFAULT 0,
  `lost_password` tinyint(1) NOT NULL DEFAULT 0,
  `social_enable` tinyint(1) NOT NULL DEFAULT 0,
  `social_temp_permanent_user_id` int(11) DEFAULT NULL,
  `coova_desktop_url` varchar(255) NOT NULL DEFAULT '',
  `coova_mobile_url` varchar(255) NOT NULL DEFAULT '',
  `mikrotik_desktop_url` varchar(255) NOT NULL DEFAULT '',
  `mikrotik_mobile_url` varchar(255) NOT NULL DEFAULT '',
  `default_language` varchar(255) NOT NULL DEFAULT '',
  `realm_id` int(11) DEFAULT NULL,
  `profile_id` int(11) DEFAULT NULL,
  `reg_auto_suffix_check` tinyint(1) NOT NULL DEFAULT 0,
  `reg_auto_suffix` char(200) NOT NULL DEFAULT '',
  `reg_mac_check` tinyint(1) NOT NULL DEFAULT 0,
  `reg_auto_add` tinyint(1) NOT NULL DEFAULT 0,
  `reg_email` tinyint(1) NOT NULL DEFAULT 0,
  `slideshow_enforce_watching` tinyint(1) NOT NULL DEFAULT 1,
  `slideshow_enforce_seconds` int(4) NOT NULL DEFAULT 10,
  `available_languages` varchar(255) NOT NULL DEFAULT '',
  `ctc_require_email` tinyint(1) NOT NULL DEFAULT 0,
  `ctc_resupply_email_interval` int(4) NOT NULL DEFAULT 0,
  `show_screen_delay` int(4) NOT NULL DEFAULT 0,
  `show_logo` tinyint(1) NOT NULL DEFAULT 1,
  `show_name` tinyint(1) NOT NULL DEFAULT 1,
  `name_colour` varchar(255) NOT NULL DEFAULT '',
  `lost_password_method` enum('email','sms') DEFAULT 'email',
  `ctc_phone_opt_in` tinyint(1) NOT NULL DEFAULT 0,
  `ctc_phone_opt_in_txt` varchar(200) NOT NULL DEFAULT 'Send Promotional SMS',
  `ctc_email_opt_in` tinyint(1) NOT NULL DEFAULT 0,
  `ctc_email_opt_in_txt` varchar(200) NOT NULL DEFAULT 'Send Promotional Email',
  `chilli_json_unavailable` tinyint(1) NOT NULL DEFAULT 0,
  `chilli_use_chap` tinyint(1) NOT NULL DEFAULT 0,
  `reg_otp_sms` tinyint(1) NOT NULL DEFAULT 0,
  `reg_otp_email` tinyint(1) NOT NULL DEFAULT 0,
  `permanent_user_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_details`
--

LOCK TABLES `dynamic_details` WRITE;
/*!40000 ALTER TABLE `dynamic_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_pages`
--

DROP TABLE IF EXISTS `dynamic_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_detail_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL DEFAULT '',
  `content` text NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `dynamic_detail_language_id` int(11) DEFAULT NULL,
  `language` varchar(20) DEFAULT 'en',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_pages`
--

LOCK TABLES `dynamic_pages` WRITE;
/*!40000 ALTER TABLE `dynamic_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_pairs`
--

DROP TABLE IF EXISTS `dynamic_pairs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_pairs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `value` varchar(64) NOT NULL DEFAULT '',
  `priority` int(11) NOT NULL DEFAULT 1,
  `dynamic_detail_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_pairs`
--

LOCK TABLES `dynamic_pairs` WRITE;
/*!40000 ALTER TABLE `dynamic_pairs` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_pairs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_photo_translations`
--

DROP TABLE IF EXISTS `dynamic_photo_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_photo_translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_detail_language_id` int(11) DEFAULT NULL,
  `dynamic_photo_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_photo_translations`
--

LOCK TABLES `dynamic_photo_translations` WRITE;
/*!40000 ALTER TABLE `dynamic_photo_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_photo_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_photos`
--

DROP TABLE IF EXISTS `dynamic_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_detail_id` int(11) NOT NULL,
  `title` varchar(128) NOT NULL DEFAULT '',
  `description` varchar(250) NOT NULL DEFAULT '',
  `url` varchar(250) NOT NULL DEFAULT '',
  `file_name` varchar(128) NOT NULL DEFAULT 'logo.png',
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `fit` enum('stretch_to_fit','horizontal','vertical','original','dynamic') DEFAULT 'stretch_to_fit',
  `background_color` varchar(7) NOT NULL DEFAULT 'ffffff',
  `slide_duration` int(4) NOT NULL DEFAULT 10,
  `include_title` tinyint(1) NOT NULL DEFAULT 1,
  `include_description` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_photos`
--

LOCK TABLES `dynamic_photos` WRITE;
/*!40000 ALTER TABLE `dynamic_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_histories`
--

DROP TABLE IF EXISTS `email_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cloud_id` int(11) NOT NULL,
  `recipient` varchar(100) DEFAULT NULL,
  `reason` varchar(25) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_histories`
--

LOCK TABLES `email_histories` WRITE;
/*!40000 ALTER TABLE `email_histories` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_messages`
--

DROP TABLE IF EXISTS `email_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `title` varchar(64) NOT NULL DEFAULT '',
  `message` varchar(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_messages`
--

LOCK TABLES `email_messages` WRITE;
/*!40000 ALTER TABLE `email_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `firewall_apps`
--

DROP TABLE IF EXISTS `firewall_apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `firewall_apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(16) DEFAULT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `fa_code` char(64) DEFAULT '&#xf085;',
  `elements` text NOT NULL DEFAULT '',
  `comment` varchar(100) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `firewall_apps`
--

LOCK TABLES `firewall_apps` WRITE;
/*!40000 ALTER TABLE `firewall_apps` DISABLE KEYS */;
/*!40000 ALTER TABLE `firewall_apps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `firewall_profile_entries`
--

DROP TABLE IF EXISTS `firewall_profile_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `firewall_profile_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firewall_profile_id` int(11) DEFAULT NULL,
  `action` enum('block','allow','limit') DEFAULT 'block',
  `category` enum('app','app_group','domain','ip_address','region','internet','local_network') DEFAULT 'domain',
  `domain` varchar(100) DEFAULT NULL,
  `ip_address` varchar(100) DEFAULT NULL,
  `schedule` enum('always','every_day','every_week','one_time','custom') DEFAULT 'always',
  `mo` tinyint(1) NOT NULL DEFAULT 0,
  `tu` tinyint(1) NOT NULL DEFAULT 0,
  `we` tinyint(1) NOT NULL DEFAULT 0,
  `th` tinyint(1) NOT NULL DEFAULT 0,
  `fr` tinyint(1) NOT NULL DEFAULT 0,
  `sa` tinyint(1) NOT NULL DEFAULT 0,
  `su` tinyint(1) NOT NULL DEFAULT 0,
  `start_time` int(10) NOT NULL DEFAULT 0,
  `end_time` int(10) NOT NULL DEFAULT 0,
  `one_time_date` datetime DEFAULT NULL,
  `bw_up` int(11) DEFAULT NULL,
  `bw_down` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `firewall_profile_entries`
--

LOCK TABLES `firewall_profile_entries` WRITE;
/*!40000 ALTER TABLE `firewall_profile_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `firewall_profile_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `firewall_profile_entry_firewall_apps`
--

DROP TABLE IF EXISTS `firewall_profile_entry_firewall_apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `firewall_profile_entry_firewall_apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firewall_profile_entry_id` int(11) NOT NULL,
  `firewall_app_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `firewall_profile_entry_firewall_apps`
--

LOCK TABLES `firewall_profile_entry_firewall_apps` WRITE;
/*!40000 ALTER TABLE `firewall_profile_entry_firewall_apps` DISABLE KEYS */;
/*!40000 ALTER TABLE `firewall_profile_entry_firewall_apps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `firewall_profiles`
--

DROP TABLE IF EXISTS `firewall_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `firewall_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(64) DEFAULT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `firewall_profiles`
--

LOCK TABLES `firewall_profiles` WRITE;
/*!40000 ALTER TABLE `firewall_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `firewall_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forward_lookups`
--

DROP TABLE IF EXISTS `forward_lookups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forward_lookups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fqdn` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forward_lookups`
--

LOCK TABLES `forward_lookups` WRITE;
/*!40000 ALTER TABLE `forward_lookups` DISABLE KEYS */;
/*!40000 ALTER TABLE `forward_lookups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (8,'Administrators','2012-12-10 13:13:09','2012-12-10 13:13:09'),(9,'Access Providers','2012-12-10 13:13:19','2012-12-10 13:13:19'),(10,'Permanent Users','2012-12-10 13:13:28','2012-12-10 13:13:28');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hardware_radios`
--

DROP TABLE IF EXISTS `hardware_radios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hardware_radios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `radio_number` tinyint(2) NOT NULL DEFAULT 0,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  `txpower` tinyint(2) NOT NULL DEFAULT 1,
  `include_beacon_int` tinyint(1) NOT NULL DEFAULT 0,
  `beacon_int` int(11) NOT NULL DEFAULT 100,
  `include_distance` tinyint(1) NOT NULL DEFAULT 0,
  `distance` int(7) NOT NULL DEFAULT 100,
  `ht_capab` varchar(255) DEFAULT NULL,
  `mesh` tinyint(1) NOT NULL DEFAULT 1,
  `ap` tinyint(1) NOT NULL DEFAULT 1,
  `config` tinyint(1) NOT NULL DEFAULT 1,
  `hardware_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `band` enum('2g','5g') DEFAULT '2g',
  `mode` enum('a','g','n','ac','ax') DEFAULT 'n',
  `width` enum('20','40','80','160') DEFAULT '20',
  `cell_density` enum('0','1','2','3') DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hardware_radios`
--

LOCK TABLES `hardware_radios` WRITE;
/*!40000 ALTER TABLE `hardware_radios` DISABLE KEYS */;
INSERT INTO `hardware_radios` VALUES (46,0,0,30,0,100,0,100,'',0,1,1,15,'2022-08-10 11:22:50','2022-08-10 11:22:50','2g','n','20','0'),(47,1,0,20,0,100,0,100,'',1,1,0,15,'2022-08-10 11:22:50','2022-08-10 11:22:50','5g','ac','80','0'),(48,0,0,22,0,100,0,100,'',1,1,1,14,'2022-08-11 05:06:16','2022-08-11 05:06:16','2g','n','20','0'),(53,0,0,21,0,100,0,100,'',1,1,0,22,'2022-08-22 10:43:44','2022-08-22 10:43:44','5g','ac','80','0'),(54,1,0,21,0,100,0,100,'',0,1,1,22,'2022-08-22 10:43:44','2022-08-22 10:43:44','2g','n','20','0'),(55,0,0,20,0,100,0,100,'',0,1,1,23,'2022-08-27 09:22:08','2022-08-27 09:22:08','2g','n','20','0'),(56,1,0,20,0,100,0,100,'',1,1,0,23,'2022-08-27 09:22:08','2022-08-27 09:22:08','5g','ac','80','0'),(57,0,0,20,0,100,0,100,'',0,1,1,24,'2022-08-27 09:28:48','2022-08-27 09:28:48','2g','ax','20','0'),(58,1,0,20,0,100,0,100,'',1,1,0,24,'2022-08-27 09:28:48','2022-08-27 09:28:48','5g','ac','80','0'),(59,0,0,23,0,100,0,100,'',0,1,1,25,'2022-08-27 09:31:55','2022-08-27 09:31:55','2g','n','20','0'),(60,1,0,23,0,100,0,100,'',1,1,0,25,'2022-08-27 09:31:55','2022-08-27 09:31:55','5g','n','40','0'),(61,0,0,21,0,100,0,100,'',0,1,1,26,'2022-08-27 09:35:12','2022-08-27 09:35:12','2g','n','20','0'),(62,1,0,21,0,100,0,100,'',1,1,0,26,'2022-08-27 09:35:12','2022-08-27 09:35:12','5g','n','40','0');
/*!40000 ALTER TABLE `hardware_radios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hardwares`
--

DROP TABLE IF EXISTS `hardwares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hardwares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `vendor` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `fw_id` varchar(20) NOT NULL,
  `for_mesh` tinyint(1) NOT NULL DEFAULT 1,
  `for_ap` tinyint(1) NOT NULL DEFAULT 1,
  `wan` varchar(20) NOT NULL DEFAULT 'eth1',
  `lan` varchar(20) DEFAULT NULL,
  `radio_count` tinyint(2) NOT NULL DEFAULT 0,
  `photo_file_name` varchar(128) NOT NULL DEFAULT 'hardware.png',
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hardwares`
--

LOCK TABLES `hardwares` WRITE;
/*!40000 ALTER TABLE `hardwares` DISABLE KEYS */;
INSERT INTO `hardwares` VALUES (14,'Xiaomi 4C 300M','Xiaomi','4C 300M','xiaomi_4c',1,1,'eth0.1','eth0.2',1,'14_xiaomi_4c.png',-1,'2022-08-10 11:19:15','2022-08-11 05:06:16'),(15,'Xiaomi 4A 100M','Xiaomi','4A 100M','xiaomi_4a_100m',1,1,'eth0.1','eth0.2',2,'15_xiaomi_4a_100m.png',-1,'2022-08-10 11:21:42','2022-08-10 11:23:09'),(22,'TP Link EAP225 Outdoor 3','TP Link','EAP225 Outdoor 3','tl_eap225_3_o',1,1,'eth0','',2,'hardware.png',-1,'2022-08-22 10:43:05','2022-08-22 10:43:44'),(23,'Xiaomi 4A 1G','Xiaomi','4A 1G','xiaomi_4a_1g',1,1,'wan','lan1 lan2',2,'hardware.png',-1,'2022-08-27 09:21:07','2022-08-27 09:22:08'),(24,'TOTOLink X5000R','TOTOLink','X5000R','t_x5000r',1,1,'wan','lan1 lan2 lan3 lan4',2,'hardware.png',-1,'2022-08-27 09:27:30','2022-08-27 09:28:48'),(25,'ARUBA AP-105','ARUBA','AP-105','aruba_ap_105',1,1,'eth0','',2,'hardware.png',-1,'2022-08-27 09:29:36','2022-08-27 09:31:55'),(26,'MERAKI MR24','MERAKI','MR24','meraki_mr24',1,1,'eth0','',2,'hardware.png',-1,'2022-08-27 09:33:46','2022-08-27 09:35:12');
/*!40000 ALTER TABLE `hardwares` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home_server_pools`
--

DROP TABLE IF EXISTS `home_server_pools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `home_server_pools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type` enum('fail-over','load-balance','client-balance','client-port-balance','keyed-balance') DEFAULT 'fail-over',
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home_server_pools`
--

LOCK TABLES `home_server_pools` WRITE;
/*!40000 ALTER TABLE `home_server_pools` DISABLE KEYS */;
/*!40000 ALTER TABLE `home_server_pools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home_servers`
--

DROP TABLE IF EXISTS `home_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `home_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('auth','acct','auth+acct','coa') DEFAULT 'auth+acct',
  `ipaddr` varchar(255) NOT NULL DEFAULT '',
  `port` int(5) NOT NULL DEFAULT 1812,
  `secret` varchar(255) NOT NULL DEFAULT '',
  `response_window` int(5) NOT NULL DEFAULT 20,
  `zombie_period` int(5) NOT NULL DEFAULT 40,
  `revive_interval` int(5) NOT NULL DEFAULT 120,
  `home_server_pool_id` int(11) DEFAULT NULL,
  `accept_coa` tinyint(1) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home_servers`
--

LOCK TABLES `home_servers` WRITE;
/*!40000 ALTER TABLE `home_servers` DISABLE KEYS */;
/*!40000 ALTER TABLE `home_servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `isp_specifics`
--

DROP TABLE IF EXISTS `isp_specifics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `isp_specifics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cloud_id` int(11) DEFAULT NULL,
  `name` varchar(40) DEFAULT NULL,
  `region` varchar(40) DEFAULT NULL,
  `field1` varchar(40) DEFAULT NULL,
  `field2` varchar(40) DEFAULT NULL,
  `field3` varchar(40) DEFAULT NULL,
  `field4` varchar(40) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `isp_specifics`
--

LOCK TABLES `isp_specifics` WRITE;
/*!40000 ALTER TABLE `isp_specifics` DISABLE KEYS */;
/*!40000 ALTER TABLE `isp_specifics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `languages` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `iso_code` varchar(2) DEFAULT NULL,
  `rtl` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `languages`
--

LOCK TABLES `languages` WRITE;
/*!40000 ALTER TABLE `languages` DISABLE KEYS */;
INSERT INTO `languages` VALUES (4,'English','en',0,'2012-10-05 04:55:28','2012-10-06 07:58:26');
/*!40000 ALTER TABLE `languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mac_actions`
--

DROP TABLE IF EXISTS `mac_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mac_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cloud_id` int(11) DEFAULT NULL,
  `mesh_id` int(11) DEFAULT NULL,
  `ap_profile_id` int(11) DEFAULT NULL,
  `client_mac_id` int(11) DEFAULT NULL,
  `action` enum('block','limit','firewall') DEFAULT 'block',
  `bw_up` int(11) DEFAULT NULL,
  `bw_down` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `firewall_profile_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mac_actions`
--

LOCK TABLES `mac_actions` WRITE;
/*!40000 ALTER TABLE `mac_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `mac_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mac_aliases`
--

DROP TABLE IF EXISTS `mac_aliases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mac_aliases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mac` char(20) DEFAULT NULL,
  `alias` char(255) DEFAULT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mac_aliases`
--

LOCK TABLES `mac_aliases` WRITE;
/*!40000 ALTER TABLE `mac_aliases` DISABLE KEYS */;
/*!40000 ALTER TABLE `mac_aliases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mac_usages`
--

DROP TABLE IF EXISTS `mac_usages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mac_usages` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `mac` varchar(17) NOT NULL,
  `username` varchar(255) NOT NULL DEFAULT '',
  `data_used` bigint(20) DEFAULT NULL,
  `data_cap` bigint(20) DEFAULT NULL,
  `time_used` int(12) DEFAULT NULL,
  `time_cap` int(12) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mac_usages`
--

LOCK TABLES `mac_usages` WRITE;
/*!40000 ALTER TABLE `mac_usages` DISABLE KEYS */;
/*!40000 ALTER TABLE `mac_usages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesh_daily_summaries`
--

DROP TABLE IF EXISTS `mesh_daily_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_daily_summaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_id` int(11) NOT NULL,
  `the_date` date NOT NULL,
  `tree_tag_id` int(11) DEFAULT NULL,
  `mesh_name` varchar(255) DEFAULT NULL,
  `min_clients` bigint(20) DEFAULT 0,
  `max_clients` bigint(20) DEFAULT 0,
  `min_nodes` bigint(20) DEFAULT 0,
  `max_nodes` bigint(20) DEFAULT 0,
  `min_lv_nodes` bigint(20) DEFAULT 0,
  `max_lv_nodes` bigint(20) DEFAULT 0,
  `min_lv_nodes_down` bigint(20) DEFAULT 0,
  `max_lv_nodes_down` bigint(20) DEFAULT 0,
  `min_nodes_down` bigint(20) DEFAULT 0,
  `max_nodes_down` bigint(20) DEFAULT 0,
  `min_nodes_up` bigint(20) DEFAULT 0,
  `max_nodes_up` bigint(20) DEFAULT 0,
  `min_dual_radios` bigint(20) DEFAULT 0,
  `max_dual_radios` bigint(20) DEFAULT 0,
  `min_single_radios` bigint(20) DEFAULT 0,
  `max_single_radios` bigint(20) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_mesh_daily_summaries_mesh_id_the_date` (`mesh_id`,`the_date`),
  KEY `idx_mesh_daily_summaries_mesh_id` (`mesh_id`),
  KEY `idx_mesh_daily_summaries_tree_tag_id` (`tree_tag_id`),
  KEY `idx_mesh_daily_summaries_the_date` (`the_date`),
  KEY `idx_mesh_daily_summaries_mesh_name` (`mesh_name`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesh_daily_summaries`
--

LOCK TABLES `mesh_daily_summaries` WRITE;
/*!40000 ALTER TABLE `mesh_daily_summaries` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesh_daily_summaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesh_entries`
--

DROP TABLE IF EXISTS `mesh_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_id` int(11) DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  `hidden` tinyint(1) NOT NULL DEFAULT 0,
  `isolate` tinyint(1) NOT NULL DEFAULT 0,
  `apply_to_all` tinyint(1) NOT NULL DEFAULT 0,
  `encryption` enum('none','wep','psk','psk2','wpa','wpa2','ppsk') DEFAULT 'none',
  `special_key` varchar(100) NOT NULL DEFAULT '',
  `auth_server` varchar(255) NOT NULL DEFAULT '',
  `auth_secret` varchar(255) NOT NULL DEFAULT '',
  `dynamic_vlan` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `chk_maxassoc` tinyint(1) NOT NULL DEFAULT 0,
  `maxassoc` int(6) DEFAULT 100,
  `macfilter` enum('disable','allow','deny') DEFAULT 'disable',
  `permanent_user_id` int(11) NOT NULL,
  `nasid` varchar(255) NOT NULL DEFAULT '',
  `auto_nasid` tinyint(1) NOT NULL DEFAULT 0,
  `accounting` tinyint(1) NOT NULL DEFAULT 1,
  `frequency_band` enum('both','two','five','five_upper','five_lower') DEFAULT 'both',
  `default_vlan` int(10) NOT NULL DEFAULT 100,
  `default_key` varchar(255) NOT NULL DEFAULT '12345678',
  `hotspot2_enable` tinyint(1) NOT NULL DEFAULT 0,
  `hotspot2_profile_id` int(11) DEFAULT NULL,
  `ieee802r` tinyint(1) NOT NULL DEFAULT 0,
  `mobility_domain` varchar(4) NOT NULL DEFAULT 'abba',
  `ft_over_ds` tinyint(1) NOT NULL DEFAULT 0,
  `ft_pskgenerate_local` tinyint(1) NOT NULL DEFAULT 1,
  `realm_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_mesh_entries_mesh_id` (`mesh_id`),
  KEY `idx_mesh_entries_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesh_entries`
--

LOCK TABLES `mesh_entries` WRITE;
/*!40000 ALTER TABLE `mesh_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesh_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesh_entry_schedules`
--

DROP TABLE IF EXISTS `mesh_entry_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_entry_schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_entry_id` int(11) DEFAULT NULL,
  `action` enum('off','on') DEFAULT 'off',
  `mo` tinyint(1) NOT NULL DEFAULT 0,
  `tu` tinyint(1) NOT NULL DEFAULT 0,
  `we` tinyint(1) NOT NULL DEFAULT 0,
  `th` tinyint(1) NOT NULL DEFAULT 0,
  `fr` tinyint(1) NOT NULL DEFAULT 0,
  `sa` tinyint(1) NOT NULL DEFAULT 0,
  `su` tinyint(1) NOT NULL DEFAULT 0,
  `event_time` varchar(10) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesh_entry_schedules`
--

LOCK TABLES `mesh_entry_schedules` WRITE;
/*!40000 ALTER TABLE `mesh_entry_schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesh_entry_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesh_exit_captive_portals`
--

DROP TABLE IF EXISTS `mesh_exit_captive_portals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_exit_captive_portals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_exit_id` int(11) NOT NULL,
  `radius_1` varchar(128) NOT NULL,
  `radius_2` varchar(128) NOT NULL DEFAULT '',
  `radius_secret` varchar(128) NOT NULL,
  `radius_nasid` varchar(128) NOT NULL,
  `uam_url` varchar(255) NOT NULL,
  `uam_secret` varchar(255) NOT NULL,
  `walled_garden` varchar(255) NOT NULL,
  `swap_octets` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `mac_auth` tinyint(1) NOT NULL DEFAULT 0,
  `proxy_enable` tinyint(1) NOT NULL DEFAULT 0,
  `proxy_ip` varchar(128) NOT NULL DEFAULT '',
  `proxy_port` int(11) NOT NULL DEFAULT 3128,
  `proxy_auth_username` varchar(128) NOT NULL DEFAULT '',
  `proxy_auth_password` varchar(128) NOT NULL DEFAULT '',
  `coova_optional` varchar(255) NOT NULL DEFAULT '',
  `dns_manual` tinyint(1) NOT NULL DEFAULT 0,
  `dns1` varchar(128) NOT NULL DEFAULT '',
  `dns2` varchar(128) NOT NULL DEFAULT '',
  `uamanydns` tinyint(1) NOT NULL DEFAULT 0,
  `dnsparanoia` tinyint(1) NOT NULL DEFAULT 0,
  `dnsdesk` tinyint(1) NOT NULL DEFAULT 0,
  `mesh_exit_upstream_id` int(11) DEFAULT NULL,
  `softflowd_enabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_mesh_exit_captive_portals_mesh_exit_id` (`mesh_exit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesh_exit_captive_portals`
--

LOCK TABLES `mesh_exit_captive_portals` WRITE;
/*!40000 ALTER TABLE `mesh_exit_captive_portals` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesh_exit_captive_portals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesh_exit_mesh_entries`
--

DROP TABLE IF EXISTS `mesh_exit_mesh_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_exit_mesh_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_exit_id` int(11) NOT NULL,
  `mesh_entry_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_mesh_exit_mesh_entries_mesh_exit_id` (`mesh_exit_id`),
  KEY `idx_mesh_exit_mesh_entries_mesh_entry_id` (`mesh_entry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesh_exit_mesh_entries`
--

LOCK TABLES `mesh_exit_mesh_entries` WRITE;
/*!40000 ALTER TABLE `mesh_exit_mesh_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesh_exit_mesh_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesh_exit_pppoe_servers`
--

DROP TABLE IF EXISTS `mesh_exit_pppoe_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_exit_pppoe_servers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mesh_exit_id` int(11) NOT NULL,
  `accel_profile_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesh_exit_pppoe_servers`
--

LOCK TABLES `mesh_exit_pppoe_servers` WRITE;
/*!40000 ALTER TABLE `mesh_exit_pppoe_servers` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesh_exit_pppoe_servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesh_exit_settings`
--

DROP TABLE IF EXISTS `mesh_exit_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_exit_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_exit_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesh_exit_settings`
--

LOCK TABLES `mesh_exit_settings` WRITE;
/*!40000 ALTER TABLE `mesh_exit_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesh_exit_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesh_exits`
--

DROP TABLE IF EXISTS `mesh_exits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_exits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_id` int(11) DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  `type` enum('bridge','tagged_bridge','nat','captive_portal','openvpn_bridge','tagged_bridge_l3','pppoe_server') DEFAULT NULL,
  `auto_detect` tinyint(1) NOT NULL DEFAULT 0,
  `vlan` int(4) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `openvpn_server_id` int(11) DEFAULT NULL,
  `proto` enum('static','dhcp','dhcpv6') DEFAULT 'dhcp',
  `ipaddr` varchar(50) NOT NULL DEFAULT '',
  `netmask` varchar(50) NOT NULL DEFAULT '',
  `gateway` varchar(50) NOT NULL DEFAULT '',
  `dns_1` varchar(50) NOT NULL DEFAULT '',
  `dns_2` varchar(50) NOT NULL DEFAULT '',
  `apply_firewall_profile` tinyint(1) NOT NULL DEFAULT 0,
  `firewall_profile_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_mesh_exits_mesh_id` (`mesh_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesh_exits`
--

LOCK TABLES `mesh_exits` WRITE;
/*!40000 ALTER TABLE `mesh_exits` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesh_exits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesh_settings`
--

DROP TABLE IF EXISTS `mesh_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_id` int(11) DEFAULT NULL,
  `aggregated_ogms` tinyint(1) NOT NULL DEFAULT 1,
  `ap_isolation` tinyint(1) NOT NULL DEFAULT 0,
  `bonding` tinyint(1) NOT NULL DEFAULT 0,
  `bridge_loop_avoidance` tinyint(1) NOT NULL DEFAULT 0,
  `fragmentation` tinyint(1) NOT NULL DEFAULT 1,
  `distributed_arp_table` tinyint(1) NOT NULL DEFAULT 1,
  `orig_interval` int(10) NOT NULL DEFAULT 1000,
  `gw_sel_class` int(10) NOT NULL DEFAULT 20,
  `connectivity` enum('IBSS','mesh_point') DEFAULT 'mesh_point',
  `encryption` tinyint(1) NOT NULL DEFAULT 0,
  `encryption_key` varchar(63) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `routing_algo` enum('BATMAN_IV','BATMAN_V') DEFAULT 'BATMAN_V',
  PRIMARY KEY (`id`),
  KEY `idx_mesh_settings_mesh_id` (`mesh_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesh_settings`
--

LOCK TABLES `mesh_settings` WRITE;
/*!40000 ALTER TABLE `mesh_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesh_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesh_specifics`
--

DROP TABLE IF EXISTS `mesh_specifics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_specifics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_mesh_specifics_mesh_id` (`mesh_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesh_specifics`
--

LOCK TABLES `mesh_specifics` WRITE;
/*!40000 ALTER TABLE `mesh_specifics` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesh_specifics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meshes`
--

DROP TABLE IF EXISTS `meshes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meshes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `ssid` varchar(32) NOT NULL,
  `bssid` varchar(32) NOT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `tree_tag_id` int(11) DEFAULT NULL,
  `last_contact` datetime DEFAULT NULL,
  `enable_alerts` tinyint(1) NOT NULL DEFAULT 1,
  `enable_overviews` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_meshes_name` (`name`),
  KEY `idx_meshes_modified` (`modified`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meshes`
--

LOCK TABLES `meshes` WRITE;
/*!40000 ALTER TABLE `meshes` DISABLE KEYS */;
/*!40000 ALTER TABLE `meshes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `na_realms`
--

DROP TABLE IF EXISTS `na_realms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `na_realms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `na_id` int(11) NOT NULL,
  `realm_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `na_realms`
--

LOCK TABLES `na_realms` WRITE;
/*!40000 ALTER TABLE `na_realms` DISABLE KEYS */;
/*!40000 ALTER TABLE `na_realms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `na_settings`
--

DROP TABLE IF EXISTS `na_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `na_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `na_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `na_settings`
--

LOCK TABLES `na_settings` WRITE;
/*!40000 ALTER TABLE `na_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `na_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `na_states`
--

DROP TABLE IF EXISTS `na_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `na_states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `na_id` char(36) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `na_states`
--

LOCK TABLES `na_states` WRITE;
/*!40000 ALTER TABLE `na_states` DISABLE KEYS */;
/*!40000 ALTER TABLE `na_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nas`
--

DROP TABLE IF EXISTS `nas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nas` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `nasname` varchar(128) NOT NULL,
  `shortname` varchar(32) DEFAULT NULL,
  `nasidentifier` varchar(64) NOT NULL DEFAULT '',
  `type` varchar(30) DEFAULT 'other',
  `ports` int(5) DEFAULT NULL,
  `secret` varchar(60) NOT NULL DEFAULT 'secret',
  `server` varchar(64) DEFAULT NULL,
  `community` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT 'RADIUS Client',
  `connection_type` enum('direct','openvpn','pptp','dynamic') DEFAULT 'direct',
  `timezone` varchar(255) NOT NULL DEFAULT '',
  `record_auth` tinyint(1) NOT NULL DEFAULT 0,
  `ignore_acct` tinyint(1) NOT NULL DEFAULT 0,
  `dynamic_attribute` varchar(50) NOT NULL DEFAULT '',
  `dynamic_value` varchar(50) NOT NULL DEFAULT '',
  `monitor` enum('off','ping','heartbeat') DEFAULT 'off',
  `ping_interval` int(5) NOT NULL DEFAULT 600,
  `heartbeat_dead_after` int(5) NOT NULL DEFAULT 600,
  `last_contact` datetime DEFAULT NULL,
  `session_auto_close` tinyint(1) NOT NULL DEFAULT 0,
  `session_dead_time` int(5) NOT NULL DEFAULT 3600,
  `on_public_maps` tinyint(1) NOT NULL DEFAULT 0,
  `lat` double DEFAULT NULL,
  `lon` double DEFAULT NULL,
  `photo_file_name` varchar(128) NOT NULL DEFAULT 'logo.png',
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nasname` (`nasname`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nas`
--

LOCK TABLES `nas` WRITE;
/*!40000 ALTER TABLE `nas` DISABLE KEYS */;
/*!40000 ALTER TABLE `nas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `networks`
--

DROP TABLE IF EXISTS `networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `networks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `site_id` int(11) DEFAULT NULL,
  `lat` decimal(11,8) DEFAULT NULL,
  `lng` decimal(11,8) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `networks`
--

LOCK TABLES `networks` WRITE;
/*!40000 ALTER TABLE `networks` DISABLE KEYS */;
/*!40000 ALTER TABLE `networks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_accountings`
--

DROP TABLE IF EXISTS `new_accountings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_accountings` (
  `mac` varchar(17) NOT NULL,
  `username` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`mac`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_accountings`
--

LOCK TABLES `new_accountings` WRITE;
/*!40000 ALTER TABLE `new_accountings` DISABLE KEYS */;
/*!40000 ALTER TABLE `new_accountings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_actions`
--

DROP TABLE IF EXISTS `node_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_actions` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `node_id` int(10) NOT NULL,
  `action` enum('execute','execute_and_reply') DEFAULT 'execute',
  `command` varchar(500) DEFAULT '',
  `status` enum('awaiting','fetched','replied') DEFAULT 'awaiting',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `reply` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_actions_node_id` (`node_id`),
  KEY `idx_node_actions_modified` (`modified`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_actions`
--

LOCK TABLES `node_actions` WRITE;
/*!40000 ALTER TABLE `node_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_connection_settings`
--

DROP TABLE IF EXISTS `node_connection_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_connection_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `grouping` varchar(25) DEFAULT NULL,
  `name` varchar(25) DEFAULT NULL,
  `value` varchar(40) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_connection_settings`
--

LOCK TABLES `node_connection_settings` WRITE;
/*!40000 ALTER TABLE `node_connection_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_connection_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_ibss_connections`
--

DROP TABLE IF EXISTS `node_ibss_connections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_ibss_connections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `station_node_id` int(11) DEFAULT NULL,
  `radio_number` tinyint(3) NOT NULL DEFAULT 0,
  `frequency_band` enum('two','five_lower','five_upper') DEFAULT 'two',
  `if_mac` varchar(17) NOT NULL,
  `mac` varchar(17) NOT NULL,
  `tx_bytes` bigint(20) NOT NULL,
  `rx_bytes` bigint(20) NOT NULL,
  `tx_packets` bigint(20) NOT NULL,
  `rx_packets` bigint(20) NOT NULL,
  `tx_bitrate` int(11) NOT NULL,
  `rx_bitrate` int(11) NOT NULL,
  `authenticated` tinyint(2) NOT NULL DEFAULT 1,
  `authorized` tinyint(2) NOT NULL DEFAULT 1,
  `tdls_peer` tinyint(2) NOT NULL DEFAULT 1,
  `preamble` varchar(255) NOT NULL,
  `tx_failed` int(11) NOT NULL,
  `wmm_wme` tinyint(2) NOT NULL DEFAULT 0,
  `tx_retries` int(11) NOT NULL,
  `mfp` tinyint(2) NOT NULL DEFAULT 1,
  `signal_now` int(11) NOT NULL,
  `signal_avg` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_ibss_connections_node_id` (`node_id`),
  KEY `idx_node_ibss_connections_station_node_id` (`station_node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_ibss_connections`
--

LOCK TABLES `node_ibss_connections` WRITE;
/*!40000 ALTER TABLE `node_ibss_connections` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_ibss_connections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_ibss_connections_dailies`
--

DROP TABLE IF EXISTS `node_ibss_connections_dailies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_ibss_connections_dailies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mac` varchar(64) NOT NULL DEFAULT '',
  `mesh_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `station_node_id` int(11) NOT NULL,
  `if_mac` varchar(64) NOT NULL DEFAULT '',
  `radio_number` int(2) NOT NULL,
  `frequency_band` enum('two','five_lower','five_upper') DEFAULT 'two',
  `tx_bytes` bigint(20) NOT NULL,
  `rx_bytes` bigint(20) NOT NULL,
  `tx_bitrate` int(6) NOT NULL,
  `rx_bitrate` int(6) NOT NULL,
  `signal_avg` int(6) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_ibss_connections_dailies`
--

LOCK TABLES `node_ibss_connections_dailies` WRITE;
/*!40000 ALTER TABLE `node_ibss_connections_dailies` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_ibss_connections_dailies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_loads`
--

DROP TABLE IF EXISTS `node_loads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_loads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `mem_total` int(11) DEFAULT NULL,
  `mem_free` int(11) DEFAULT NULL,
  `uptime` varchar(255) DEFAULT NULL,
  `system_time` varchar(255) NOT NULL,
  `load_1` float(2,2) NOT NULL,
  `load_2` float(2,2) NOT NULL,
  `load_3` float(2,2) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_loads_node_id` (`node_id`),
  KEY `idx_node_loads_modified` (`modified`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_loads`
--

LOCK TABLES `node_loads` WRITE;
/*!40000 ALTER TABLE `node_loads` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_loads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_mesh_entries`
--

DROP TABLE IF EXISTS `node_mesh_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_mesh_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `mesh_entry_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_mesh_entries_node_id` (`node_id`),
  KEY `idx_node_mesh_entries_mesh_entry_id` (`mesh_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_mesh_entries`
--

LOCK TABLES `node_mesh_entries` WRITE;
/*!40000 ALTER TABLE `node_mesh_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_mesh_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_mesh_exits`
--

DROP TABLE IF EXISTS `node_mesh_exits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_mesh_exits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `mesh_exit_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_mesh_exits_node_id` (`node_id`),
  KEY `idx_node_mesh_exits_mesh_exit_id` (`mesh_exit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_mesh_exits`
--

LOCK TABLES `node_mesh_exits` WRITE;
/*!40000 ALTER TABLE `node_mesh_exits` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_mesh_exits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_mp_settings`
--

DROP TABLE IF EXISTS `node_mp_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_mp_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_mp_settings_node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_mp_settings`
--

LOCK TABLES `node_mp_settings` WRITE;
/*!40000 ALTER TABLE `node_mp_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_mp_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_neighbors`
--

DROP TABLE IF EXISTS `node_neighbors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_neighbors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `gateway` enum('yes','no') DEFAULT 'no',
  `neighbor_id` int(11) DEFAULT NULL,
  `metric` decimal(6,4) NOT NULL,
  `hwmode` char(5) DEFAULT '11g',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `algo` enum('BATMAN_IV','BATMAN_V') DEFAULT 'BATMAN_V',
  `tq` int(11) DEFAULT NULL,
  `tp` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_neighbors_node_id` (`node_id`),
  KEY `idx_node_neighbors_gateway` (`gateway`),
  KEY `idx_node_neighbors_neighbor_id` (`neighbor_id`),
  KEY `idx_node_neighbors_modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_neighbors`
--

LOCK TABLES `node_neighbors` WRITE;
/*!40000 ALTER TABLE `node_neighbors` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_neighbors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_scans`
--

DROP TABLE IF EXISTS `node_scans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_scans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `ap_id` int(11) DEFAULT NULL,
  `scan_data` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_scans`
--

LOCK TABLES `node_scans` WRITE;
/*!40000 ALTER TABLE `node_scans` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_scans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_settings`
--

DROP TABLE IF EXISTS `node_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_id` int(11) DEFAULT NULL,
  `password` varchar(128) NOT NULL,
  `power` int(3) NOT NULL DEFAULT 100,
  `all_power` tinyint(1) NOT NULL DEFAULT 1,
  `two_chan` int(3) NOT NULL DEFAULT 6,
  `five_chan` int(3) NOT NULL DEFAULT 44,
  `heartbeat_interval` int(5) NOT NULL DEFAULT 60,
  `heartbeat_dead_after` int(5) NOT NULL DEFAULT 600,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `password_hash` varchar(100) NOT NULL DEFAULT '',
  `eth_br_chk` tinyint(1) NOT NULL DEFAULT 0,
  `eth_br_with` int(11) NOT NULL DEFAULT 0,
  `eth_br_for_all` tinyint(1) NOT NULL DEFAULT 1,
  `tz_name` varchar(128) NOT NULL DEFAULT 'America/New York',
  `tz_value` varchar(128) NOT NULL DEFAULT 'EST5EDT,M3.2.0,M11.1.0',
  `country` varchar(5) NOT NULL DEFAULT 'US',
  `gw_dhcp_timeout` int(5) NOT NULL DEFAULT 120,
  `gw_use_previous` tinyint(1) NOT NULL DEFAULT 1,
  `gw_auto_reboot` tinyint(1) NOT NULL DEFAULT 1,
  `gw_auto_reboot_time` int(5) NOT NULL DEFAULT 600,
  `client_key` varchar(255) NOT NULL DEFAULT 'radiusdesk',
  `syslog1_ip` varchar(50) NOT NULL DEFAULT '',
  `syslog1_port` varchar(10) NOT NULL DEFAULT '514',
  `syslog2_ip` varchar(50) NOT NULL DEFAULT '',
  `syslog2_port` varchar(10) NOT NULL DEFAULT '514',
  `syslog3_ip` varchar(50) NOT NULL DEFAULT '',
  `syslog3_port` varchar(10) NOT NULL DEFAULT '514',
  `report_adv_enable` tinyint(1) NOT NULL DEFAULT 1,
  `report_adv_proto` enum('https','http') DEFAULT 'http',
  `report_adv_light` int(5) DEFAULT 60,
  `report_adv_full` int(5) DEFAULT 600,
  `report_adv_sampling` int(5) DEFAULT 60,
  `enable_schedules` tinyint(1) NOT NULL DEFAULT 0,
  `schedule_id` int(11) DEFAULT NULL,
  `vlan_enable` tinyint(1) NOT NULL DEFAULT 0,
  `vlan_range_or_list` enum('range','list') DEFAULT 'range',
  `vlan_start` int(10) NOT NULL DEFAULT 100,
  `vlan_end` int(10) NOT NULL DEFAULT 101,
  `vlan_list` varchar(255) NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`),
  KEY `idx_node_settings_mesh_id` (`mesh_id`),
  KEY `idx_node_settings_modified` (`modified`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_settings`
--

LOCK TABLES `node_settings` WRITE;
/*!40000 ALTER TABLE `node_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_stations`
--

DROP TABLE IF EXISTS `node_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_stations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `mesh_entry_id` int(11) DEFAULT NULL,
  `radio_number` tinyint(3) NOT NULL DEFAULT 0,
  `frequency_band` enum('two','five_lower','five_upper') DEFAULT 'two',
  `mac` varchar(17) NOT NULL,
  `tx_bytes` bigint(20) NOT NULL,
  `rx_bytes` bigint(20) NOT NULL,
  `tx_packets` bigint(20) NOT NULL,
  `rx_packets` bigint(20) NOT NULL,
  `tx_bitrate` int(11) NOT NULL,
  `rx_bitrate` int(11) NOT NULL,
  `authenticated` tinyint(2) NOT NULL DEFAULT 1,
  `authorized` tinyint(2) NOT NULL DEFAULT 1,
  `tdls_peer` tinyint(2) NOT NULL DEFAULT 1,
  `preamble` varchar(255) NOT NULL,
  `tx_failed` int(11) NOT NULL,
  `wmm_wme` tinyint(2) NOT NULL DEFAULT 0,
  `tx_retries` int(11) NOT NULL,
  `mfp` tinyint(2) NOT NULL DEFAULT 1,
  `signal_now` int(11) NOT NULL,
  `signal_avg` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_stations_node_id` (`node_id`),
  KEY `idx_node_stations_mesh_entry_id` (`mesh_entry_id`),
  KEY `idx_node_stations_modified` (`modified`)
) ENGINE=InnoDB AUTO_INCREMENT=328 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_stations`
--

LOCK TABLES `node_stations` WRITE;
/*!40000 ALTER TABLE `node_stations` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_stations_dailies`
--

DROP TABLE IF EXISTS `node_stations_dailies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_stations_dailies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mac` varchar(64) NOT NULL DEFAULT '',
  `node_station_id` int(11) NOT NULL,
  `mesh_id` int(11) NOT NULL,
  `mesh_entry_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `radio_number` int(2) NOT NULL,
  `frequency_band` enum('two','five_lower','five_upper') DEFAULT 'two',
  `tx_bytes` bigint(20) NOT NULL,
  `rx_bytes` bigint(20) NOT NULL,
  `tx_bitrate` int(6) NOT NULL,
  `rx_bitrate` int(6) NOT NULL,
  `signal_avg` int(6) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_stations_dailies`
--

LOCK TABLES `node_stations_dailies` WRITE;
/*!40000 ALTER TABLE `node_stations_dailies` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_stations_dailies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_systems`
--

DROP TABLE IF EXISTS `node_systems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_systems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_systems_node_id` (`node_id`),
  KEY `idx_node_systems_name` (`name`),
  KEY `idx_node_systems_modified` (`modified`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_systems`
--

LOCK TABLES `node_systems` WRITE;
/*!40000 ALTER TABLE `node_systems` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_systems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_uptm_histories`
--

DROP TABLE IF EXISTS `node_uptm_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_uptm_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `node_state` tinyint(1) NOT NULL DEFAULT 0,
  `state_datetime` datetime NOT NULL,
  `report_datetime` datetime NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_uptm_histories_node_id` (`node_id`),
  KEY `idx_node_uptm_histories_modified` (`modified`),
  KEY `idx_node_uptm_histories_node_state` (`node_state`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_uptm_histories`
--

LOCK TABLES `node_uptm_histories` WRITE;
/*!40000 ALTER TABLE `node_uptm_histories` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_uptm_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_wifi_settings`
--

DROP TABLE IF EXISTS `node_wifi_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_wifi_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_node_wifi_settings_node_id` (`node_id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_wifi_settings`
--

LOCK TABLES `node_wifi_settings` WRITE;
/*!40000 ALTER TABLE `node_wifi_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_wifi_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nodes`
--

DROP TABLE IF EXISTS `nodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `mac` varchar(255) NOT NULL,
  `hardware` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `last_contact` datetime DEFAULT NULL,
  `lat` double DEFAULT NULL,
  `lon` double DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `config_fetched` datetime DEFAULT NULL,
  `lan_proto` varchar(30) NOT NULL DEFAULT '',
  `lan_ip` varchar(30) NOT NULL DEFAULT '',
  `lan_gw` varchar(30) NOT NULL DEFAULT '',
  `last_contact_from_ip` varchar(30) NOT NULL DEFAULT '',
  `mesh0` varchar(25) NOT NULL DEFAULT '',
  `mesh1` varchar(25) NOT NULL DEFAULT '',
  `mesh2` varchar(25) NOT NULL DEFAULT '',
  `gateway` enum('none','lan','3g','wifi','wifi_static','wifi_ppp','wifi_pppoe','wan_static','wan_ppp','wan_pppoe') DEFAULT 'none',
  `bootcycle` int(11) NOT NULL DEFAULT 0,
  `mesh0_frequency_band` enum('two','five_lower','five_upper') DEFAULT 'two',
  `mesh1_frequency_band` enum('two','five_lower','five_upper') DEFAULT 'two',
  `mesh2_frequency_band` enum('two','five_lower','five_upper') DEFAULT 'two',
  `mesh0_channel` int(3) NOT NULL DEFAULT 0,
  `mesh1_channel` int(3) NOT NULL DEFAULT 0,
  `mesh2_channel` int(3) NOT NULL DEFAULT 0,
  `mesh0_txpower` int(3) NOT NULL DEFAULT 0,
  `mesh1_txpower` int(3) NOT NULL DEFAULT 0,
  `mesh2_txpower` int(3) NOT NULL DEFAULT 0,
  `reboot_flag` tinyint(1) NOT NULL DEFAULT 0,
  `enable_alerts` tinyint(1) NOT NULL DEFAULT 1,
  `enable_overviews` tinyint(1) NOT NULL DEFAULT 1,
  `enable_schedules` tinyint(1) NOT NULL DEFAULT 0,
  `schedule_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_nodes_mesh_id` (`mesh_id`),
  KEY `idx_nodes_name` (`name`),
  KEY `idx_nodes_mac` (`mac`),
  KEY `idx_nodes_last_contact` (`last_contact`),
  KEY `idx_nodes_modified` (`modified`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nodes`
--

LOCK TABLES `nodes` WRITE;
/*!40000 ALTER TABLE `nodes` DISABLE KEYS */;
/*!40000 ALTER TABLE `nodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `severity` int(11) NOT NULL DEFAULT 1,
  `is_resolved` tinyint(1) NOT NULL DEFAULT 0,
  `notification_datetime` datetime NOT NULL,
  `notification_type` varchar(32) NOT NULL DEFAULT 'network',
  `notification_code` int(11) NOT NULL DEFAULT 2,
  `short_description` varchar(64) DEFAULT NULL,
  `description` varchar(512) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `item_table` varchar(64) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_severity` (`severity`),
  KEY `idx_notifications_modified` (`modified`),
  KEY `idx_notification_datetime` (`notification_datetime`),
  KEY `idx_notification_is_resolved` (`is_resolved`),
  KEY `idx_notification_notification_type` (`notification_type`),
  KEY `idx_notification_notification_code` (`notification_code`),
  KEY `idx_notification_item_id` (`item_id`),
  KEY `idx_notification_item_table` (`item_table`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openvpn_clients`
--

DROP TABLE IF EXISTS `openvpn_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openvpn_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `subnet` int(3) DEFAULT NULL,
  `peer1` int(3) DEFAULT NULL,
  `peer2` int(3) DEFAULT NULL,
  `na_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openvpn_clients`
--

LOCK TABLES `openvpn_clients` WRITE;
/*!40000 ALTER TABLE `openvpn_clients` DISABLE KEYS */;
/*!40000 ALTER TABLE `openvpn_clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openvpn_server_clients`
--

DROP TABLE IF EXISTS `openvpn_server_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openvpn_server_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_ap_profile` enum('mesh','ap_profile') DEFAULT 'mesh',
  `openvpn_server_id` int(11) DEFAULT NULL,
  `mesh_id` int(11) DEFAULT NULL,
  `mesh_exit_id` int(11) DEFAULT NULL,
  `ap_profile_id` int(11) DEFAULT NULL,
  `ap_profile_exit_id` int(11) DEFAULT NULL,
  `ap_id` int(11) DEFAULT NULL,
  `ip_address` varchar(40) NOT NULL,
  `last_contact_to_server` datetime DEFAULT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openvpn_server_clients`
--

LOCK TABLES `openvpn_server_clients` WRITE;
/*!40000 ALTER TABLE `openvpn_server_clients` DISABLE KEYS */;
/*!40000 ALTER TABLE `openvpn_server_clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openvpn_servers`
--

DROP TABLE IF EXISTS `openvpn_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openvpn_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `cloud_id` int(11) DEFAULT NULL,
  `local_remote` enum('local','remote') DEFAULT 'local',
  `protocol` enum('udp','tcp') DEFAULT 'udp',
  `ip_address` varchar(40) NOT NULL,
  `port` int(6) NOT NULL,
  `vpn_gateway_address` varchar(40) NOT NULL,
  `vpn_bridge_start_address` varchar(40) NOT NULL,
  `vpn_mask` varchar(40) NOT NULL,
  `config_preset` varchar(100) NOT NULL DEFAULT 'default',
  `ca_crt` text NOT NULL,
  `extra_name` varchar(100) NOT NULL DEFAULT '',
  `extra_value` varchar(100) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openvpn_servers`
--

LOCK TABLES `openvpn_servers` WRITE;
/*!40000 ALTER TABLE `openvpn_servers` DISABLE KEYS */;
/*!40000 ALTER TABLE `openvpn_servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permanent_user_notifications`
--

DROP TABLE IF EXISTS `permanent_user_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permanent_user_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permanent_user_id` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `method` enum('whatsapp','email','sms') DEFAULT 'email',
  `type` enum('daily','usage') DEFAULT 'daily',
  `address_1` varchar(255) DEFAULT NULL,
  `address_2` varchar(255) DEFAULT NULL,
  `start` int(3) DEFAULT 80,
  `increment` int(3) DEFAULT 10,
  `last_value` int(3) DEFAULT NULL,
  `last_notification` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permanent_user_notifications`
--

LOCK TABLES `permanent_user_notifications` WRITE;
/*!40000 ALTER TABLE `permanent_user_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `permanent_user_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permanent_user_otps`
--

DROP TABLE IF EXISTS `permanent_user_otps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permanent_user_otps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permanent_user_id` int(11) NOT NULL,
  `status` enum('otp_awaiting','otp_confirmed') DEFAULT 'otp_awaiting',
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permanent_user_otps`
--

LOCK TABLES `permanent_user_otps` WRITE;
/*!40000 ALTER TABLE `permanent_user_otps` DISABLE KEYS */;
/*!40000 ALTER TABLE `permanent_user_otps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permanent_user_settings`
--

DROP TABLE IF EXISTS `permanent_user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permanent_user_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permanent_user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permanent_user_settings`
--

LOCK TABLES `permanent_user_settings` WRITE;
/*!40000 ALTER TABLE `permanent_user_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `permanent_user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permanent_users`
--

DROP TABLE IF EXISTS `permanent_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permanent_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(50) NOT NULL,
  `token` char(36) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `auth_type` varchar(128) NOT NULL DEFAULT 'sql',
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `last_accept_time` datetime DEFAULT NULL,
  `last_reject_time` datetime DEFAULT NULL,
  `last_accept_nas` varchar(128) DEFAULT NULL,
  `last_reject_nas` varchar(128) DEFAULT NULL,
  `last_reject_message` varchar(255) DEFAULT NULL,
  `perc_time_used` int(6) DEFAULT NULL,
  `perc_data_used` int(6) DEFAULT NULL,
  `data_used` bigint(20) DEFAULT NULL,
  `data_cap` bigint(20) DEFAULT NULL,
  `time_used` int(12) DEFAULT NULL,
  `time_cap` int(12) DEFAULT NULL,
  `time_cap_type` enum('hard','soft') DEFAULT 'soft',
  `data_cap_type` enum('hard','soft') DEFAULT 'soft',
  `realm` varchar(50) NOT NULL DEFAULT '',
  `realm_id` int(11) DEFAULT NULL,
  `profile` varchar(50) NOT NULL DEFAULT '',
  `profile_id` int(11) DEFAULT NULL,
  `from_date` datetime DEFAULT NULL,
  `to_date` datetime DEFAULT NULL,
  `track_auth` tinyint(1) NOT NULL DEFAULT 0,
  `track_acct` tinyint(1) NOT NULL DEFAULT 1,
  `static_ip` varchar(50) NOT NULL DEFAULT '',
  `extra_name` varchar(100) NOT NULL DEFAULT '',
  `extra_value` varchar(100) NOT NULL DEFAULT '',
  `country_id` int(11) DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `site` varchar(100) NOT NULL DEFAULT '',
  `ppsk` varchar(100) NOT NULL DEFAULT '',
  `realm_vlan_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permanent_users`
--

LOCK TABLES `permanent_users` WRITE;
/*!40000 ALTER TABLE `permanent_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `permanent_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pptp_clients`
--

DROP TABLE IF EXISTS `pptp_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pptp_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `na_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pptp_clients`
--

LOCK TABLES `pptp_clients` WRITE;
/*!40000 ALTER TABLE `pptp_clients` DISABLE KEYS */;
/*!40000 ALTER TABLE `pptp_clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `predefined_commands`
--

DROP TABLE IF EXISTS `predefined_commands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `predefined_commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(64) DEFAULT NULL,
  `command` varchar(255) NOT NULL DEFAULT '',
  `action` enum('execute','execute_and_reply') DEFAULT 'execute',
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `predefined_commands`
--

LOCK TABLES `predefined_commands` WRITE;
/*!40000 ALTER TABLE `predefined_commands` DISABLE KEYS */;
/*!40000 ALTER TABLE `predefined_commands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_components`
--

DROP TABLE IF EXISTS `profile_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_components` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile_components`
--

LOCK TABLES `profile_components` WRITE;
/*!40000 ALTER TABLE `profile_components` DISABLE KEYS */;
/*!40000 ALTER TABLE `profile_components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_fup_components`
--

DROP TABLE IF EXISTS `profile_fup_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_fup_components` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `if_condition` enum('day_usage','week_usage','month_usage','time_of_day') DEFAULT 'day_usage',
  `time_start` varchar(255) DEFAULT NULL,
  `time_end` varchar(255) DEFAULT NULL,
  `data_amount` int(10) DEFAULT NULL,
  `data_unit` enum('mb','gb') DEFAULT 'mb',
  `action` enum('increase_speed','decrease_speed','block') DEFAULT 'block',
  `action_amount` int(10) DEFAULT NULL,
  `ip_pool` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `vlan` int(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile_fup_components`
--

LOCK TABLES `profile_fup_components` WRITE;
/*!40000 ALTER TABLE `profile_fup_components` DISABLE KEYS */;
/*!40000 ALTER TABLE `profile_fup_components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `radacct`
--

DROP TABLE IF EXISTS `radacct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `radacct` (
  `radacctid` bigint(21) NOT NULL AUTO_INCREMENT,
  `acctsessionid` varchar(64) NOT NULL DEFAULT '',
  `acctuniqueid` varchar(32) NOT NULL DEFAULT '',
  `username` varchar(64) NOT NULL DEFAULT '',
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `realm` varchar(64) DEFAULT '',
  `nasipaddress` varchar(15) NOT NULL DEFAULT '',
  `nasidentifier` varchar(64) NOT NULL DEFAULT '',
  `nasportid` varchar(15) DEFAULT NULL,
  `nasporttype` varchar(32) DEFAULT NULL,
  `acctstarttime` datetime DEFAULT NULL,
  `acctupdatetime` datetime DEFAULT NULL,
  `acctstoptime` datetime DEFAULT NULL,
  `acctinterval` int(12) DEFAULT NULL,
  `acctsessiontime` int(12) unsigned DEFAULT NULL,
  `acctauthentic` varchar(32) DEFAULT NULL,
  `connectinfo_start` varchar(50) DEFAULT NULL,
  `connectinfo_stop` varchar(50) DEFAULT NULL,
  `acctinputoctets` bigint(20) DEFAULT NULL,
  `acctoutputoctets` bigint(20) DEFAULT NULL,
  `calledstationid` varchar(50) NOT NULL DEFAULT '',
  `callingstationid` varchar(50) NOT NULL DEFAULT '',
  `acctterminatecause` varchar(32) NOT NULL DEFAULT '',
  `servicetype` varchar(32) DEFAULT NULL,
  `framedprotocol` varchar(32) DEFAULT NULL,
  `framedipaddress` varchar(15) NOT NULL DEFAULT '',
  `acctstartdelay` int(12) DEFAULT NULL,
  `acctstopdelay` int(12) DEFAULT NULL,
  `xascendsessionsvrkey` varchar(20) DEFAULT NULL,
  `operator_name` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`radacctid`),
  UNIQUE KEY `acctuniqueid` (`acctuniqueid`),
  KEY `username` (`username`),
  KEY `framedipaddress` (`framedipaddress`),
  KEY `acctsessionid` (`acctsessionid`),
  KEY `acctsessiontime` (`acctsessiontime`),
  KEY `acctstarttime` (`acctstarttime`),
  KEY `acctinterval` (`acctinterval`),
  KEY `acctstoptime` (`acctstoptime`),
  KEY `nasipaddress` (`nasipaddress`),
  KEY `nasidentifier` (`nasidentifier`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `radacct`
--

LOCK TABLES `radacct` WRITE;
/*!40000 ALTER TABLE `radacct` DISABLE KEYS */;
/*!40000 ALTER TABLE `radacct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `radcheck`
--

DROP TABLE IF EXISTS `radcheck`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `radcheck` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '==',
  `value` varchar(253) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `username` (`username`(32)),
  KEY `FK_radcheck_ref_vouchers` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=10623 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `radcheck`
--

LOCK TABLES `radcheck` WRITE;
/*!40000 ALTER TABLE `radcheck` DISABLE KEYS */;
/*!40000 ALTER TABLE `radcheck` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `radgroupcheck`
--

DROP TABLE IF EXISTS `radgroupcheck`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `radgroupcheck` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '==',
  `value` varchar(253) NOT NULL DEFAULT '',
  `comment` varchar(253) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `groupname` (`groupname`(32))
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `radgroupcheck`
--

LOCK TABLES `radgroupcheck` WRITE;
/*!40000 ALTER TABLE `radgroupcheck` DISABLE KEYS */;
/*!40000 ALTER TABLE `radgroupcheck` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `radgroupreply`
--

DROP TABLE IF EXISTS `radgroupreply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `radgroupreply` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '=',
  `value` varchar(253) NOT NULL DEFAULT '',
  `comment` varchar(253) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `groupname` (`groupname`(32))
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `radgroupreply`
--

LOCK TABLES `radgroupreply` WRITE;
/*!40000 ALTER TABLE `radgroupreply` DISABLE KEYS */;
/*!40000 ALTER TABLE `radgroupreply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `radippool`
--

DROP TABLE IF EXISTS `radippool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `radippool` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pool_name` varchar(30) NOT NULL,
  `framedipaddress` varchar(15) NOT NULL DEFAULT '',
  `nasipaddress` varchar(15) NOT NULL DEFAULT '',
  `calledstationid` varchar(30) NOT NULL,
  `callingstationid` varchar(30) NOT NULL,
  `expiry_time` datetime DEFAULT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `pool_key` varchar(30) NOT NULL DEFAULT '',
  `nasidentifier` varchar(64) NOT NULL DEFAULT '',
  `extra_name` varchar(100) NOT NULL DEFAULT '',
  `extra_value` varchar(100) NOT NULL DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `permanent_user_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `radippool_poolname_expire` (`pool_name`,`expiry_time`),
  KEY `framedipaddress` (`framedipaddress`),
  KEY `radippool_nasip_poolkey_ipaddress` (`nasipaddress`,`pool_key`,`framedipaddress`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `radippool`
--

LOCK TABLES `radippool` WRITE;
/*!40000 ALTER TABLE `radippool` DISABLE KEYS */;
/*!40000 ALTER TABLE `radippool` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `radpostauth`
--

DROP TABLE IF EXISTS `radpostauth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `radpostauth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `realm` varchar(64) DEFAULT NULL,
  `pass` varchar(64) NOT NULL DEFAULT '',
  `reply` varchar(32) NOT NULL DEFAULT '',
  `nasname` varchar(128) NOT NULL DEFAULT '',
  `authdate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `radpostauth`
--

LOCK TABLES `radpostauth` WRITE;
/*!40000 ALTER TABLE `radpostauth` DISABLE KEYS */;
/*!40000 ALTER TABLE `radpostauth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `radreply`
--

DROP TABLE IF EXISTS `radreply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `radreply` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '=',
  `value` varchar(253) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `username` (`username`(32)),
  KEY `FK_radreply_ref_vouchers` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `radreply`
--

LOCK TABLES `radreply` WRITE;
/*!40000 ALTER TABLE `radreply` DISABLE KEYS */;
/*!40000 ALTER TABLE `radreply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `radusergroup`
--

DROP TABLE IF EXISTS `radusergroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `radusergroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `priority` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `username` (`username`(32))
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `radusergroup`
--

LOCK TABLES `radusergroup` WRITE;
/*!40000 ALTER TABLE `radusergroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `radusergroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realm_mac_users`
--

DROP TABLE IF EXISTS `realm_mac_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `realm_mac_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `realm_id` int(11) NOT NULL,
  `mac` varchar(17) DEFAULT NULL,
  `username` varchar(64) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `realm_mac` (`realm_id`,`mac`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realm_mac_users`
--

LOCK TABLES `realm_mac_users` WRITE;
/*!40000 ALTER TABLE `realm_mac_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `realm_mac_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realm_pmks`
--

DROP TABLE IF EXISTS `realm_pmks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `realm_pmks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `realm_id` int(11) NOT NULL,
  `realm_ssid_id` int(11) NOT NULL,
  `ppsk` varchar(100) DEFAULT NULL,
  `pmk` varchar(64) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realm_pmks`
--

LOCK TABLES `realm_pmks` WRITE;
/*!40000 ALTER TABLE `realm_pmks` DISABLE KEYS */;
/*!40000 ALTER TABLE `realm_pmks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realm_ssids`
--

DROP TABLE IF EXISTS `realm_ssids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `realm_ssids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `realm_id` int(11) NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `ssid_type` enum('standalone','mesh','ap_profile') DEFAULT 'standalone',
  `mesh_id` int(11) DEFAULT NULL,
  `mesh_entry_id` int(11) DEFAULT NULL,
  `ap_profile_id` int(11) DEFAULT NULL,
  `ap_profile_entry_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realm_ssids`
--

LOCK TABLES `realm_ssids` WRITE;
/*!40000 ALTER TABLE `realm_ssids` DISABLE KEYS */;
/*!40000 ALTER TABLE `realm_ssids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realm_vlans`
--

DROP TABLE IF EXISTS `realm_vlans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `realm_vlans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `realm_id` int(11) NOT NULL,
  `vlan` int(4) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realm_vlans`
--

LOCK TABLES `realm_vlans` WRITE;
/*!40000 ALTER TABLE `realm_vlans` DISABLE KEYS */;
/*!40000 ALTER TABLE `realm_vlans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realms`
--

DROP TABLE IF EXISTS `realms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `realms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `icon_file_name` varchar(128) NOT NULL DEFAULT 'logo.png',
  `phone` varchar(14) NOT NULL DEFAULT '',
  `cell` varchar(14) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `url` varchar(128) NOT NULL DEFAULT '',
  `street_no` char(10) NOT NULL DEFAULT '',
  `street` char(50) NOT NULL DEFAULT '',
  `town_suburb` char(50) NOT NULL DEFAULT '',
  `city` char(50) NOT NULL DEFAULT '',
  `country` char(50) NOT NULL DEFAULT '',
  `lat` double DEFAULT NULL,
  `lon` double DEFAULT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `twitter` varchar(255) NOT NULL DEFAULT '',
  `facebook` varchar(255) NOT NULL DEFAULT '',
  `youtube` varchar(255) NOT NULL DEFAULT '',
  `google_plus` varchar(255) NOT NULL DEFAULT '',
  `linkedin` varchar(255) NOT NULL DEFAULT '',
  `t_c_title` varchar(255) NOT NULL DEFAULT '',
  `t_c_content` text NOT NULL,
  `suffix` char(200) NOT NULL DEFAULT '',
  `suffix_permanent_users` tinyint(1) NOT NULL DEFAULT 0,
  `suffix_vouchers` tinyint(1) NOT NULL DEFAULT 0,
  `suffix_devices` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realms`
--

LOCK TABLES `realms` WRITE;
/*!40000 ALTER TABLE `realms` DISABLE KEYS */;
/*!40000 ALTER TABLE `realms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registration_requests`
--

DROP TABLE IF EXISTS `registration_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `registration_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `registration_code` char(36) DEFAULT NULL,
  `state` enum('not_allocated','allocated','email_sent','verified','registration_completed','expired') DEFAULT 'not_allocated',
  `expire` datetime DEFAULT NULL,
  `email_sent` datetime DEFAULT NULL,
  `token_key` char(36) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration_requests`
--

LOCK TABLES `registration_requests` WRITE;
/*!40000 ALTER TABLE `registration_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reverse_lookups`
--

DROP TABLE IF EXISTS `reverse_lookups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reverse_lookups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(255) NOT NULL,
  `fqdn` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=322 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reverse_lookups`
--

LOCK TABLES `reverse_lookups` WRITE;
/*!40000 ALTER TABLE `reverse_lookups` DISABLE KEYS */;
/*!40000 ALTER TABLE `reverse_lookups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolling_last_day`
--

DROP TABLE IF EXISTS `rolling_last_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolling_last_day` (
  `mesh_id` int(11) NOT NULL,
  `tree_tag_id` int(11) DEFAULT NULL,
  `mesh_name` varchar(255) DEFAULT NULL,
  `tot_clients` bigint(20) DEFAULT 0,
  `tot_tx_bytes` bigint(20) DEFAULT 0,
  `tot_rx_bytes` bigint(20) DEFAULT 0,
  `tot_bytes` bigint(20) DEFAULT 0,
  `tot_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_up` bigint(20) DEFAULT 0,
  `dual_radios` bigint(20) DEFAULT 0,
  `single_radios` bigint(20) DEFAULT 0,
  `nup_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `nup_end_add_secs` float(14,2) DEFAULT 0.00,
  `nup_up_seconds` float(14,2) DEFAULT 0.00,
  `nup_down_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `ndwn_end_add_secs` float(14,2) DEFAULT 0.00,
  `ndwn_up_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_down_seconds` float(14,2) DEFAULT 0.00,
  PRIMARY KEY (`mesh_id`),
  KEY `idx_rolling_last_day_tree_tag_id` (`tree_tag_id`),
  KEY `idx_rolling_last_day_mesh_name` (`mesh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolling_last_day`
--

LOCK TABLES `rolling_last_day` WRITE;
/*!40000 ALTER TABLE `rolling_last_day` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolling_last_day` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolling_last_hour`
--

DROP TABLE IF EXISTS `rolling_last_hour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolling_last_hour` (
  `mesh_id` int(11) NOT NULL,
  `tree_tag_id` int(11) DEFAULT NULL,
  `mesh_name` varchar(255) DEFAULT NULL,
  `tot_clients` bigint(20) DEFAULT 0,
  `tot_tx_bytes` bigint(20) DEFAULT 0,
  `tot_rx_bytes` bigint(20) DEFAULT 0,
  `tot_bytes` bigint(20) DEFAULT 0,
  `tot_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_up` bigint(20) DEFAULT 0,
  `dual_radios` bigint(20) DEFAULT 0,
  `single_radios` bigint(20) DEFAULT 0,
  `nup_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `nup_end_add_secs` float(14,2) DEFAULT 0.00,
  `nup_up_seconds` float(14,2) DEFAULT 0.00,
  `nup_down_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `ndwn_end_add_secs` float(14,2) DEFAULT 0.00,
  `ndwn_up_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_down_seconds` float(14,2) DEFAULT 0.00,
  PRIMARY KEY (`mesh_id`),
  KEY `idx_rolling_last_hour_tree_tag_id` (`tree_tag_id`),
  KEY `idx_rolling_last_hour_tree_mesh_name` (`mesh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolling_last_hour`
--

LOCK TABLES `rolling_last_hour` WRITE;
/*!40000 ALTER TABLE `rolling_last_hour` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolling_last_hour` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolling_last_ninety_days`
--

DROP TABLE IF EXISTS `rolling_last_ninety_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolling_last_ninety_days` (
  `mesh_id` int(11) NOT NULL,
  `tree_tag_id` int(11) DEFAULT NULL,
  `mesh_name` varchar(255) DEFAULT NULL,
  `tot_clients` bigint(20) DEFAULT 0,
  `tot_tx_bytes` bigint(20) DEFAULT 0,
  `tot_rx_bytes` bigint(20) DEFAULT 0,
  `tot_bytes` bigint(20) DEFAULT 0,
  `tot_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_up` bigint(20) DEFAULT 0,
  `dual_radios` bigint(20) DEFAULT 0,
  `single_radios` bigint(20) DEFAULT 0,
  `nup_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `nup_end_add_secs` float(14,2) DEFAULT 0.00,
  `nup_up_seconds` float(14,2) DEFAULT 0.00,
  `nup_down_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `ndwn_end_add_secs` float(14,2) DEFAULT 0.00,
  `ndwn_up_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_down_seconds` float(14,2) DEFAULT 0.00,
  PRIMARY KEY (`mesh_id`),
  KEY `idx_rolling_last_ninety_days_tree_tag_id` (`tree_tag_id`),
  KEY `idx_rolling_last_ninety_days_mesh_name` (`mesh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolling_last_ninety_days`
--

LOCK TABLES `rolling_last_ninety_days` WRITE;
/*!40000 ALTER TABLE `rolling_last_ninety_days` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolling_last_ninety_days` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolling_last_seven_days`
--

DROP TABLE IF EXISTS `rolling_last_seven_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolling_last_seven_days` (
  `mesh_id` int(11) NOT NULL,
  `tree_tag_id` int(11) DEFAULT NULL,
  `mesh_name` varchar(255) DEFAULT NULL,
  `tot_clients` bigint(20) DEFAULT 0,
  `tot_tx_bytes` bigint(20) DEFAULT 0,
  `tot_rx_bytes` bigint(20) DEFAULT 0,
  `tot_bytes` bigint(20) DEFAULT 0,
  `tot_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_up` bigint(20) DEFAULT 0,
  `dual_radios` bigint(20) DEFAULT 0,
  `single_radios` bigint(20) DEFAULT 0,
  `nup_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `nup_end_add_secs` float(14,2) DEFAULT 0.00,
  `nup_up_seconds` float(14,2) DEFAULT 0.00,
  `nup_down_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `ndwn_end_add_secs` float(14,2) DEFAULT 0.00,
  `ndwn_up_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_down_seconds` float(14,2) DEFAULT 0.00,
  PRIMARY KEY (`mesh_id`),
  KEY `idx_rolling_last_seven_days_tree_tag_id` (`tree_tag_id`),
  KEY `idx_rolling_last_seven_days_mesh_name` (`mesh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolling_last_seven_days`
--

LOCK TABLES `rolling_last_seven_days` WRITE;
/*!40000 ALTER TABLE `rolling_last_seven_days` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolling_last_seven_days` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolling_last_sixty_days`
--

DROP TABLE IF EXISTS `rolling_last_sixty_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolling_last_sixty_days` (
  `mesh_id` int(11) NOT NULL,
  `tree_tag_id` int(11) DEFAULT NULL,
  `mesh_name` varchar(255) DEFAULT NULL,
  `tot_clients` bigint(20) DEFAULT 0,
  `tot_tx_bytes` bigint(20) DEFAULT 0,
  `tot_rx_bytes` bigint(20) DEFAULT 0,
  `tot_bytes` bigint(20) DEFAULT 0,
  `tot_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_up` bigint(20) DEFAULT 0,
  `dual_radios` bigint(20) DEFAULT 0,
  `single_radios` bigint(20) DEFAULT 0,
  `nup_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `nup_end_add_secs` float(14,2) DEFAULT 0.00,
  `nup_up_seconds` float(14,2) DEFAULT 0.00,
  `nup_down_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `ndwn_end_add_secs` float(14,2) DEFAULT 0.00,
  `ndwn_up_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_down_seconds` float(14,2) DEFAULT 0.00,
  PRIMARY KEY (`mesh_id`),
  KEY `idx_rolling_last_sixty_days_tree_tag_id` (`tree_tag_id`),
  KEY `idx_rolling_last_sixty_days_mesh_name` (`mesh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolling_last_sixty_days`
--

LOCK TABLES `rolling_last_sixty_days` WRITE;
/*!40000 ALTER TABLE `rolling_last_sixty_days` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolling_last_sixty_days` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolling_last_thirty_days`
--

DROP TABLE IF EXISTS `rolling_last_thirty_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolling_last_thirty_days` (
  `mesh_id` int(11) NOT NULL,
  `tree_tag_id` int(11) DEFAULT NULL,
  `mesh_name` varchar(255) DEFAULT NULL,
  `tot_clients` bigint(20) DEFAULT 0,
  `tot_tx_bytes` bigint(20) DEFAULT 0,
  `tot_rx_bytes` bigint(20) DEFAULT 0,
  `tot_bytes` bigint(20) DEFAULT 0,
  `tot_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes` bigint(20) DEFAULT 0,
  `tot_lv_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_down` bigint(20) DEFAULT 0,
  `tot_nodes_up` bigint(20) DEFAULT 0,
  `dual_radios` bigint(20) DEFAULT 0,
  `single_radios` bigint(20) DEFAULT 0,
  `nup_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `nup_end_add_secs` float(14,2) DEFAULT 0.00,
  `nup_up_seconds` float(14,2) DEFAULT 0.00,
  `nup_down_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_beg_remove_secs` float(14,2) DEFAULT 0.00,
  `ndwn_end_add_secs` float(14,2) DEFAULT 0.00,
  `ndwn_up_seconds` float(14,2) DEFAULT 0.00,
  `ndwn_down_seconds` float(14,2) DEFAULT 0.00,
  PRIMARY KEY (`mesh_id`),
  KEY `idx_rolling_last_thirty_days_tree_tag_id` (`tree_tag_id`),
  KEY `idx_rolling_last_thirty_days_mesh_name` (`mesh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolling_last_thirty_days`
--

LOCK TABLES `rolling_last_thirty_days` WRITE;
/*!40000 ALTER TABLE `rolling_last_thirty_days` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolling_last_thirty_days` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_entries`
--

DROP TABLE IF EXISTS `schedule_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `schedule_id` int(11) DEFAULT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `type` enum('predefined_command','command') DEFAULT 'command',
  `command` varchar(255) NOT NULL DEFAULT '',
  `predefined_command_id` int(11) DEFAULT NULL,
  `mo` tinyint(1) NOT NULL DEFAULT 0,
  `tu` tinyint(1) NOT NULL DEFAULT 0,
  `we` tinyint(1) NOT NULL DEFAULT 0,
  `th` tinyint(1) NOT NULL DEFAULT 0,
  `fr` tinyint(1) NOT NULL DEFAULT 0,
  `sa` tinyint(1) NOT NULL DEFAULT 0,
  `su` tinyint(1) NOT NULL DEFAULT 0,
  `event_time` varchar(10) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_entries`
--

LOCK TABLES `schedule_entries` WRITE;
/*!40000 ALTER TABLE `schedule_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(64) DEFAULT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `lat` decimal(11,8) DEFAULT NULL,
  `lng` decimal(11,8) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sms_histories`
--

DROP TABLE IF EXISTS `sms_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sms_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cloud_id` int(11) NOT NULL,
  `recipient` varchar(100) DEFAULT NULL,
  `reason` varchar(25) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `reply` varchar(255) DEFAULT NULL,
  `sms_provider` int(2) DEFAULT 1,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sms_histories`
--

LOCK TABLES `sms_histories` WRITE;
/*!40000 ALTER TABLE `sms_histories` DISABLE KEYS */;
/*!40000 ALTER TABLE `sms_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_login_user_realms`
--

DROP TABLE IF EXISTS `social_login_user_realms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social_login_user_realms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `social_login_user_id` int(11) DEFAULT NULL,
  `realm_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_login_user_realms`
--

LOCK TABLES `social_login_user_realms` WRITE;
/*!40000 ALTER TABLE `social_login_user_realms` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_login_user_realms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_login_users`
--

DROP TABLE IF EXISTS `social_login_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social_login_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `provider` enum('Facebook','Google','Twitter') DEFAULT 'Facebook',
  `uid` varchar(100) NOT NULL DEFAULT '',
  `name` varchar(100) NOT NULL DEFAULT '',
  `first_name` varchar(100) NOT NULL DEFAULT '',
  `last_name` varchar(100) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `image` varchar(100) NOT NULL DEFAULT '',
  `locale` varchar(5) NOT NULL DEFAULT '',
  `timezone` tinyint(1) NOT NULL DEFAULT 0,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('male','female') DEFAULT 'male',
  `last_connect_time` datetime DEFAULT NULL,
  `extra_name` varchar(100) NOT NULL DEFAULT '',
  `extra_value` varchar(100) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_login_users`
--

LOCK TABLES `social_login_users` WRITE;
/*!40000 ALTER TABLE `social_login_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_login_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `softflows`
--

DROP TABLE IF EXISTS `softflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `softflows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dynamic_client_id` int(11) DEFAULT NULL,
  `username` varchar(64) DEFAULT NULL,
  `src_mac` varchar(64) DEFAULT NULL,
  `src_ip` varchar(64) DEFAULT NULL,
  `dst_ip` varchar(64) DEFAULT NULL,
  `src_port` int(11) DEFAULT NULL,
  `dst_port` int(11) DEFAULT NULL,
  `proto` int(11) DEFAULT NULL,
  `pckt_in` int(11) DEFAULT NULL,
  `pckt_out` int(11) DEFAULT NULL,
  `oct_in` bigint(20) DEFAULT NULL,
  `oct_out` bigint(20) DEFAULT NULL,
  `start` datetime DEFAULT NULL,
  `finish` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `softflows`
--

LOCK TABLES `softflows` WRITE;
/*!40000 ALTER TABLE `softflows` DISABLE KEYS */;
/*!40000 ALTER TABLE `softflows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_flow_logs`
--

DROP TABLE IF EXISTS `temp_flow_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_flow_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `mesh_id` int(11) DEFAULT NULL,
  `ap_id` int(11) DEFAULT NULL,
  `ap_profile_id` int(11) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `proto` int(11) NOT NULL,
  `src_mac` varchar(255) NOT NULL,
  `src_ip` varchar(255) NOT NULL,
  `src_port` int(11) NOT NULL,
  `dst_ip` varchar(255) NOT NULL,
  `dst_port` int(11) NOT NULL,
  `oct_in` int(11) NOT NULL,
  `pckt_in` int(11) NOT NULL,
  `oct_out` int(11) NOT NULL,
  `pckt_out` int(11) NOT NULL,
  `start` datetime NOT NULL,
  `finish` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_flow_logs`
--

LOCK TABLES `temp_flow_logs` WRITE;
/*!40000 ALTER TABLE `temp_flow_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `temp_flow_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_proxy_logs`
--

DROP TABLE IF EXISTS `temp_proxy_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_proxy_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) DEFAULT NULL,
  `mesh_id` int(11) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `host` varchar(255) NOT NULL,
  `source_ip` varchar(255) NOT NULL,
  `mac` varchar(255) NOT NULL,
  `full_string` text DEFAULT NULL,
  `full_url` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2072 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_proxy_logs`
--

LOCK TABLES `temp_proxy_logs` WRITE;
/*!40000 ALTER TABLE `temp_proxy_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `temp_proxy_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_reports`
--

DROP TABLE IF EXISTS `temp_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mesh_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `ap_id` int(11) NOT NULL,
  `ap_profile_id` int(11) NOT NULL,
  `report` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1020 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_reports`
--

LOCK TABLES `temp_reports` WRITE;
/*!40000 ALTER TABLE `temp_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `temp_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timezones`
--

DROP TABLE IF EXISTS `timezones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timezones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `value` varchar(64) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=397 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timezones`
--

LOCK TABLES `timezones` WRITE;
/*!40000 ALTER TABLE `timezones` DISABLE KEYS */;
INSERT INTO `timezones` VALUES (1,'Africa/Abidjan','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(2,'Africa/Accra','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(3,'Africa/Addis_Ababa','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(4,'Africa/Algiers','CET-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(5,'Africa/Asmara','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(6,'Africa/Bamako','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(7,'Africa/Bangui','WAT-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(8,'Africa/Banjul','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(9,'Africa/Bissau','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(10,'Africa/Blantyre','CAT-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(12,'Africa/Bujumbura','CAT-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(13,'Africa/Casablanca','WET0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(14,'Africa/Ceuta','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(15,'Africa/Conakry','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(16,'Africa/Dakar','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(17,'Africa/Dar_es_Salaam','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(18,'Africa/Djibouti','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(19,'Africa/Douala','WAT-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(20,'Africa/El_Aaiun','WET0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(21,'Africa/Freetown','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(22,'Africa/Gaborone','CAT-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(23,'Africa/Harare','CAT-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(24,'Africa/Johannesburg','SAST-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(25,'Africa/Kampala','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(26,'Africa/Khartoum','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(27,'Africa/Kigali','CAT-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(28,'Africa/Kinshasa','WAT-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(29,'Africa/Lagos','WAT-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(30,'Africa/Libreville','WAT-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(31,'Africa/Lome','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(32,'Africa/Luanda','WAT-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(33,'Africa/Lubumbashi','CAT-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(34,'Africa/Lusaka','CAT-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(35,'Africa/Malabo','WAT-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(36,'Africa/Maputo','CAT-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(37,'Africa/Maseru','SAST-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(38,'Africa/Mbabane','SAST-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(39,'Africa/Mogadishu','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(40,'Africa/Monrovia','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(41,'Africa/Nairobi','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(42,'Africa/Ndjamena','WAT-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(43,'Africa/Niamey','WAT-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(44,'Africa/Nouakchott','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(45,'Africa/Ouagadougou','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(46,'Africa/Porto-Novo','WAT-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(47,'Africa/Sao_Tome','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(48,'Africa/Tripoli','EET-2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(49,'Africa/Tunis','CET-1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(50,'Africa/Windhoek','WAT-1WAST,M9.1.0,M4.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(51,'America/Adak','HAST10HADT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(52,'America/Anchorage','AKST9AKDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(53,'America/Anguilla','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(54,'America/Antigua','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(55,'America/Araguaina','BRT3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(56,'America/Argentina/Buenos_Aires','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(57,'America/Argentina/Catamarca','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(58,'America/Argentina/Cordoba','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(59,'America/Argentina/Jujuy','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(60,'America/Argentina/La_Rioja','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(61,'America/Argentina/Mendoza','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(62,'America/Argentina/Rio_Gallegos','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(63,'America/Argentina/Salta','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(64,'America/Argentina/San_Juan','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(65,'America/Argentina/Tucuman','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(66,'America/Argentina/Ushuaia','ART3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(67,'America/Aruba','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(68,'America/Asuncion','PYT4PYST,M10.1.0/0,M4.2.0/0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(69,'America/Atikokan','EST5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(70,'America/Bahia','BRT3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(71,'America/Barbados','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(72,'America/Belem','BRT3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(73,'America/Belize','CST6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(74,'America/Blanc-Sablon','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(75,'America/Boa_Vista','AMT4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(76,'America/Bogota','COT5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(77,'America/Boise','MST7MDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(78,'America/Cambridge_Bay','MST7MDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(79,'America/Campo_Grande','AMT4AMST,M10.3.0/0,M2.3.0/0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(80,'America/Cancun','CST6CDT,M4.1.0,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(81,'America/Cayenne','GFT3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(82,'America/Cayman','EST5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(83,'America/Chicago','CST6CDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(84,'America/Chihuahua','MST7MDT,M4.1.0,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(85,'America/Costa_Rica','CST6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(86,'America/Cuiaba','AMT4AMST,M10.3.0/0,M2.3.0/0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(87,'America/Curacao','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(88,'America/Danmarkshavn','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(89,'America/Dawson','PST8PDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(90,'America/Dawson_Creek','MST7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(91,'America/Denver','MST7MDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(92,'America/Detroit','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(93,'America/Dominica','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(94,'America/Edmonton','MST7MDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(95,'America/Eirunepe','AMT4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(96,'America/El_Salvador','CST6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(97,'America/Fortaleza','BRT3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(98,'America/Glace_Bay','AST4ADT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(99,'America/Goose_Bay','AST4ADT,M3.2.0/0:01,M11.1.0/0:01','2020-06-02 08:58:48','2020-06-02 08:58:48'),(100,'America/Grand_Turk','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(101,'America/Grenada','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(102,'America/Guadeloupe','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(103,'America/Guatemala','CST6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(104,'America/Guayaquil','ECT5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(105,'America/Guyana','GYT4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(106,'America/Halifax','AST4ADT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(107,'America/Havana','CST5CDT,M3.2.0/0,M10.5.0/1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(108,'America/Hermosillo','MST7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(109,'America/Indiana/Indianapolis','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(110,'America/Indiana/Knox','CST6CDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(111,'America/Indiana/Marengo','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(112,'America/Indiana/Petersburg','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(113,'America/Indiana/Tell_City','CST6CDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(114,'America/Indiana/Vevay','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(115,'America/Indiana/Vincennes','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(116,'America/Indiana/Winamac','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(117,'America/Inuvik','MST7MDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(118,'America/Iqaluit','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(119,'America/Jamaica','EST5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(120,'America/Juneau','AKST9AKDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(121,'America/Kentucky/Louisville','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(122,'America/Kentucky/Monticello','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(123,'America/La_Paz','BOT4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(124,'America/Lima','PET5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(125,'America/Los_Angeles','PST8PDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(126,'America/Maceio','BRT3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(127,'America/Managua','CST6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(128,'America/Manaus','AMT4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(129,'America/Marigot','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(130,'America/Martinique','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(131,'America/Matamoros','CST6CDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(132,'America/Mazatlan','MST7MDT,M4.1.0,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(133,'America/Menominee','CST6CDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(134,'America/Merida','CST6CDT,M4.1.0,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(135,'America/Mexico_City','CST6CDT,M4.1.0,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(136,'America/Miquelon','PMST3PMDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(137,'America/Moncton','AST4ADT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(138,'America/Monterrey','CST6CDT,M4.1.0,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(139,'America/Montevideo','UYT3UYST,M10.1.0,M3.2.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(140,'America/Montreal','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(141,'America/Montserrat','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(142,'America/Nassau','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(143,'America/New_York','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(144,'America/Nipigon','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(145,'America/Nome','AKST9AKDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(146,'America/Noronha','FNT2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(147,'America/North_Dakota/Center','CST6CDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(148,'America/North_Dakota/New_Salem','CST6CDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(149,'America/Ojinaga','MST7MDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(150,'America/Panama','EST5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(151,'America/Pangnirtung','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(152,'America/Paramaribo','SRT3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(153,'America/Phoenix','MST7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(154,'America/Port_of_Spain','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(155,'America/Port-au-Prince','EST5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(156,'America/Porto_Velho','AMT4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(157,'America/Puerto_Rico','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(158,'America/Rainy_River','CST6CDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(159,'America/Rankin_Inlet','CST6CDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(160,'America/Recife','BRT3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(161,'America/Regina','CST6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(162,'America/Rio_Branco','AMT4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(163,'America/Santa_Isabel','PST8PDT,M4.1.0,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(164,'America/Santarem','BRT3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(165,'America/Santo_Domingo','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(166,'America/Sao_Paulo','BRT3BRST,M10.3.0/0,M2.3.0/0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(167,'America/Scoresbysund','EGT1EGST,M3.5.0/0,M10.5.0/1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(168,'America/Shiprock','MST7MDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(169,'America/St_Barthelemy','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(170,'America/St_Johns','NST3:30NDT,M3.2.0/0:01,M11.1.0/0:01','2020-06-02 08:58:48','2020-06-02 08:58:48'),(171,'America/St_Kitts','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(172,'America/St_Lucia','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(173,'America/St_Thomas','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(174,'America/St_Vincent','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(175,'America/Swift_Current','CST6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(176,'America/Tegucigalpa','CST6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(177,'America/Thule','AST4ADT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(178,'America/Thunder_Bay','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(179,'America/Tijuana','PST8PDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(180,'America/Toronto','EST5EDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(181,'America/Tortola','AST4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(182,'America/Vancouver','PST8PDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(183,'America/Whitehorse','PST8PDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(184,'America/Winnipeg','CST6CDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(185,'America/Yakutat','AKST9AKDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(186,'America/Yellowknife','MST7MDT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(187,'Antarctica/Casey','WST-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(188,'Antarctica/Davis','DAVT-7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(189,'Antarctica/DumontDUrville','DDUT-10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(190,'Antarctica/Macquarie','MIST-11','2020-06-02 08:58:48','2020-06-02 08:58:48'),(191,'Antarctica/Mawson','MAWT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(192,'Antarctica/McMurdo','NZST-12NZDT,M9.5.0,M4.1.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(193,'Antarctica/Rothera','ROTT3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(194,'Antarctica/South_Pole','NZST-12NZDT,M9.5.0,M4.1.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(195,'Antarctica/Syowa','SYOT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(196,'Antarctica/Vostok','VOST-6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(197,'Arctic/Longyearbyen','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(198,'Asia/Aden','AST-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(199,'Asia/Almaty','ALMT-6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(200,'Asia/Anadyr','ANAT-11ANAST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(201,'Asia/Aqtau','AQTT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(202,'Asia/Aqtobe','AQTT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(203,'Asia/Ashgabat','TMT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(204,'Asia/Baghdad','AST-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(205,'Asia/Bahrain','AST-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(206,'Asia/Baku','AZT-4AZST,M3.5.0/4,M10.5.0/5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(207,'Asia/Bangkok','ICT-7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(208,'Asia/Beirut','EET-2EEST,M3.5.0/0,M10.5.0/0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(209,'Asia/Bishkek','KGT-6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(210,'Asia/Brunei','BNT-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(211,'Asia/Choibalsan','CHOT-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(212,'Asia/Chongqing','CST-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(213,'Asia/Colombo','IST-5:30','2020-06-02 08:58:48','2020-06-02 08:58:48'),(214,'Asia/Damascus','EET-2EEST,M4.1.5/0,M10.5.5/0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(215,'Asia/Dhaka','BDT-6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(216,'Asia/Dili','TLT-9','2020-06-02 08:58:48','2020-06-02 08:58:48'),(217,'Asia/Dubai','GST-4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(218,'Asia/Dushanbe','TJT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(219,'Asia/Gaza','EET-2EEST,M3.5.6/0:01,M9.1.5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(220,'Asia/Harbin','CST-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(221,'Asia/Ho_Chi_Minh','ICT-7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(222,'Asia/Hong_Kong','HKT-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(223,'Asia/Hovd','HOVT-7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(224,'Asia/Irkutsk','IRKT-8IRKST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(225,'Asia/Jakarta','WIT-7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(226,'Asia/Jayapura','EIT-9','2020-06-02 08:58:48','2020-06-02 08:58:48'),(227,'Asia/Kabul','AFT-4:30','2020-06-02 08:58:48','2020-06-02 08:58:48'),(228,'Asia/Kamchatka','PETT-11PETST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(229,'Asia/Karachi','PKT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(230,'Asia/Kashgar','CST-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(231,'Asia/Kathmandu','NPT-5:45','2020-06-02 08:58:48','2020-06-02 08:58:48'),(232,'Asia/Kolkata','IST-5:30','2020-06-02 08:58:48','2020-06-02 08:58:48'),(233,'Asia/Krasnoyarsk','KRAT-7KRAST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(234,'Asia/Kuala_Lumpur','MYT-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(235,'Asia/Kuching','MYT-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(236,'Asia/Kuwait','AST-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(237,'Asia/Macau','CST-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(238,'Asia/Magadan','MAGT-11MAGST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(239,'Asia/Makassar','CIT-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(240,'Asia/Manila','PHT-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(241,'Asia/Muscat','GST-4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(242,'Asia/Nicosia','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(243,'Asia/Novokuznetsk','NOVT-6NOVST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(244,'Asia/Novosibirsk','NOVT-6NOVST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(245,'Asia/Omsk','OMST-7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(246,'Asia/Oral','ORAT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(247,'Asia/Phnom_Penh','ICT-7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(248,'Asia/Pontianak','WIT-7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(249,'Asia/Pyongyang','KST-9','2020-06-02 08:58:48','2020-06-02 08:58:48'),(250,'Asia/Qatar','AST-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(251,'Asia/Qyzylorda','QYZT-6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(252,'Asia/Rangoon','MMT-6:30','2020-06-02 08:58:48','2020-06-02 08:58:48'),(253,'Asia/Riyadh','AST-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(254,'Asia/Sakhalin','SAKT-10SAKST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(255,'Asia/Samarkand','UZT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(256,'Asia/Seoul','KST-9','2020-06-02 08:58:48','2020-06-02 08:58:48'),(257,'Asia/Shanghai','CST-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(258,'Asia/Singapore','SGT-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(259,'Asia/Taipei','CST-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(260,'Asia/Tashkent','UZT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(261,'Asia/Tbilisi','GET-4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(262,'Asia/Tehran','IRST-3:30IRDT,80/0,264/0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(263,'Asia/Thimphu','BTT-6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(264,'Asia/Tokyo','JST-9','2020-06-02 08:58:48','2020-06-02 08:58:48'),(265,'Asia/Ulaanbaatar','ULAT-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(266,'Asia/Urumqi','CST-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(267,'Asia/Vientiane','ICT-7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(268,'Asia/Vladivostok','VLAT-10VLAST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(269,'Asia/Yakutsk','YAKT-9YAKST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(270,'Asia/Yekaterinburg','YEKT-5YEKST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(271,'Asia/Yerevan','AMT-4AMST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(272,'Atlantic/Azores','AZOT1AZOST,M3.5.0/0,M10.5.0/1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(273,'Atlantic/Bermuda','AST4ADT,M3.2.0,M11.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(274,'Atlantic/Canary','WET0WEST,M3.5.0/1,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(275,'Atlantic/Cape_Verde','CVT1','2020-06-02 08:58:48','2020-06-02 08:58:48'),(276,'Atlantic/Faroe','WET0WEST,M3.5.0/1,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(277,'Atlantic/Madeira','WET0WEST,M3.5.0/1,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(278,'Atlantic/Reykjavik','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(279,'Atlantic/South_Georgia','GST2','2020-06-02 08:58:48','2020-06-02 08:58:48'),(280,'Atlantic/St_Helena','GMT0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(281,'Atlantic/Stanley','FKT4FKST,M9.1.0,M4.3.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(282,'Australia/Adelaide','CST-9:30CST,M10.1.0,M4.1.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(283,'Australia/Brisbane','EST-10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(284,'Australia/Broken_Hill','CST-9:30CST,M10.1.0,M4.1.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(285,'Australia/Currie','EST-10EST,M10.1.0,M4.1.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(286,'Australia/Darwin','CST-9:30','2020-06-02 08:58:48','2020-06-02 08:58:48'),(287,'Australia/Eucla','CWST-8:45','2020-06-02 08:58:48','2020-06-02 08:58:48'),(288,'Australia/Hobart','EST-10EST,M10.1.0,M4.1.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(289,'Australia/Lindeman','EST-10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(290,'Australia/Lord_Howe','LHST-10:30LHST-11,M10.1.0,M4.1.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(291,'Australia/Melbourne','EST-10EST,M10.1.0,M4.1.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(292,'Australia/Perth','WST-8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(293,'Australia/Sydney','EST-10EST,M10.1.0,M4.1.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(294,'Europe/Amsterdam','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(295,'Europe/Andorra','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(296,'Europe/Athens','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(297,'Europe/Belgrade','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(298,'Europe/Berlin','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(299,'Europe/Bratislava','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(300,'Europe/Brussels','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(301,'Europe/Bucharest','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(302,'Europe/Budapest','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(303,'Europe/Chisinau','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(304,'Europe/Copenhagen','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(305,'Europe/Dublin','GMT0IST,M3.5.0/1,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(306,'Europe/Gibraltar','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(307,'Europe/Guernsey','GMT0BST,M3.5.0/1,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(308,'Europe/Helsinki','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(309,'Europe/Isle_of_Man','GMT0BST,M3.5.0/1,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(310,'Europe/Istanbul','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(311,'Europe/Jersey','GMT0BST,M3.5.0/1,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(312,'Europe/Kaliningrad','EET-2EEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(313,'Europe/Kiev','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(314,'Europe/Lisbon','WET0WEST,M3.5.0/1,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(315,'Europe/Ljubljana','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(316,'Europe/London','GMT0BST,M3.5.0/1,M10.5.0','2020-06-02 08:58:48','2020-06-02 08:58:48'),(317,'Europe/Luxembourg','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(318,'Europe/Madrid','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(319,'Europe/Malta','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(320,'Europe/Mariehamn','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(321,'Europe/Minsk','EET-2EEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(322,'Europe/Monaco','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(323,'Europe/Moscow','MSK-4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(324,'Europe/Oslo','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(325,'Europe/Paris','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(326,'Europe/Podgorica','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(327,'Europe/Prague','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(328,'Europe/Riga','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(329,'Europe/Rome','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(330,'Europe/Samara','SAMT-3SAMST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(331,'Europe/San_Marino','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(332,'Europe/Sarajevo','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(333,'Europe/Simferopol','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(334,'Europe/Skopje','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(335,'Europe/Sofia','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(336,'Europe/Stockholm','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(337,'Europe/Tallinn','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(338,'Europe/Tirane','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(339,'Europe/Uzhgorod','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(340,'Europe/Vaduz','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(341,'Europe/Vatican','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(342,'Europe/Vienna','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(343,'Europe/Vilnius','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(344,'Europe/Volgograd','VOLT-3VOLST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(345,'Europe/Warsaw','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(346,'Europe/Zagreb','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(347,'Europe/Zaporozhye','EET-2EEST,M3.5.0/3,M10.5.0/4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(348,'Europe/Zurich','CET-1CEST,M3.5.0,M10.5.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(349,'Indian/Antananarivo','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(350,'Indian/Chagos','IOT-6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(351,'Indian/Christmas','CXT-7','2020-06-02 08:58:48','2020-06-02 08:58:48'),(352,'Indian/Cocos','CCT-6:30','2020-06-02 08:58:48','2020-06-02 08:58:48'),(353,'Indian/Comoro','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(354,'Indian/Kerguelen','TFT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(355,'Indian/Mahe','SCT-4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(356,'Indian/Maldives','MVT-5','2020-06-02 08:58:48','2020-06-02 08:58:48'),(357,'Indian/Mauritius','MUT-4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(358,'Indian/Mayotte','EAT-3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(359,'Indian/Reunion','RET-4','2020-06-02 08:58:48','2020-06-02 08:58:48'),(360,'Pacific/Apia','WST11','2020-06-02 08:58:48','2020-06-02 08:58:48'),(361,'Pacific/Auckland','NZST-12NZDT,M9.5.0,M4.1.0/3','2020-06-02 08:58:48','2020-06-02 08:58:48'),(362,'Pacific/Chatham','CHAST-12:45CHADT,M9.5.0/2:45,M4.1.0/3:45','2020-06-02 08:58:48','2020-06-02 08:58:48'),(363,'Pacific/Efate','VUT-11','2020-06-02 08:58:48','2020-06-02 08:58:48'),(364,'Pacific/Enderbury','PHOT-13','2020-06-02 08:58:48','2020-06-02 08:58:48'),(365,'Pacific/Fakaofo','TKT10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(366,'Pacific/Fiji','FJT-12','2020-06-02 08:58:48','2020-06-02 08:58:48'),(367,'Pacific/Funafuti','TVT-12','2020-06-02 08:58:48','2020-06-02 08:58:48'),(368,'Pacific/Galapagos','GALT6','2020-06-02 08:58:48','2020-06-02 08:58:48'),(369,'Pacific/Gambier','GAMT9','2020-06-02 08:58:48','2020-06-02 08:58:48'),(370,'Pacific/Guadalcanal','SBT-11','2020-06-02 08:58:48','2020-06-02 08:58:48'),(371,'Pacific/Guam','ChST-10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(372,'Pacific/Honolulu','HST10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(373,'Pacific/Johnston','HST10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(374,'Pacific/Kiritimati','LINT-14','2020-06-02 08:58:48','2020-06-02 08:58:48'),(375,'Pacific/Kosrae','KOST-11','2020-06-02 08:58:48','2020-06-02 08:58:48'),(376,'Pacific/Kwajalein','MHT-12','2020-06-02 08:58:48','2020-06-02 08:58:48'),(377,'Pacific/Majuro','MHT-12','2020-06-02 08:58:48','2020-06-02 08:58:48'),(378,'Pacific/Marquesas','MART9:30','2020-06-02 08:58:48','2020-06-02 08:58:48'),(379,'Pacific/Midway','SST11','2020-06-02 08:58:48','2020-06-02 08:58:48'),(380,'Pacific/Nauru','NRT-12','2020-06-02 08:58:48','2020-06-02 08:58:48'),(381,'Pacific/Niue','NUT11','2020-06-02 08:58:48','2020-06-02 08:58:48'),(382,'Pacific/Norfolk','NFT-11:30','2020-06-02 08:58:48','2020-06-02 08:58:48'),(383,'Pacific/Noumea','NCT-11','2020-06-02 08:58:48','2020-06-02 08:58:48'),(384,'Pacific/Pago_Pago','SST11','2020-06-02 08:58:48','2020-06-02 08:58:48'),(385,'Pacific/Palau','PWT-9','2020-06-02 08:58:48','2020-06-02 08:58:48'),(386,'Pacific/Pitcairn','PST8','2020-06-02 08:58:48','2020-06-02 08:58:48'),(387,'Pacific/Ponape','PONT-11','2020-06-02 08:58:48','2020-06-02 08:58:48'),(388,'Pacific/Port_Moresby','PGT-10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(389,'Pacific/Rarotonga','CKT10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(390,'Pacific/Saipan','ChST-10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(391,'Pacific/Tahiti','TAHT10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(392,'Pacific/Tarawa','GILT-12','2020-06-02 08:58:48','2020-06-02 08:58:48'),(393,'Pacific/Tongatapu','TOT-13','2020-06-02 08:58:48','2020-06-02 08:58:48'),(394,'Pacific/Truk','TRUT-10','2020-06-02 08:58:48','2020-06-02 08:58:48'),(395,'Pacific/Wake','WAKT-12','2020-06-02 08:58:48','2020-06-02 08:58:48'),(396,'Pacific/Wallis','WFT-12','2020-06-02 08:58:48','2020-06-02 08:58:48');
/*!40000 ALTER TABLE `timezones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_up_transactions`
--

DROP TABLE IF EXISTS `top_up_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_up_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `permanent_user_id` int(11) DEFAULT NULL,
  `permanent_user` varchar(255) DEFAULT NULL,
  `top_up_id` int(11) DEFAULT NULL,
  `type` enum('data','time','days_to_use') DEFAULT 'data',
  `action` enum('create','update','delete') DEFAULT 'create',
  `radius_attribute` varchar(30) NOT NULL DEFAULT '',
  `old_value` varchar(30) DEFAULT NULL,
  `new_value` varchar(30) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_up_transactions`
--

LOCK TABLES `top_up_transactions` WRITE;
/*!40000 ALTER TABLE `top_up_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_up_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_ups`
--

DROP TABLE IF EXISTS `top_ups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_ups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cloud_id` int(11) DEFAULT NULL,
  `permanent_user_id` int(11) DEFAULT NULL,
  `data` bigint(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `days_to_use` int(11) DEFAULT NULL,
  `comment` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `type` enum('data','time','days_to_use') DEFAULT 'data',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_ups`
--

LOCK TABLES `top_ups` WRITE;
/*!40000 ALTER TABLE `top_ups` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_ups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unknown_dynamic_clients`
--

DROP TABLE IF EXISTS `unknown_dynamic_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unknown_dynamic_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nasidentifier` varchar(128) NOT NULL DEFAULT '',
  `calledstationid` varchar(128) NOT NULL DEFAULT '',
  `last_contact` datetime DEFAULT NULL,
  `last_contact_ip` varchar(128) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nasidentifier` (`nasidentifier`),
  UNIQUE KEY `calledstationid` (`calledstationid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unknown_dynamic_clients`
--

LOCK TABLES `unknown_dynamic_clients` WRITE;
/*!40000 ALTER TABLE `unknown_dynamic_clients` DISABLE KEYS */;
/*!40000 ALTER TABLE `unknown_dynamic_clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unknown_nodes`
--

DROP TABLE IF EXISTS `unknown_nodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unknown_nodes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mac` varchar(255) NOT NULL,
  `vendor` varchar(255) DEFAULT NULL,
  `from_ip` varchar(15) NOT NULL DEFAULT '',
  `gateway` tinyint(1) NOT NULL DEFAULT 1,
  `last_contact` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `new_server` varchar(255) NOT NULL DEFAULT '',
  `new_server_status` enum('awaiting','fetched','replied') DEFAULT 'awaiting',
  `name` varchar(255) NOT NULL DEFAULT '',
  `firmware_key_id` int(11) DEFAULT NULL,
  `new_server_protocol` enum('https','http') DEFAULT NULL,
  `new_mode` enum('ap','mesh') DEFAULT NULL,
  `new_mode_status` enum('awaiting','fetched','replied') DEFAULT 'awaiting',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unknown_nodes`
--

LOCK TABLES `unknown_nodes` WRITE;
/*!40000 ALTER TABLE `unknown_nodes` DISABLE KEYS */;
/*!40000 ALTER TABLE `unknown_nodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_settings`
--

DROP TABLE IF EXISTS `user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_settings_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=483 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_settings`
--

LOCK TABLES `user_settings` WRITE;
/*!40000 ALTER TABLE `user_settings` DISABLE KEYS */;
INSERT INTO `user_settings` VALUES (91,-1,'UserStatsLastRun','1714462802','2019-11-12 19:00:03','2024-04-30 07:40:02'),(110,-1,'password','admin','2021-06-26 06:47:40','2021-06-26 06:47:40'),(111,-1,'country','ZA','2021-06-26 06:47:40','2022-08-26 18:36:42'),(112,-1,'timezone','24','2021-06-26 06:47:40','2021-06-26 06:47:40'),(113,-1,'heartbeat_dead_after','900','2021-06-26 06:47:40','2021-10-25 22:12:37'),(114,-1,'cp_radius_1','192.168.8.220','2021-06-26 06:47:40','2021-10-25 22:12:37'),(115,-1,'cp_radius_2','','2021-06-26 06:47:40','2021-06-26 06:47:40'),(116,-1,'cp_radius_secret','testing123','2021-06-26 06:47:40','2021-06-26 06:47:40'),(117,-1,'cp_uam_url','http://192.168.8.220/cake4/rd_cake/dynamic-details/chilli-browser-detect/','2021-06-26 06:47:40','2022-08-26 18:37:10'),(118,-1,'cp_uam_secret','greatsecret','2021-06-26 06:47:40','2021-06-26 06:47:40'),(119,-1,'cp_swap_octet','0','2021-06-26 06:47:40','2022-08-12 04:48:16'),(120,-1,'cp_mac_auth','0','2021-06-26 06:47:40','2022-08-12 04:48:16'),(121,-1,'cp_coova_optional','','2021-06-26 06:47:40','2021-06-26 06:47:40'),(122,-1,'email_enabled','0','2021-06-26 06:47:40','2021-06-26 06:47:40'),(123,-1,'email_ssl','0','2021-06-26 06:47:40','2021-06-26 06:47:40'),(124,-1,'s_k','xJ3ktaC39H','2021-10-25 22:15:38','2021-10-25 22:15:38'),(125,-1,'s_iv','anSYCDY1C9','2021-10-25 22:15:38','2021-10-25 22:15:38'),(126,-1,'s_l','Ryttd0xFdFZTK210Z2JFOGw4c0M1WTdtOUJxeXRGdnBDZnduNHRUS0xzcz0=','2021-10-25 22:36:29','2021-10-25 22:36:29'),(450,44,'wl_active','1','2022-08-08 14:12:09','2022-08-08 14:12:09'),(451,44,'wl_header','RADIUSdesk','2022-08-08 14:12:09','2022-08-08 14:12:09'),(452,44,'wl_h_bg','ffffff','2022-08-08 14:12:09','2022-08-08 14:12:09'),(453,44,'wl_h_fg','005691','2022-08-08 14:12:09','2022-08-08 14:12:09'),(454,44,'wl_footer','RADIUSdesk 2022','2022-08-08 14:12:09','2022-08-08 14:12:09'),(455,44,'wl_img_active','1','2022-08-08 14:12:09','2022-08-08 14:12:09'),(456,44,'wl_img_file','logo.png','2022-08-08 14:12:09','2022-08-08 14:12:09'),(457,44,'compact_view','1','2022-08-08 14:12:09','2022-08-08 14:12:09'),(458,-1,'cloud_id','21','2022-08-12 04:48:16','2022-08-23 12:57:40'),(459,-1,'mqtt_enabled','0','2022-08-12 04:48:40','2022-08-12 04:48:40'),(460,-1,'api_mqtt_enabled','0','2022-08-12 04:48:40','2022-08-12 04:48:40'),(461,-1,'sms_1_enabled','0','2022-08-12 04:56:51','2022-08-12 04:56:51'),(462,-1,'sms_1_ssl_verify_peer','0','2022-08-12 04:56:51','2022-08-12 04:56:51'),(463,-1,'sms_1_ssl_verify_host','0','2022-08-12 04:56:51','2022-08-12 04:56:51'),(464,-1,'sms_2_enabled','0','2022-08-12 04:56:55','2022-08-12 04:56:55'),(465,-1,'sms_2_ssl_verify_peer','0','2022-08-12 04:56:55','2022-08-12 04:56:55'),(466,-1,'sms_2_ssl_verify_host','0','2022-08-12 04:56:55','2022-08-12 04:56:55'),(467,-1,'report_adv_proto','http','2022-08-23 12:57:40','2022-08-23 12:57:40'),(468,-1,'report_adv_light','60','2022-08-23 12:57:40','2022-08-23 12:57:40'),(469,-1,'report_adv_full','600','2022-08-23 12:57:40','2022-08-23 12:57:40'),(470,-1,'report_adv_sampling','60','2022-08-23 12:57:40','2022-08-23 12:57:40'),(471,-1,'UserStatsCompactingStoppedAt','1661472000','2022-08-25 03:10:02','2022-08-26 03:10:02'),(472,-1,'UserStatsDailiesStoppedAt','1661472000','2022-08-25 04:10:01','2022-08-26 04:10:02');
/*!40000 ALTER TABLE `user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_ssids`
--

DROP TABLE IF EXISTS `user_ssids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_ssids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `ssidname` varchar(64) NOT NULL DEFAULT '',
  `priority` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `username` (`username`(32)),
  KEY `idx_user_ssids_username` (`username`),
  KEY `idx_user_ssids_ssidname` (`ssidname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_ssids`
--

LOCK TABLES `user_ssids` WRITE;
/*!40000 ALTER TABLE `user_ssids` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_ssids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_stats`
--

DROP TABLE IF EXISTS `user_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `radacct_id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `realm` varchar(64) DEFAULT '',
  `nasipaddress` varchar(15) NOT NULL DEFAULT '',
  `nasidentifier` varchar(64) NOT NULL DEFAULT '',
  `framedipaddress` varchar(15) NOT NULL DEFAULT '',
  `callingstationid` varchar(50) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `acctinputoctets` bigint(20) NOT NULL,
  `acctoutputoctets` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `us_realm_timestamp` (`realm`,`timestamp`),
  KEY `us_username_timestamp` (`username`,`timestamp`),
  KEY `us_nasidentifier_timestamp` (`nasidentifier`,`timestamp`),
  KEY `us_callingstationid_timestamp` (`callingstationid`,`timestamp`),
  KEY `us_radacct_id` (`radacct_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_stats`
--

LOCK TABLES `user_stats` WRITE;
/*!40000 ALTER TABLE `user_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_stats_dailies`
--

DROP TABLE IF EXISTS `user_stats_dailies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_stats_dailies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_stat_id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `realm` varchar(64) DEFAULT '',
  `nasidentifier` varchar(64) NOT NULL DEFAULT '',
  `callingstationid` varchar(50) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `acctinputoctets` bigint(20) NOT NULL,
  `acctoutputoctets` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usd_realm_timestamp` (`realm`,`timestamp`),
  KEY `usd_username_timestamp` (`username`,`timestamp`),
  KEY `usd_nasidentifier_timestamp` (`nasidentifier`,`timestamp`),
  KEY `usd_callingstationid_timestamp` (`callingstationid`,`timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_stats_dailies`
--

LOCK TABLES `user_stats_dailies` WRITE;
/*!40000 ALTER TABLE `user_stats_dailies` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_stats_dailies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(50) NOT NULL,
  `token` char(36) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `country_id` int(11) DEFAULT NULL,
  `group_id` int(11) NOT NULL,
  `language_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `timezone_id` int(11) DEFAULT 316,
  PRIMARY KEY (`id`),
  KEY `idx_users_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (44,'root','9b2b0416194bfdd0db089b9c09fad3163eae5383','b4c6ac81-8c7c-4802-b50a-0a6380555b50','root','','','','',1,4,8,4,'2012-12-10 13:14:13','2021-06-26 06:02:53',24);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vouchers`
--

DROP TABLE IF EXISTS `vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vouchers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `batch` varchar(128) NOT NULL DEFAULT '',
  `status` enum('new','used','depleted','expired') DEFAULT 'new',
  `perc_time_used` int(6) DEFAULT NULL,
  `perc_data_used` int(6) DEFAULT NULL,
  `last_accept_time` datetime DEFAULT NULL,
  `last_reject_time` datetime DEFAULT NULL,
  `last_accept_nas` varchar(128) DEFAULT NULL,
  `last_reject_nas` varchar(128) DEFAULT NULL,
  `last_reject_message` varchar(255) DEFAULT NULL,
  `cloud_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `extra_name` varchar(100) NOT NULL DEFAULT '',
  `extra_value` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(30) NOT NULL DEFAULT '',
  `realm` varchar(50) NOT NULL DEFAULT '',
  `realm_id` int(11) DEFAULT NULL,
  `profile` varchar(50) NOT NULL DEFAULT '',
  `profile_id` int(11) DEFAULT NULL,
  `expire` datetime DEFAULT NULL,
  `time_valid` varchar(10) NOT NULL DEFAULT '',
  `data_used` bigint(20) DEFAULT NULL,
  `data_cap` bigint(20) DEFAULT NULL,
  `time_used` int(12) DEFAULT NULL,
  `time_cap` int(12) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ak_vouchers` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchers`
--

LOCK TABLES `vouchers` WRITE;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-30  7:49:08
