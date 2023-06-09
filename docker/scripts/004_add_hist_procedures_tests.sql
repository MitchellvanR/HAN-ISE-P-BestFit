EXEC tSQLt.NewTestClass 'TestHistoryTables';
GO

/*
* Test for stored procedure: sproc_generateHistoryTable
* Test to see if the history table is generated.
*
* Expects
*   - The history table for Employee to be generated and named 'dbo.hist_Employee'
*/
DROP PROCEDURE IF EXISTS [TestHistoryTables].[test generating history table];
GO
CREATE PROCEDURE [TestHistoryTables].[test generating history table]
AS
BEGIN
    -- Act
    EXEC dbo.sproc_generateHistoryTable 'Employee';

    -- Assert
    EXEC tSQLt.AssertObjectExists 'dbo.hist_Employee';
END;
GO

/*
* Test for stored procedure: sproc_generateHistoryTableTrigger
* Test to see if insert and delete triggers can be generated for history tables
*
* Expects
*   - Two triggers are made. One for insert and one for delete.
*/
DROP PROCEDURE IF EXISTS [TestHistoryTables].[test generating history table triggers];
GO
CREATE PROCEDURE [TestHistoryTables].[test generating history table triggers]
AS
BEGIN
    -- Act
    EXEC dbo.sproc_generateHistoryTableTrigger 'Employee';

    -- Assert
    DECLARE @insertTriggerExists BIT = (SELECT COUNT(*)
                                        FROM sys.triggers
                                        WHERE name = 'trg_Employee_insertHistory')
    DECLARE @deleteTriggerExists BIT = (SELECT COUNT(*)
                                        FROM sys.triggers
                                        WHERE name = 'trg_Employee_deleteHistory')

    EXEC tSQLt.AssertEquals 1, @insertTriggerExists;
    EXEC tSQLt.AssertEquals 1, @deleteTriggerExists;
END;
GO

/*
* Test for stored procedure: sproc_generateHistoryTables
* Test to see if the stored procedures are called correctly
*
* Expects
*   - The stored procedures are called.
*/
DROP PROCEDURE IF EXISTS [TestHistoryTables].[test if sprocs are called correctly]
GO
CREATE PROCEDURE [TestHistoryTables].[test if sprocs are called correctly]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.SpyProcedure 'dbo.sproc_generateHistoryTable';
    EXEC tSQLt.SpyProcedure 'dbo.sproc_generateHistoryTableTrigger';

    -- Act
    EXEC dbo.sproc_generateHistoryTables

    -- Assert
    IF NOT EXISTS (SELECT 1 FROM dbo.sproc_generateHistoryTable_SpyProcedureLog)
        EXEC tSQLt.Fail 'The stored procedure: ''sproc_generateHistoryTable'' was not called.';

    IF NOT EXISTS (SELECT 1 FROM dbo.sproc_generateHistoryTableTrigger_SpyProcedureLog)
        EXEC tSQLt.Fail 'The stored procedure: ''sproc_generateHistoryTableTrigger'' was not called.';
END;
GO
