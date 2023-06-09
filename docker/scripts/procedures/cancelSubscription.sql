/**
* UC-03
* SPROC-05: stored procedure to cancel a subscription from en existing member.
*
* Parameters
*	@member_id varchar(36) The member's ID.
*	@subscription_type varchar(50) The subscription type.
*
* Return
*	- The subscription_status will be put on 'Inactive' for the specified subscription and member.
*
* Rollbacks when
*	- The member doesn't exist.
*	- The subscription type doesn't exist.
*	- The member doesn't have a subscription with the given name.
*	- The subscription does already have the status 'Inactive'.
*   - The member tries to cancel the subscription when its min_length has not passed.
*   - The member tries to cancel the subscription when its end_date minus notice_period is less than the current date.
 */
DROP PROCEDURE IF EXISTS sproc_cancelSubscription
GO
CREATE PROCEDURE sproc_cancelSubscription @member_id varchar(36),
                                                   @subscription_type varchar(50)
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        IF EXISTS(SELECT *
                  FROM Subscription AS s
                           INNER JOIN SubscriptionType AS st ON s.type = st.type
                      AND s.member_id = @member_id
                      AND s.type = @subscription_type
                      AND GETDATE() <= DATEADD(WEEK, -st.notice_period, s.end_date)
            )
            BEGIN
                DECLARE @notice_period int = (SELECT notice_period
                                              FROM SubscriptionType
                                              WHERE type = @subscription_type);
                UPDATE Subscription
                SET end_date = DATEADD(WEEK, @notice_period, GETDATE())
                WHERE member_id = @member_id
                  AND type = @subscription_type;
            END
        ELSE
            THROW 50000, 'This member does not have an active subscription/this subscription is not between the start- and end date of the subscription.', 1;

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