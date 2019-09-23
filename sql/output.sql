DROP TABLE IF EXISTS melissa_output;
CREATE TABLE melissa_output  AS (
    SELECT * FROM melissa_input a
    LEFT JOIN (
        SELECT id, 
            hnum, 
            sname, 
            corrected_borough,
            corrected_house_number,
            corrected_street_name,
            borough_code,
            f1_normalized_hn,
            f1_normalized_sn,
            centerline_xcoordinate,
            centerline_ycoordinate,
            centerline_latitude,
            centerline_longitude,
            physicalid,
            blockfaceid,
            cd,
            nta,
            nta_name,
            f1_grc,
            f1_reasoncode,
            f1_message,
            f1a_normalized_hn,
            f1a_normalized_sn,
            bin,
            is_tpad_bin,
            bbl,
            f1a_grc,
            f1a_reasoncode,
            f1a_message,
            fap_normalized_hn,
            fap_normalized_sn,
            addresspointid,
            addresspointid_xcoordinate,
            addresspointid_ycoordinate,
            addresspointid_latitude,
            addresspointid_longitude,
            fap_grc,
            fap_reasoncode,
            fap_message
        FROM melissa) b
        USING (id)
); 

ALTER TABLE melissa_output 
DROP COLUMN IF EXISTS id,
DROP COLUMN IF EXISTS ogc_fid,
DROP COLUMN IF EXISTS v,
DROP COLUMN IF EXISTS boro;