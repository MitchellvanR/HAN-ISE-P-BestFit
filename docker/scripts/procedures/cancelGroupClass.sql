/**
* UC-14
* SPROC-10: stored procedure to cancel a group class as an employee.
*
* Parameters
*	@member_id varchar(36) The member's ID.
*	@class_name varchar(50) The name of the group class you want to cancel.
*   @room_id int() The room where the group class takes place.
*   @start_timestamp datetime() The time and date the group class takes place.
*
* Return
*	- The groupclass will be removed from the database.
*
* Rollbacks when
*	- The employee doesn't exist.
*	- The group class doesn't exist.
*	- The room doesn't exist.
*	- The class_name doesn't exist.
*   - The given group class is not scheduled for the given start_timestamp.
*   - The given employee is not the teacher of the scheduled group class.
 */
DROP PROCEDURE IF EXISTS sproc_cancelGroupClass
GO
CREATE PROCEDURE sproc_cancelGroupClass @employee_id varchar(36),
                                                 @class_name varchar(50),
                                                 @room_id int,
                                                 @start_timestamp datetime
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;
        IF EXISTS(SELECT *
                  FROM GroupClass
                  WHERE employee_id = @employee_id
                    AND class_name = @class_name)
            BEGIN
                IF EXISTS(SELECT *
                          FROM GroupClass
                          WHERE room_id = @room_id
                            AND start_timestamp = @start_timestamp)
                    BEGIN
                        DELETE
                        FROM GroupClass
                        WHERE employee_id = @employee_id
                          AND class_name = @class_name
                          AND room_id = @room_id
                          AND start_timestamp = @start_timestamp
                    END
                ELSE
                    BEGIN
                        THROW 50000, 'De room_id and/or the starttime of the group class does not match', 1;
                    END
            END
        ELSE
            BEGIN
                THROW 50001, 'De employee_id and/or the group class name does not match', 1;
            END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = -1 AND @startTrancount = 0
            BEGIN
                ROLLBACK TRANSACTION
            END
        ELSE
            BEGIN
                IF XACT_STATE() = 1
                    BEGIN
                        ROLLBACK TRANSACTION @savepoint;
                        COMMIT TRANSACTION;
                    END;
            END;
        DECLARE @errormessage varchar(2000);
        SET @errormessage =
                    'Error occurred in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                    '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END;
GO