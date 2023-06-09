EXEC [tSQLt].[NewTestClass] 'testEditMachineReservation'
GO

DROP PROCEDURE IF EXISTS testEditMachineReservation.[SetUp]
GO
CREATE PROCEDURE testEditMachineReservation.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable 'dbo', 'MachineReservation'
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', '2023-05-09 17:44:30', '2023-05-09 18:44:30')
END
GO

/**
* T-01
* Edit a machine reservation in a way that should be allowed.
*
* Expects
*   - The machine reservation is successfully edited and no exceptions are thrown.
*/
DROP PROCEDURE IF EXISTS testEditMachineReservation.[test if a machine reservation can't be edited]
GO
CREATE PROCEDURE testEditMachineReservation.[test if a machine reservation can't be edited]
AS
BEGIN
    -- Assemble
    IF OBJECT_ID('[testEditMachineReservation].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testEditMachineReservation].[expected]

    SELECT TOP 0 *
    INTO [testEditMachineReservation].[expected]
    FROM dbo.MachineReservation;

    INSERT INTO expected (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (2, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', '2023-05-09 17:44:30', '2023-05-09 19:44:30')

    -- Act
    EXEC sproc_editMachineReservation 1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', '2023-05-09 17:44:30', 2,
         @end_timestamp = '2023-05-09 19:44:30'

    -- Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testEditMachineReservation.expected', 'dbo.MachineReservation', '',
         'Tables do not match!';
END
GO

/**
* T-02
* Attempt to edit the machine_id of a machine reservation to machine_id that doesn't exist.
*
* Expects
*   - The machine reservation will not be edited and a foreign key error is thrown.
*/
DROP PROCEDURE IF EXISTS testEditMachineReservation.[test if the machine_id for a machine reservation can't be edited to be a machine_id that doesn't exist]
GO
CREATE PROCEDURE testEditMachineReservation.[test if the machine_id for a machine reservation can't be edited to be a machine_id that doesn't exist]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.FakeTable 'dbo', 'Machine'
    INSERT INTO Machine (machine_id, room_id, type_name, machine_status)
    VALUES (1, 1, 'Leg press', 'Active')
    EXEC tSQLt.ApplyConstraint 'dbo.MachineReservation', 'fk_machiner_machine_i_machine';
    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessagePattern = '%The UPDATE statement conflicted with the FOREIGN KEY constraint%'
    -- Act
    EXEC sproc_editMachineReservation 1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', '2023-05-09 17:44:30', 2,
         @end_timestamp = '2023-05-09 19:44:30'
END
GO

/**
* T-03
* Attempt to edit a machine reservation that doesn't exist.
*
* Expects
*   - The machine reservation is not edited and an exception with the following error message will be thrown: 'This machine reservation does not exist.'
*/
DROP PROCEDURE IF EXISTS testEditMachineReservation.[test if a machine reservation that doesn't exist can't be edited]
GO
CREATE PROCEDURE testEditMachineReservation.[test if a machine reservation that doesn't exist can't be edited]
AS
BEGIN
    -- Assemble
    DELETE FROM MachineReservation

    -- Expect
    EXEC tSQLt.ExpectException
         @ExpectedMessage = 'Error occurred in sproc ''sproc_editMachineReservation''. Original message: ''This machine reservation does not exist.'''

    -- Act
    EXEC sproc_editMachineReservation 1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', '2023-05-09 17:44:30', 2,
         @end_timestamp = '2023-05-09 19:44:30'
END
GO