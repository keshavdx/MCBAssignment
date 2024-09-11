--------------------------------------------------------
--  File created - Thursday-September-12-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GETSUPPLIERORDERSSUMMARY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "CPAYTCOR"."GETSUPPLIERORDERSSUMMARY" (
   p_start_date IN DATE,
    p_end_date IN DATE,
    p_cursor OUT SYS_REFCURSOR

) AS
BEGIN
    OPEN p_cursor FOR
      SELECT 
        Supplier_Name,
        Contact_Name AS Supplier_Contact_Name,
        CASE 
            WHEN LENGTH(Supplier_Contact_No_1) = 8 THEN SUBSTR(Supplier_Contact_No_1, 1, 4) || '-' || SUBSTR(Supplier_Contact_No_1, 5, 4)
            ELSE SUBSTR(Supplier_Contact_No_1, 1, 3) || '-' || SUBSTR(Supplier_Contact_No_1, 4, 4)
        END AS Supplier_Contact_No_1,
        CASE 
            WHEN LENGTH(Supplier_Contact_No_2) = 8 THEN SUBSTR(Supplier_Contact_No_2, 1, 4) || '-' || SUBSTR(Supplier_Contact_No_2, 5, 4)
            ELSE SUBSTR(Supplier_Contact_No_2, 1, 3) || '-' || SUBSTR(Supplier_Contact_No_2, 4, 4)
        END AS Supplier_Contact_No_2, 
        COUNT(o.Order_ID) AS Total_Orders,
        TO_CHAR(SUM(Order_Total_Amount), '999,999,990.00') AS Order_Total_Amount
    FROM Supplier s
    JOIN Ordertbl o ON s.Supplier_ID = o.Supplier_ID
    LEFT JOIN ( 
        SELECT  
            supplier_id,
            SUBSTR(contact_number, 1, (INSTR(contact_number, ',') - 1)) AS Supplier_Contact_No_2,
            TRIM(SUBSTR(contact_number, (INSTR(contact_number, ',') + 1))) AS Supplier_Contact_No_1
        FROM Supplier
    ) c ON s.Supplier_ID = c.supplier_id
   where order_date between p_start_date AND p_end_date
    GROUP BY Supplier_Name, Contact_Name,  CASE 
            WHEN LENGTH(Supplier_Contact_No_1) = 8 THEN SUBSTR(Supplier_Contact_No_1, 1, 4) || '-' || SUBSTR(Supplier_Contact_No_1, 5, 4)
            ELSE SUBSTR(Supplier_Contact_No_1, 1, 3) || '-' || SUBSTR(Supplier_Contact_No_1, 4, 4)
        END, CASE 
            WHEN LENGTH(Supplier_Contact_No_2) = 8 THEN SUBSTR(Supplier_Contact_No_2, 1, 4) || '-' || SUBSTR(Supplier_Contact_No_2, 5, 4)
            ELSE SUBSTR(Supplier_Contact_No_2, 1, 3) || '-' || SUBSTR(Supplier_Contact_No_2, 4, 4)
        END
    ORDER BY Supplier_Name;
END GetSupplierOrdersSummary;

/
