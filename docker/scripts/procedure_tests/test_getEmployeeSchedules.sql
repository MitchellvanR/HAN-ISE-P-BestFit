EXEC tSQLt.NewTestClass 'testGetEmployeeSchedules';
GO

/**
* T-01
* Employee schedules are retrieved
*
* Expects
*   - The retrieved activities will be equal to the actual activities.
*/
DROP PROCEDURE IF EXISTS testGetEmployeeSchedules.[test if stored procedure correctly returns schedule for all employees for the next month]
GO
CREATE PROCEDURE testGetEmployeeSchedules.[test if stored procedure correctly returns schedule for all employees for the next month]
AS
BEGIN
    -- Assemble
    IF OBJECT_ID('[testGetEmployeeSchedules].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testGetEmployeeSchedules].[expected]
    IF OBJECT_ID('[testGetEmployeeSchedules].[actual]', 'Table') IS NOT NULL
        DROP TABLE [testGetEmployeeSchedules].[actual]

    SELECT TOP 0 employee_id, class_name, room_id, start_timestamp, end_timestamp
    INTO [testGetEmployeeSchedules].[expected]
    FROM dbo.GroupClass;

    SELECT TOP 0 employee_id, class_name, room_id, start_timestamp, end_timestamp
    INTO [testGetEmployeeSchedules].[actual]
    FROM dbo.GroupClass

    DECLARE @fitnessRoomScheduleStartTimestamp Datetime
    DECLARE @fitnessRoomScheduleEndTimestamp Datetime
    DECLARE @GroupClassStartTimestamp Datetime
    DECLARE @GroupClassEndTimestamp Datetime
    SET @fitnessRoomScheduleStartTimestamp = DATEADD(HOUR, 1, GETDATE())
    SET @fitnessRoomScheduleEndTimestamp = DATEADD(HOUR, 2, GETDATE())
    SET @GroupClassStartTimestamp = DATEADD(HOUR, 3, GETDATE())
    SET @GroupClassEndTimestamp = DATEADD(HOUR, 4, GETDATE())


    EXEC tSQLt.FakeTable 'dbo', 'Room'
    INSERT INTO Room (room_id, functionality, max_people)
    VALUES (1, 'Fitness', 8),
           (2, 'GroupClass', 4)
    EXEC tSQLt.FakeTable 'dbo', 'FitnessRoomSchedule'
    INSERT INTO FitnessRoomSchedule (employee_id, room_id, start_timestamp, end_timestamp)
    VALUES (1, 1, @fitnessRoomScheduleStartTimestamp, @fitnessRoomScheduleEndTimestamp)
    EXEC tSQLt.FakeTable 'dbo', 'GroupClass'
    INSERT INTO GroupClass (class_name, room_id, start_timestamp, employee_id, end_timestamp)
    VALUES ('Dance', 2, @GroupClassStartTimestamp, 1, @GroupClassEndTimestamp)

    -- Act
    INSERT INTO [testGetEmployeeSchedules].[expected]
    VALUES (1, 'Fitness', 1, @fitnessRoomScheduleStartTimestamp, @fitnessRoomScheduleEndTimestamp),
           (1, 'Dance', 2, @GroupClassStartTimestamp, @GroupClassEndTimestamp);

    INSERT INTO [testGetEmployeeSchedules].[actual] (employee_id, class_name, room_id, start_timestamp, end_timestamp)
        EXEC sproc_getEmployeeSchedules

    -- Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testGetEmployeeSchedules.expected', 'testGetEmployeeSchedules.actual'
END