/*
* UC-11
* SPROC-18: stored procedure to switch the status of a machine.
*
* Parameters
*	@machine_id int The machine's ID.
*
* Return
*	- The status of the machine is switched.
*
* Rollbacks when
*	- The machine does not exist.
*/
DROP PROCEDURE IF EXISTS sproc_switchMachineStatus;
GO
CREATE PROCEDURE sproc_switchMachineStatus
    @machine_id INT
AS
BEGIN
	DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
	DECLARE @startTrancount int= @@TRANCOUNT;
	SET NOCOUNT ON; 
	BEGIN TRY
		BEGIN TRANSACTION;
		SAVE TRANSACTION @savepoint;

        DECLARE @machine_status VARCHAR(15) = (SELECT machine_status FROM Machine WHERE machine_id = @machine_id);

        IF @machine_status IS NOT NULL
            BEGIN
                UPDATE Machine
                SET machine_status = IIF(machine_status = 'Active', 'Out of order', 'Active')
                WHERE machine_id = @machine_id;
            END
        ELSE
            THROW 50000, 'This machine does not exist.', 1;

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
		SET @errormessage = 'Error occurred in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() + '''';
		THROW 50000, @errormessage, 1;
	END CATCH;
END;
GO