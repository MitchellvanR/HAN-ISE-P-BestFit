/**
* UC-12
* SPROC-06: stored procedure to schedule a new group class.
*
* Parameters
*   @class_name varchar(50) The name of the class that is being scheduled.
*   @room_id int The room in which the class would be scheduled.
*   @start_timestamp datetime The timestamp at which the class would start.
*   @employee_id int The id of the employee that will be selected as the instructor for the class.
*   @end_timestamp datetime The timestamp at which the class would end.
*
* Return
*	- The group class will be saved in the GroupClass table
*
* Rollbacks when
*   - Error occurs in an insert trigger on the GroupClass table
*/
DROP PROCEDURE IF EXISTS sproc_scheduleGroupClass
GO
CREATE PROCEDURE sproc_scheduleGroupClass(@class_name varchar(50), @room_id int, @start_timestamp datetime,
                                                   @employee_id varchar(36), @end_timestamp datetime)
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;
        INSERT INTO GroupClass (class_name, room_id, start_timestamp, employee_id, end_timestamp)
        VALUES (@class_name, @room_id, @start_timestamp, @employee_id, @end_timestamp)
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
                    'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                    '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END;
GO