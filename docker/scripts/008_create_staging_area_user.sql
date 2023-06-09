USE master;

IF NOT EXISTS (SELECT *
        FROM sys.server_principals
        WHERE name = 'LOG_BEST_FIT_STAGING')
    BEGIN
        CREATE LOGIN LOG_BEST_FIT_STAGING WITH PASSWORD = 'BestFitStagingExamplePassword0?';
        -- When deploying to production, change PASSWORD to a strong password and store it in a secure manner.
    END;

USE BestFit;

IF NOT EXISTS (SELECT *
        FROM sys.database_principals
        WHERE name = 'US_BEST_FIT_STAGING')
    BEGIN
        CREATE USER US_BEST_FIT_STAGING FROM LOGIN LOG_BEST_FIT_STAGING;
    END;

IF NOT EXISTS (SELECT *
        FROM sys.database_principals
        WHERE name = 'STAGING'
          AND type_desc = 'DATABASE_ROLE')
    BEGIN
        CREATE ROLE STAGING;
        ALTER ROLE [STAGING] ADD MEMBER [US_BEST_FIT_STAGING];

        GRANT EXECUTE ON OBJECT::dbo.sproc_getSubscriptionInformation TO STAGING;
        GRANT EXECUTE ON OBJECT::dbo.sproc_viewGroupClass TO STAGING;
        GRANT EXECUTE ON OBJECT::dbo.sproc_getEmployeeSchedules TO STAGING;
        GRANT EXECUTE ON OBJECT::dbo.sproc_viewMemberReservations TO STAGING;

        GRANT SELECT ON GroupClassType TO [STAGING];
        GRANT INSERT, SELECT ON GroupClass TO [STAGING];
        GRANT INSERT ON FitnessRoomSchedule TO [STAGING];
        GRANT INSERT ON Employee TO [STAGING];
        GRANT INSERT ON EmployeeRole TO [STAGING];
        GRANT INSERT ON EmployeeGroupClassType TO [STAGING];
        GRANT INSERT ON Subscription TO [STAGING];
        GRANT INSERT, SELECT ON GroupClassTypeSubscriptionType TO [STAGING];
        GRANT INSERT ON Member TO [STAGING];
        GRANT INSERT ON RoomReservation TO [STAGING];
        GRANT INSERT ON MachineReservation TO [STAGING];
        GRANT INSERT ON MemberGroupClass TO [STAGING];
        GRANT INSERT, SELECT ON Room TO [STAGING];
        GRANT INSERT, SELECT ON Machine TO [STAGING];
    END;