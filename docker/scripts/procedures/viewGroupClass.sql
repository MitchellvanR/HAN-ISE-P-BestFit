/**
* UC-10
* SPROC-07: stored procedure to view the sign ins of a member.
*
* Parameters
*	@member_id varchar(36) The member's ID.
*
* Return
*	- For every group class the member is signed in for (for the coming month):
*		- @class_name varchar(50) The name of the class.
*		- @room_id int The room ID.
*		- @start_timestamp datetime The start date and time of the class.
*		- @end_timestamp datetime The end date and time of the class.
*
* Rollbacks when
*    - This procedure doesn't have unique errors. It will throw an error if the member doesn't exist, due to the foreign key constraint.
*/
DROP PROCEDURE IF EXISTS sproc_viewGroupClass;
GO
CREATE PROCEDURE sproc_viewGroupClass
    @member_id varchar(36)
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        IF NOT EXISTS (SELECT * FROM Member WHERE member_id = @member_id)
            RAISERROR('This member does not exist.', 16, 1);

        SELECT GC.class_name, GC.room_id, GC.start_timestamp, end_timestamp, employee_id  FROM GroupClass GC JOIN MemberGroupClass MGC ON GC.class_name = MGC.class_name AND GC.room_id = MGC.room_id AND GC.start_timestamp = MGC.start_timestamp
        WHERE MGC.member_id = @member_id AND GC.start_timestamp > GETDATE() AND GC.start_timestamp < DATEADD(month, 1, GETDATE());

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
