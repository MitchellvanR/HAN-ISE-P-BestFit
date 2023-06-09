/**
* UC-10
* SPROC-09: Stored procedure to retrieve all employee schedules.
*
* Return Values:
*	- employee_id (VARCHAR(36)): The ID of the member whose subscription information was retrieved.
*   - class_name (VARCHAR(50)): The name of the activity that the employee will be participating in.
*   - room_id (int): The room in which the activity will take place.
*   - start_timestamp (datetime): The timestamp when the activity will start.
*   - end_timestamp (datetime): The timestamp when the activity will end.
*
* Exceptions:
*   - If an error occurs while executing the SELECT statement, the stored procedure will throw an error.
*/
DROP PROCEDURE IF EXISTS sproc_getEmployeeSchedules
GO
CREATE PROCEDURE sproc_getEmployeeSchedules
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SELECT f.employee_id, r.functionality AS class_name, f.room_id, f.start_timestamp, f.end_timestamp
        FROM FitnessRoomSchedule f
                 INNER JOIN Room r ON f.room_id = r.room_id
        WHERE f.start_timestamp > GETDATE()
          AND f.start_timestamp < DATEADD(MONTH, 1, GETDATE())
        UNION ALL
        SELECT employee_id, class_name, room_id, start_timestamp, end_timestamp
        FROM GroupClass
        WHERE start_timestamp > GETDATE()
          AND start_timestamp < DATEADD(MONTH, 1, GETDATE())
    END TRY
    BEGIN CATCH
        ; THROW
    END CATCH
END