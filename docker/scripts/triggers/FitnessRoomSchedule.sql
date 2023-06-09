/**
* TRG-04
* Trigger to verify that the employee that gets assigned is available at that time.
*
* Rollbacks when
*	- The employee is not available at that time
*/
DROP TRIGGER IF EXISTS trg_FitnessRoomSchedule_insertUpdate;
GO
CREATE TRIGGER trg_FitnessRoomSchedule_insertUpdate
    ON FitnessRoomSchedule
    AFTER INSERT, UPDATE
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS (SELECT *
                   FROM Inserted I
                            INNER JOIN Room R ON I.room_id = R.room_id
                   WHERE functionality != 'Fitness')
            THROW 50001, 'The room is not a fitness room.', 1

        IF EXISTS (SELECT *
                   FROM Inserted I
                   WHERE NOT EXISTS (SELECT *
                                     FROM EmployeeRole ER
                                     WHERE ER.employee_id = I.employee_id
                                       AND role_name = 'Employee'))
            THROW 50001, 'The employee does not have the role Employee.', 1

        IF EXISTS (SELECT FRS.employee_id, FRS.start_timestamp, FRS.end_timestamp
                   FROM Inserted I
                            JOIN FitnessRoomSchedule FRS ON I.employee_id = FRS.employee_id
                   WHERE I.start_timestamp < FRS.end_timestamp
                     AND FRS.start_timestamp < I.end_timestamp
                   EXCEPT
                   SELECT employee_id, start_timestamp, end_timestamp
                   FROM Inserted)
            THROW 50001, 'The employee has already been assigned at this time to a fitness room.', 1

        IF EXISTS (SELECT *
                   FROM Inserted I
                   WHERE EXISTS
                             (SELECT *
                              FROM FitnessRoomSchedule FRS
                              WHERE FRS.employee_id != I.employee_id
                                AND (I.start_timestamp
                                         BETWEEN FRS.start_timestamp AND FRS.end_timestamp OR
                                     I.end_timestamp BETWEEN FRS.start_timestamp AND FRS.end_timestamp)))
            THROW 50001, 'Another employee is already assigned to work in the fitness room at that time.', 1

        IF EXISTS (SELECT *
                   FROM Inserted I
                   WHERE EXISTS
                             (SELECT *
                              FROM GroupClass GC
                              WHERE GC.employee_id = I.employee_id
                                AND (I.start_timestamp
                                         BETWEEN GC.start_timestamp AND GC.end_timestamp OR
                                     I.end_timestamp BETWEEN GC.start_timestamp AND GC.end_timestamp)))
            THROW 50001, 'The employee is already assigned to a group class at this time.', 1
    END TRY
    BEGIN CATCH
        ; THROW
    END CATCH
END
GO