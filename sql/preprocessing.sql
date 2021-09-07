ALTER TABLE melissa_input
ADD COLUMN id text, 
ADD COLUMN boro text; 

UPDATE melissa_input SET id = address||city||zip;

ALTER TABLE melissa_corrections ADD COLUMN id text; 
UPDATE melissa_corrections SET id = address||city||zip;

ALTER TABLE melissa_outsideofnyc ADD COLUMN id text; 
UPDATE melissa_outsideofnyc SET id = address||city||zip;

DELETE FROM melissa_input
WHERE id IN (SELECT DISTINCT(id) FROM melissa_outsideofnyc);
