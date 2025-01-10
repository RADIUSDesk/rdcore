drop procedure if exists add_radacct_triggers;

delimiter //
create procedure add_radacct_triggers()
begin

    if not exists (select * from information_schema.columns
        where column_name = 'created' and table_name = 'user_stats' and table_schema = 'rd') then
        ALTER TABLE user_stats ADD COLUMN created TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    end if;

    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = 'rd' AND table_name = 'user_stats' AND index_name = 'idx_radacct_id') THEN
        CREATE INDEX idx_radacct_id ON user_stats (radacct_id);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = 'rd' AND table_name = 'user_stats' AND index_name = 'idx_radacct_timestamp') THEN
        CREATE INDEX idx_radacct_timestamp ON user_stats (radacct_id, timestamp);
    END IF;


end//

delimiter ;

call add_radacct_triggers;

DROP TRIGGER IF EXISTS manage_user_stats_after_insert;

-- Check if the 'manage_user_stats_after_insert' trigger exists, and create it if it doesn't
DELIMITER //

CREATE TRIGGER manage_user_stats_after_insert
AFTER INSERT ON radacct
FOR EACH ROW
BEGIN
    DECLARE latest_user_stats_id INT;
    DECLARE creation_time_difference INT;
    DECLARE new_acctinputoctets BIGINT DEFAULT 0;
    DECLARE new_acctoutputoctets BIGINT DEFAULT 0;
    -- 30 minute slots
    DECLARE stats_interval INT DEFAULT 30;

    -- Calculate new data
    SET new_acctinputoctets  = NEW.acctinputoctets;
    SET new_acctoutputoctets = NEW.acctoutputoctets;

    -- Find the latest entry in user_stats for the given radacct_id
    SELECT id, TIMESTAMPDIFF(MINUTE, created, NOW())
    INTO latest_user_stats_id, creation_time_difference
    FROM user_stats
    WHERE radacct_id = NEW.radacctid
    ORDER BY timestamp DESC
    LIMIT 1;
    
    -- There is no latest_user_stats add it
    IF latest_user_stats_id IS NULL THEN
        INSERT INTO user_stats (
            radacct_id,
            username,
            realm,
            nasipaddress,
            nasidentifier,
            framedipaddress,
            callingstationid,
            timestamp,
            created,
            acctinputoctets,
            acctoutputoctets
        )
        VALUES (
            NEW.radacctid,
            NEW.username,
            NEW.realm,
            NEW.nasipaddress,
            NEW.nasidentifier,
            NEW.framedipaddress,
            NEW.callingstationid,
            NOW(),
            NOW(),
            new_acctinputoctets,
            new_acctoutputoctets
        );   
    END IF;

    IF latest_user_stats_id IS NOT NULL AND creation_time_difference <= stats_interval THEN   
        -- Update the existing entry if it's within stats_interval minutes of creation
        UPDATE user_stats
        SET acctinputoctets = acctinputoctets + (new_acctinputoctets - (SELECT SUM(acctinputoctets) FROM user_stats WHERE radacct_id = NEW.radacctid)),
            acctoutputoctets = acctoutputoctets + (new_acctoutputoctets - (SELECT SUM(acctoutputoctets) FROM user_stats WHERE radacct_id = NEW.radacctid)),
            timestamp = NOW()
        WHERE id = latest_user_stats_id;        
    END IF;
    
    IF latest_user_stats_id IS NOT NULL AND creation_time_difference > stats_interval THEN 
    
        SET new_acctinputoctets  = new_acctinputoctets - (SELECT SUM(acctinputoctets) FROM user_stats WHERE radacct_id = NEW.radacctid);
        SET new_acctoutputoctets = new_acctoutputoctets - (SELECT SUM(acctoutputoctets) FROM user_stats WHERE radacct_id = NEW.radacctid);
      
        INSERT INTO user_stats (
            radacct_id,
            username,
            realm,
            nasipaddress,
            nasidentifier,
            framedipaddress,
            callingstationid,
            timestamp,
            created,
            acctinputoctets,
            acctoutputoctets
        )
        VALUES (
            NEW.radacctid,
            NEW.username,
            NEW.realm,
            NEW.nasipaddress,
            NEW.nasidentifier,
            NEW.framedipaddress,
            NEW.callingstationid,
            NOW(),
            NOW(),
            new_acctinputoctets,
            new_acctoutputoctets
        );    
    END IF;
       
