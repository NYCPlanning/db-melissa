ALTER TABLE melissa_input
ADD COLUMN id text, 
ADD COLUMN boro text; 

UPDATE melissa_input
SET id = address||city||zip;

DELETE FROM melissa_input
WHERE id IN (
	SELECT DISTINCT(id)
	FROM melissa_outsideofnyc);

UPDATE melissa_input
SET address = b.corrected_hn||' '||corrected_street, 
    boro = b.corrected_borough
FROM melissa_corrections b
WHERE melissa_input.id = b.id;