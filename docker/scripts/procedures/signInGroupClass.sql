/**
* UC-05
* SPROC-08: stored procedure to sign in for a group class.
*
* Parameters
*	@member_id varchar(36) The member's ID.
*   @class_name varchar(50) The name of the group class the member is signing up for.
*   @room_id int The room ID of the group class the member is signing up for.
*   @start_timestamp datetime The start time of the group class the member is signing up for.
*
* Return
*	- The registration will be saved in the table MemberGroupClass.
*
* Rollbacks when
*   - The member's subscription type doesn't allow the member to follow the groupClass
*   - The member's subscription is not active.
*   - The group class is full.
*   - The start time of the group class is in the past.
*/
DROP PROCEDURE IF EXISTS sproc_signInGroupClass
GO
CREATE PROCEDURE sproc_signInGroupClass
    @member_id varchar(36),
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

        IF @start_timestamp < GETDATE()
                RAISERROR('It is too late to sign up for this group class.', 16, 1);
                INSERT INTO MemberGroupClass (member_id, class_name, room_id, start_timestamp)
                VALUES (@member_id, @class_name, @room_id, @start_timestamp);

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

