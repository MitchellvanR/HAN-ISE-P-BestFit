/**
* TRG-01
* Trigger to make sure only valid group classes get inserted.
*
* Rollbacks when
*   - The employee that has been selected as the instructor isn't qualified to be an instructor for the selected class.
*	- The employee that has been selected as the instructor isn't qualified to be an instructor in general.
*	- The employee that has been selected as the instructor isn't available at the selected time.
*	- The selected room isn't suitable for group classes.
*   - The selected room isn't available at the selected time.
*/
DROP TRIGGER IF EXISTS trg_GroupClass_insertUpdate
GO
CREATE TRIGGER trg_GroupClass_insertUpdate
    ON GroupClass
    AFTER INSERT, UPDATE
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN
    SET NOCOUNT ON
    BEGIN TRY
        IF (EXISTS(SELECT *
                   FROM inserted i
                   WHERE 'GroupClass' != (SELECT functionality FROM Room WHERE room_id = i.room_id)))
            THROW 50000, 'This room is not suitable for group classes.', 1

        IF (EXISTS(SELECT *
                   FROM inserted i
                   WHERE i.class_name NOT IN
                         (SELECT class_name FROM EmployeeGroupClassType WHERE employee_id = i.employee_id)))
            THROW 50000, 'This employee is not qualified to teach the selected class.', 1

        IF (EXISTS(SELECT *
                   FROM inserted i
                   WHERE EXISTS(SELECT *
                                FROM GroupClass gc
                                WHERE gc.employee_id = i.employee_id
                                  AND i.start_timestamp < gc.end_timestamp
                                  AND gc.start_timestamp < i.end_timestamp
                                EXCEPT
                                SELECT *
                                FROM inserted
                                WHERE class_name = i.class_name
                                  AND room_id = i.room_id
                                  AND start_timestamp = i.start_timestamp)
                      OR EXISTS(SELECT *
                                FROM FitnessRoomSchedule
                                WHERE employee_id = i.employee_id
                                  AND i.start_timestamp < end_timestamp
                                  AND start_timestamp < i.end_timestamp)))
            THROW 50000, 'This employee is not available at the selected time.', 1

        IF (EXISTS(SELECT *
                   FROM inserted i
                   WHERE room_id IN (SELECT room_id
                                     FROM Room r
                                     WHERE EXISTS(SELECT *
                                                  FROM GroupClass g
                                                  WHERE room_id = r.room_id
                                                    AND start_timestamp < i.end_timestamp
                                                    AND i.start_timestamp < end_timestamp
                                                  EXCEPT
                                                  SELECT *
                                                  FROM inserted
                                                  WHERE class_name = i.class_name
                                                    AND room_id = i.room_id
                                                    AND start_timestamp = i.start_timestamp))))
            THROW 50000, 'This room is not available at the selected time.', 1
    END TRY
    BEGIN CATCH
        ; THROW
    END CATCH
END
GO