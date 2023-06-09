IF NOT EXISTS (SELECT 1
               FROM sys.server_principals
               WHERE name = 'LOG_BEST_FIT_ADMIN')
    BEGIN
        CREATE LOGIN LOG_BEST_FIT_ADMIN WITH PASSWORD = 'BestFitAdminExamplePassword0?';
        -- When deploying to production, change PASSWORD to a strong password and store it in a secure manner.
    END

USE BestFit;

IF EXISTS (SELECT *
           FROM sys.server_principals
           WHERE name = 'LOG_BEST_FIT_ADMIN')
    AND NOT EXISTS (SELECT *
                    FROM sys.database_principals
                    WHERE name = 'US_BEST_FIT_ADMIN')
    BEGIN
        CREATE USER US_BEST_FIT_ADMIN FROM LOGIN LOG_BEST_FIT_ADMIN;
        ALTER ROLE [db_owner] ADD MEMBER [US_BEST_FIT_ADMIN];
        ALTER USER [US_BEST_FIT_ADMIN] WITH DEFAULT_SCHEMA = [dbo];
    END

USE Test_BestFit;

IF EXISTS (SELECT *
           FROM sys.server_principals
           WHERE name = 'LOG_BEST_FIT_ADMIN')
    AND NOT EXISTS (SELECT *
                    FROM sys.database_principals
                    WHERE name = 'US_BEST_FIT_ADMIN')
    BEGIN
        CREATE USER US_BEST_FIT_ADMIN FROM LOGIN LOG_BEST_FIT_ADMIN;
        ALTER ROLE [db_owner] ADD MEMBER [US_BEST_FIT_ADMIN];
        ALTER USER [US_BEST_FIT_ADMIN] WITH DEFAULT_SCHEMA = [dbo];
    END