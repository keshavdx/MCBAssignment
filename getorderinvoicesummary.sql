--------------------------------------------------------
--  File created - Wednesday-September-11-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GETORDERINVOICESUMMARY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "CPAYTCOR"."GETORDERINVOICESUMMARY" (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
SELECT 
        o.ORDER_ID AS Order_Reference, o.order_date,
        TO_CHAR(o.Order_Date, 'MON-YY') AS Order_Period, 
        s.Supplier_Name AS Supplier_Name, -- First letter uppercase
        TO_CHAR(o.Order_Total_Amount, '999,999,990.00') AS Order_Total_Amount, -- Format with commas
        o.Order_Status,
        i.Invoice_Reference,
       (TO_CHAR(sum(Invoice_Amount), '999,999,990.00')) AS Invoice_Total_Amount,
        CASE 
            WHEN SUM(CASE WHEN Invoice_Status = 'Pending' THEN 1 ELSE 0 END) > 0 THEN 'To follow up'
            WHEN SUM(CASE WHEN Invoice_Status IS NULL THEN 1 ELSE 0 END) > 0 THEN 'To verify'
            ELSE 'OK'
        END AS Action
    FROM Supplier s
    JOIN ordertbl o on o.Supplier_ID = s.Supplier_ID
    JOIN Invoicetbl i ON o.Order_ID = i.Order_ID


    GROUP BY o.Order_ID, o.order_date, TO_CHAR(o.Order_Date, 'MON-YY'), s.Supplier_Name, TO_CHAR(o.Order_Total_Amount, '999,999,990.00'), o.Order_Status, i.Invoice_Reference
    ORDER BY  o.order_date DESC;
END GetOrderInvoiceSummary;

/
