/**
* UC-04
* SPROC-04: Stored procedure to retrieve subscription information for a given member_id.
*
* Parameters:
*   - @member_id (VARCHAR(36)): The ID of the member whose subscription information is being retrieved. 
*	
* Return Values:
*	- member_id (VARCHAR(36)): The ID of the member whose subscription information was retrieved.
*   - type (string): The type of subscription the member has. 
*   - start_date (date): The date when the subscription started. 
*   - end_date (date): The date when the subscription will end.
*
* Exceptions:
*   - If an error occurs while executing the SELECT statement, the stored procedure will throw an error.
*
*/
DROP PROCEDURE IF EXISTS sproc_getSubscriptionInformation
GO
CREATE PROCEDURE sproc_getSubscriptionInformation
    @member_id VARCHAR(36)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SELECT *
        FROM Subscription
        WHERE @member_id = member_id
    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END
GO