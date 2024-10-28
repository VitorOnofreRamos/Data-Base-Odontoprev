SELECT 
    constraint_name, 
    constraint_type, 
    status, 
    search_condition 
FROM 
    user_constraints 
WHERE 
    table_name = 'DENTISTA';
    
SELECT 
    uc.constraint_name, 
    ucc.column_name 
FROM 
    user_cons_columns ucc
JOIN 
    user_constraints uc 
ON 
    ucc.constraint_name = uc.constraint_name 
WHERE 
    uc.table_name = 'DENTISTA';
