/*
* TRG-03
* Trigger to validate the subscription data
*
* Rollbacks when
*   - The member is too young to fit this subscription type.
*   - The member is too old to fit this subscription type.
*   - The member already has a subscription of this type.
*/
DROP TRIGGER IF EXISTS trg_Subscription_insertUpdate
GO
CREATE TRIGGER trg_Subscription_insertUpdate
    ON dbo.Subscription
    AFTER INSERT, UPDATE AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS (SELECT i.member_id,
                          i.type,
                          i.start_date,
                          i.end_date,
                          m.birthdate,
                          st.min_age,
                          st.max_age
                   FROM inserted i
                            INNER JOIN Member m ON i.member_id = m.member_id
                            INNER JOIN SubscriptionType st ON i.type = st.TYPE
                   WHERE DATEDIFF(YEAR, m.birthdate, i.start_date) < (SELECT IIF(st.min_age IS NULL, 0, st.min_age)))
            BEGIN
                ;THROW 50001, 'The member is too young to fit this subscription type.', 1
            END
        IF EXISTS (SELECT i.member_id,
                          i.type,
                          i.start_date,
                          i.end_date,
                          m.birthdate,
                          st.min_age,
                          st.max_age
                   FROM inserted i
                            INNER JOIN Member m ON i.member_id = m.member_id
                            INNER JOIN SubscriptionType st ON i.type = st.TYPE
                   WHERE DATEDIFF(YEAR, m.birthdate, i.start_date) > (SELECT IIF(st.max_age IS NULL, 200, st.max_age)))
            BEGIN
                ;THROW 50001, 'The member is too old to fit this subscription type.', 1
            END
        IF (
                (SELECT COUNT(*)
                 FROM inserted i
                          INNER JOIN Subscription s
                                     ON i.member_id = s.member_id AND i.type = s.TYPE) > 1
            )
            BEGIN
                ;THROW 50001, 'The member already has a subscription of this type.', 1
            END
    END TRY
    BEGIN CATCH
        ; THROW
    END CATCH
END
GO
