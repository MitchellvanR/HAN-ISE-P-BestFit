/**
* US-03 stored procedure to prolong a subscription by an amount of months (the end date, not paid until)
*
* Parameters
*	@member_id integer The id of the member whose subscription will be prolonged.
*	@type varchar(50) The type of the subscription that'll be prolonged.
*	@months_prolonged integer The amount of months the the subscription will be prolonged by.
*
* Return
*	- The end date of the subscription with the correct type and member id is updated.
*
* Rollbacks when
*	- There is no subscription that consists of the subscription type and member id that were given.
*	- The months prolonged is less than 1.
*/
CREATE OR ALTER PROCEDURE sproc_prolongSubscription
    @member_id integer,
    @type varchar(50),
    @months_prolonged integer
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        IF EXISTS (SELECT * FROM Subscription WHERE member_id = @member_id AND type = @type)
            BEGIN
                IF @months_prolonged >= 1
                    UPDATE Subscription SET end_date = DATEADD(MONTH, @months_prolonged, end_date) WHERE member_id = @member_id AND type = @type;
                ELSE
                    RAISERROR ('The amount of months prolonged is less then 1.', 16, 1);
            END
        ELSE
            RAISERROR('Your subscription is not found.', 16, 1);

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
        SET @errormessage = 'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() + '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END;
GO
