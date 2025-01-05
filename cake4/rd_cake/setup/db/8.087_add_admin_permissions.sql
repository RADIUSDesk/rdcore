drop procedure if exists add_admin_permissions;

delimiter //
create procedure add_admin_permissions()
begin

if not exists (select * from information_schema.columns
    where column_name = 'permissions' and table_name = 'cloud_admins' and table_schema = 'rd') then
    alter table cloud_admins add column `permissions` enum('admin','view','granular') DEFAULT 'admin';
end if;

if not exists (select * from information_schema.columns
    where column_name = 'cloud_wide' and table_name = 'cloud_admins' and table_schema = 'rd') then
    alter table cloud_admins add column `cloud_wide` tinyint(1) NOT NULL DEFAULT '1';
end if;

if not exists (select * from information_schema.columns
    where table_name = 'realm_admins' and table_schema = 'rd') then
        CREATE TABLE `realm_admins` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `realm_id` int(11) DEFAULT NULL,
          `user_id` int(11) DEFAULT NULL,
          `created` datetime NOT NULL,
          `modified` datetime NOT NULL,
          `permissions` enum('admin','view','granular') DEFAULT 'admin',
          PRIMARY KEY (`id`)
        );
end if;


end//

delimiter ;
call add_admin_permissions;

