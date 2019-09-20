-- Remove outside of NYC records
DELETE FROM melissa
WHERE f1_grc = '71' 
    OR f1a_grc = '71' 
    OR fap_grc = '71';
