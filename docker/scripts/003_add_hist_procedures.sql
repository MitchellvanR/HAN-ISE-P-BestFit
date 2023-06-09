/**
* A stored procedure to generate history tables for a specified table.
*
* Parameters:
*   - @table_name SYSNAME The name of the table to generate a history table for.
*
*/
DROP PROCEDURE IF EXISTS sproc_generateHistoryTable
GO
CREATE PROCEDURE sproc_generateHistoryTable(@table_name SYSNAME)
AS
BEGIN TRY
    DECLARE @sql NVARCHAR(MAX) =
            'SELECT *' +
            ' INTO dbo.hist_' + @table_name +
            ' FROM dbo.' + QUOTENAME(@table_name) +
            ' WHERE 1 = 0; ' +
            'ALTER TABLE hist_' + @table_name +
            ' ADD timestamp datetime NOT NULL DEFAULT SYSDATETIME(); ' +
            'ALTER TABLE hist_' + @table_name +
            ' ADD action CHAR(1) NOT NULL; ' +
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

/**
* A stored procedure to generate a trigger for a specified table to insert
* updated rows into the history table.
*
* Parameters:
*   - @table_name SYSNAME The name of the table to generate a history table for.
*
*/
DROP PROCEDURE IF EXISTS sproc_generateHistoryTableTrigger
GO
CREATE PROCEDURE sproc_generateHistoryTableTrigger(@table_name SYSNAME)
AS
BEGIN TRY
    DECLARE @insertTriggerSQL NVARCHAR(MAX) = '';
    DECLARE @deleteTriggerSQL NVARCHAR(MAX) = '';

    SET @insertTriggerSQL =
        ' CREATE TRIGGER trg_' + @table_name + '_insertHistory ' +
        ' ON ' + @table_name +
        ' AFTER INSERT, UPDATE AS ' +
        ' BEGIN ' +
        ' IF @@ROWCOUNT = 0 RETURN; ' +
        ' SET NOCOUNT ON; ' +
        ' BEGIN TRY ' +
        ' INSERT INTO hist_' + @table_name + ' (' +
        (SELECT STRING_AGG(COLUMN_NAME, ', ') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @table_name) +
        ', action) ' +
        ' SELECT ' +
        (SELECT STRING_AGG('INSERTED.' + COLUMN_NAME, ', ')
         FROM INFORMATION_SCHEMA.COLUMNS
         WHERE TABLE_NAME = @table_name) +
        ', ''I'' FROM INSERTED; ' +
        ' END TRY ' +
        ' BEGIN CATCH ' +
        ' THROW; ' +
        ' END CATCH ' +
        ' END ';

    SET @deleteTriggerSQL =
        ' CREATE TRIGGER trg_' + @table_name + '_deleteHistory ' +
        ' ON ' + @table_name +
        ' AFTER UPDATE, DELETE AS ' +
        ' BEGIN ' +
        ' IF @@ROWCOUNT = 0 RETURN; ' +
        ' SET NOCOUNT ON; ' +
        ' BEGIN TRY ' +
        ' INSERT INTO hist_' + @table_name + ' (' +
        (SELECT STRING_AGG(COLUMN_NAME, ', ') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @table_name) +
        ', action) ' +
        ' SELECT ' +
        (SELECT STRING_AGG('DELETED.' + COLUMN_NAME, ', ')
         FROM INFORMATION_SCHEMA.COLUMNS
         WHERE TABLE_NAME = @table_name) +
        ', ''D'' FROM DELETED; ' +
        ' END TRY ' +
        ' BEGIN CATCH ' +
        ' THROW; ' +
        ' END CATCH ' +
        ' END ';

    EXEC sp_executesql @insertTriggerSQL;
    EXEC sp_executesql @deleteTriggerSQL
END TRY
BEGIN CATCH
    THROW;
END CATCH

/**
* A stored procedure to generate history tables and triggers for all tables in
* the database. This procedure will generate history tables and triggers for all tables in
* the database that do not already have them. It will not overwrite existing
* history tables or triggers.
*
*/
DROP PROCEDURE IF EXISTS sproc_generateHistoryTables
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