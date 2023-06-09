EXEC tSQLt.newTestClass 'testSwitchMachineStatus';
GO

DROP PROCEDURE IF EXISTS testSwitchMachineStatus.[SetUp]
GO
CREATE PROCEDURE testSwitchMachineStatus.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Machine'
END
GO

/**
* T-01
* Test if a machine status can be switched from active to out of order.
*
* Expects
*   - The machine's status is switched from active to out of order.
*/
DROP PROCEDURE IF EXISTS testSwitchMachineStatus.[Test if a machine status can be switched from active to out of order]
GO
CREATE PROCEDURE testSwitchMachineStatus.[Test if a machine status can be switched from active to out of order]
AS
BEGIN
    -- Assemble
    INSERT INTO Machine (machine_id, machine_status) VALUES (1, 'Active');

    -- Expect
    DECLARE @expected VARCHAR(15) = 'Out of order';
    EXEC [tSQLt].[ExpectNoException]

    -- Act
    EXEC sproc_switchMachineStatus 1

    -- Assert
    DECLARE @actual VARCHAR(15) = (SELECT machine_status FROM Machine WHERE machine_id = 1);
    EXEC [tSQLt].[AssertEquals] @expected, @actual
END

/**
* T-02
* Test if a machine status can be switched from out of order to active.
* 
* Expects
*   - The machine's status is switched from out of order to active.
*/
DROP PROCEDURE IF EXISTS testSwitchMachineStatus.[test if a machine status can be switched from out of order to active]
GO
CREATE PROCEDURE testSwitchMachineStatus.[test if a machine status can be switched from out of order to active]
AS
BEGIN
    -- Assemble
    INSERT INTO Machine (machine_id, machine_status) VALUES (1, 'Out of order');

    -- Expect
    DECLARE @expected VARCHAR(15) = 'Active';
    EXEC [tSQLt].[ExpectNoException]

    -- Act
    EXEC sproc_switchMachineStatus 1

    -- Assert
    DECLARE @actual VARCHAR(15) = (SELECT machine_status FROM Machine WHERE machine_id = 1);
    EXEC [tSQLt].[AssertEquals] @expected, @actual
END

/**
* T-03
* Test if a non-existing machine cannot be switched.
*
* Expects
*   - Exception: 'Error occurred in sproc ''sproc_switchMachineStatus''. Original message: ''This machine does not exist.'''
*/
DROP PROCEDURE IF EXISTS testSwitchMachineStatus.[test if a non-existing machine cannot be switched.]
GO
CREATE PROCEDURE testSwitchMachineStatus.[test if a non-existing machine cannot be switched.]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_switchMachineStatus''. Original message: ''This machine does not exist.'''

    -- Act
    EXEC sproc_switchMachineStatus 1
END