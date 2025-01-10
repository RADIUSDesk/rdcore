drop procedure if exists split_accounting;


delimiter //
create procedure split_accounting()
begin


if not exists (select * from information_schema.columns
    where table_name = 'radacct_history' and table_schema = 'rd') then

    CREATE TABLE `radacct_history` (
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
          `framedipv6address` varchar(44) NOT NULL DEFAULT '',
          `framedipv6prefix` varchar(44) NOT NULL DEFAULT '',
          `framedinterfaceid` varchar(44) NOT NULL DEFAULT '',
          `delegatedipv6prefix` varchar(44) NOT NULL DEFAULT '',
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
          KEY `nasidentifier` (`nasidentifier`),
          KEY `framedipv6address` (`framedipv6address`),
          KEY `framedipv6prefix` (`framedipv6prefix`),
          KEY `framedinterfaceid` (`framedinterfaceid`),
          KEY `delegatedipv6prefix` (`delegatedipv6prefix`)
    );
 

end if;

end//

delimiter ;
call split_accounting;


DELIMITER //

--We added to the trigger in 8.090_add_radacct_triggers.sql the action where if acctstoptime changes from NULL to a date it will be written into the radacct_history table

SET GLOBAL event_scheduler = ON;

CREATE EVENT IF NOT EXISTS cleanup_radacct
ON SCHEDULE EVERY 1 HOUR
STARTS '2025-01-09 00:00:00'
DO
BEGIN
    DELETE FROM radacct
    WHERE acctstoptime IS NOT NULL
    AND radacctid IN (SELECT radacctid FROM radacct_history);
END//
