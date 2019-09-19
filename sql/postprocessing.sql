DROP TABLE IF EXISTS melissa_1e;
CREATE TABLE melissa_1e AS (
    SELECT 
        e_wa1_housenumberdisplay AS wa1_housenumberdisplay,
        e_wa1_street1_boroughcode AS wa1_street1_boroughcode,
        e_wa1_street1_streetname AS wa1_street1_streetname,
        e_wa1_message AS wa1_message,
        e_wa2_xcoordinate AS wa2_xcoordinate,
        e_wa2_ycoordinate AS wa2_ycoordinate,
        e_wa2_communitydistrict AS wa2_communitydistrict,
        e_wa2_nta AS wa2_nta,
        e_wa2_physicalid AS wa2_physicalid,
        e_wa2_ntaname AS wa2_ntaname,
        e_wa2_latitude AS wa2_latitude,
        e_wa2_longitude AS wa2_longitude,
        e_wa2_blockfaceid AS wa2_blockfaceid,
        e_wa2_reasoncode AS wa2_reasoncode,
        e_wa2_grc AS wa2_grc
    FROM melissa_input_geocode
); 

DROP TABLE IF EXISTS melissa_1a;
CREATE TABLE melissa_1a AS (
    SELECT id,
        a_wa1_housenumberdisplay AS wa1_housenumberdisplay,
        a_wa1_street1_streetname AS wa1_street1_streetname,
        a_wa1_message AS wa1_message,
        a_wa2_bbl AS wa2_bbl,
        a_wa2_binofinputaddress AS wa2_binofinputaddress,
        a_wa2_tpadnewbin AS wa2_tpadnewbin,
        a_wa2_reasoncode AS wa2_reasoncode,
        a_wa2_grc AS wa2_grc
    FROM melissa_input_geocode

); 

DROP TABLE IF EXISTS melissa_ap;
CREATE TABLE melissa_ap AS (
    SELECT id,
        ap_wa1_housenumberdisplay AS wa1_housenumberdisplay,
        ap_wa1_street1_streetname AS wa1_street1_streetname,
        ap_wa2_grc AS wa2_grc,
        ap_wa2_reasoncode AS wa2_reasoncode,
        ap_wa1_message AS wa1_message,
        ap_wa2_latitude AS wa2_latitude,
        ap_wa2_longitude AS wa2_longitude,
        ap_wa2_xcoordinate AS wa2_xcoordinate,
        ap_wa2_ycoordinate AS wa2_ycoordinate,
        ap_wa2_ap_id AS wa2_id
    FROM melissa_input_geocode
);