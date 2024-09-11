--------------------------------------------------------
--  File created - Wednesday-September-11-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GETTHIRDHIGHESTORDER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "CPAYTCOR"."GETTHIRDHIGHESTORDER" (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT o.order_ref,
        o.ORDER_ID AS Order_Reference, 
        TO_CHAR(o.Order_Date, 'Month DD, YYYY') AS Order_Date, -- Format as "January 01, 2017"
        UPPER(s.Supplier_Name) AS Supplier_Name, -- Uppercase
        TO_CHAR(o.Order_Total_Amount, '999,999,990.00') AS Order_Total_Amount, -- Format with commas
        o.Order_Status,
        LISTAGG(distinct Invoice_Reference, ', ') WITHIN GROUP (ORDER BY Invoice_Reference) AS Invoice_References

    FROM Supplier s
    JOIN ordertbl o on o.Supplier_ID = s.Supplier_ID
    JOIN Invoicetbl i ON o.Order_ID = i.Order_ID

    GROUP BY o.order_ref,o.ORDER_ID,  TO_CHAR(o.Order_Date, 'Month DD, YYYY'), UPPER(s.Supplier_Name), TO_CHAR(o.Order_Total_Amount, '999,999,990.00'), o.Order_Status
    order by Order_Total_Amount desc OFFSET 2 ROWS
FETCH NEXT 1 ROWS ONLY;


END GetThirdHighestOrder;

/