END //

DELIMITER ;


DROP TRIGGER IF EXISTS manage_user_stats_after_update;

-- Check if the 'manage_user_stats_after_update' trigger exists, and create it if it doesn't
DELIMITER //

CREATE TRIGGER manage_user_stats_after_update
AFTER UPDATE ON radacct
FOR EACH ROW
BEGIN
    DECLARE latest_user_stats_id INT;
    DECLARE creation_time_difference INT;
    DECLARE updated_acctinputoctets BIGINT DEFAULT 0;
    DECLARE updated_acctoutputoctets BIGINT DEFAULT 0;
    -- 30 minute slots
    DECLARE stats_interval INT DEFAULT 30;

    -- Calculate updated data
    SET updated_acctinputoctets = NEW.acctinputoctets;
    SET updated_acctoutputoctets = NEW.acctoutputoctets;

    -- Find the latest entry in user_stats for the given radacct_id
    SELECT id, TIMESTAMPDIFF(MINUTE, created, NOW())
    INTO latest_user_stats_id, creation_time_difference
    FROM user_stats
    WHERE radacct_id = NEW.radacctid
    ORDER BY timestamp DESC
    LIMIT 1;
    
    IF latest_user_stats_id IS NULL THEN
        INSERT INTO user_stats (
            radacct_id,
            username,
            realm,
            nasipaddress,
            nasidentifier,
            framedipaddress,
            callingstationid,
            timestamp,
            created,
            acctinputoctets,
            acctoutputoctets
        )
        VALUES (
            NEW.radacctid,
            NEW.username,
            NEW.realm,
            NEW.nasipaddress,
            NEW.nasidentifier,
            NEW.framedipaddress,
            NEW.callingstationid,
            NOW(),
            NOW(),
            updated_acctinputoctets,
            updated_acctoutputoctets
        );
    
    END IF;

    IF latest_user_stats_id IS NOT NULL AND creation_time_difference <= stats_interval THEN 

        -- Update the existing entry if it's within 10 minutes of creation
        UPDATE user_stats
        SET acctinputoctets = acctinputoctets + (updated_acctinputoctets - (SELECT SUM(acctinputoctets) FROM user_stats WHERE radacct_id = NEW.radacctid)),
            acctoutputoctets = acctoutputoctets + (updated_acctoutputoctets - (SELECT SUM(acctoutputoctets) FROM user_stats WHERE radacct_id = NEW.radacctid)),
            timestamp = NOW()
        WHERE id = latest_user_stats_id;
        
    END IF;
    
    IF latest_user_stats_id IS NOT NULL AND creation_time_difference > stats_interval THEN
    
        SET updated_acctinputoctets  = updated_acctinputoctets - (SELECT SUM(acctinputoctets) FROM user_stats WHERE radacct_id = NEW.radacctid);
        SET updated_acctoutputoctets = updated_acctoutputoctets - (SELECT SUM(acctoutputoctets) FROM user_stats WHERE radacct_id = NEW.radacctid); 

        -- Create a new entry if the last one is older than 10 minutes from creation
        INSERT INTO user_stats (
            radacct_id,
            username,
            realm,
            nasipaddress,
            nasidentifier,
            framedipaddress,
            callingstationid,
            timestamp,
            created,
            acctinputoctets,
            acctoutputoctets
        )
        VALUES (
            NEW.radacctid,
            NEW.username,
            NEW.realm,
            NEW.nasipaddress,
            NEW.nasidentifier,
            NEW.framedipaddress,
            NEW.callingstationid,
            NOW(),
            NOW(),
            updated_acctinputoctets,
            updated_acctoutputoctets
        );
    END IF;

     -- Check if acctstoptime has changed from NULL to NOT NULL
    IF OLD.acctstoptime IS NULL AND NEW.acctstoptime IS NOT NULL THEN
        -- Insert the updated row into radacct_history
        INSERT INTO radacct_history 
        SELECT * FROM radacct WHERE radacctid = NEW.radacctid;
    END IF;

END //



