USE [DatabaseName];
GO

-- Set ANSI_NULLS and QUOTED_IDENTIFIER
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- ======================================
--       File: TriggerName
--    Created: 07/21/2020
--    Updated: 03/27/2025
-- Programmer: Cuates
--  Update By: AI Assistant
--    Purpose: Trigger to log all actions
-- ======================================
ALTER TRIGGER [dbo].[TriggerName]
ON [dbo].[MainTableName]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Insert log entries for INSERT, UPDATE, and DELETE actions
        INSERT INTO [dbo].[LogTableName] 
            (mtnID, created_date, [status], modified_date, columnOneName, columnTwoName, userID, actionType)
        SELECT 
            COALESCE(i.mtnID, d.mtnID),
            COALESCE(i.created_date, d.created_date),
            COALESCE(i.[status], d.[status]),
            COALESCE(i.modified_date, d.modified_date),
            COALESCE(i.columnOneName, d.columnOneName),
            COALESCE(i.columnTwoName, d.columnTwoName),
            COALESCE(i.userID, d.userID),
            CASE 
                WHEN i.mtnID IS NOT NULL AND d.mtnID IS NULL THEN 'Inserted'
                WHEN i.mtnID IS NOT NULL AND d.mtnID IS NOT NULL THEN 'Updated'
                WHEN i.mtnID IS NULL AND d.mtnID IS NOT NULL THEN 'Deleted'
            END AS actionType
        FROM inserted i
        FULL OUTER JOIN deleted d ON i.mtnID = d.mtnID;
    END TRY
    BEGIN CATCH
        -- Handle errors (optional: log to an error table)
        PRINT 'Error in Trigger: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
