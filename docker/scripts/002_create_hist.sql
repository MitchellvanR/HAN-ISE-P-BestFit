IF EXISTS (SELECT *
           FROM sys.objects
           WHERE object_id = OBJECT_ID(N'[dbo].[sproc_generateHistoryTable]')
             AND type IN (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sproc_generateHistoryTable]
GO

CREATE PROCEDURE sproc_generateHistoryTable(@table_name SYSNAME)
AS
BEGIN TRY
    DECLARE @sql NVARCHAR(MAX) =
            'SELECT *' +
            ' INTO hist_' + @table_name +
            ' FROM dbo.' + QUOTENAME(@table_name) +
            ' WHERE 1 = 0; ' +
            'ALTER TABLE hist_' + @table_name +
            ' ADD timestamp datetime NOT NULL DEFAULT SYSDATETIME(); ' +
            'ALTER TABLE hist_' + @table_name +
            ' ADD PRIMARY KEY (' +
            (SELECT STRING_AGG(COLUMN_NAME, ', ') AS PKs
             FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
             WHERE CONSTRAINT_NAME IN (SELECT DISTINCT TABLE_CONSTRAINTS.CONSTRAINT_NAME
                                       FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
                                       WHERE TABLE_NAME = @table_name
                                         AND CONSTRAINT_TYPE = 'PRIMARY KEY')) +
            ', timestamp);';

    EXEC sp_executesql @sql;
END TRY
BEGIN CATCH
    THROW;
END CATCH
GO

IF EXISTS (SELECT *
           FROM sys.objects
           WHERE object_id = OBJECT_ID(N'[dbo].[sproc_generateHistoryTableTrigger]')
             AND type IN (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sproc_generateHistoryTableTrigger]
GO

CREATE PROCEDURE sproc_generateHistoryTableTrigger(@table_name SYSNAME)
AS
BEGIN TRY
    DECLARE @sql NVARCHAR(MAX) =
            'CREATE OR ALTER TRIGGER trg_' + @table_name + '_history ' +
            ' ON ' + @table_name +
            ' AFTER UPDATE AS ' +
            ' BEGIN ' +
            ' IF @@ROWCOUNT = 0 RETURN; ' +
            ' SET NOCOUNT ON; ' +
            ' BEGIN TRY ' +
            ' INSERT INTO hist_' + @table_name + ' (' +
            (SELECT STRING_AGG(COLUMN_NAME, ', ') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @table_name) +
            ') ' +
            ' SELECT ' +
            (SELECT STRING_AGG(COLUMN_NAME, ', ') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @table_name) +
            ' FROM INSERTED; ' +
            ' END TRY ' +
            ' BEGIN CATCH ' +
            ' THROW; ' +
            ' END CATCH ' +
            ' END ';

    EXEC sp_executesql @sql;
END TRY
BEGIN CATCH
    THROW;
END CATCH
GO

IF EXISTS (SELECT *
           FROM sys.objects
           WHERE object_id = OBJECT_ID(N'[dbo].[sproc_generateHistoryTables]')
             AND type IN (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sproc_generateHistoryTables]
GO

CREATE PROCEDURE sproc_generateHistoryTables
AS
BEGIN TRY
    DECLARE @sql NVARCHAR(MAX) = '';
    SELECT @sql +=
           'EXEC sproc_generateHistoryTable ''' + TABLE_NAME + '''; ' +
           'EXEC sproc_generateHistoryTableTrigger ''' + TABLE_NAME + '''; '
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = 'BASE TABLE'
      AND TABLE_NAME NOT LIKE 'hist_%'

    EXEC sp_executesql @sql;
END TRY
BEGIN CATCH
    THROW;
END CATCH
GO

EXEC sproc_generateHistoryTables;