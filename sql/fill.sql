-- completing the main table

-- insert corrected info
UPDATE melissa
SET corrected_borough = b.corrected_borough,
    corrected_house_number = b.corrected_hn,
    corrected_street_name = b.corrected_street
FROM melissa_corrections b
WHERE melissa.id = b.id;

-- 
UPDATE melissa
SET sname = b.sname, 
    hnum = b.hnum,
    borough_code = b.e_wa1_street1_boroughcode,
    f1_normalized_hn = b.e_wa1_housenumberdisplay,
    f1_normalized_sn = b.e_wa1_street1_streetname, 
    centerline_xcoordinate = b.e_wa2_xcoordinate, 
    centerline_ycoordinate = b.e_wa2_ycoordinate,
    centerline_latitude = b.e_wa2_latitude, 
    centerline_longitude = b.e_wa2_longitude,
    physicalid = b.e_wa2_physicalid, 
    blockfaceid = b.e_wa2_blockfaceid, 
    cd = b.e_wa2_communitydistrict, 
    nta = b.e_wa2_nta,
    nta_name = b.e_wa2_ntaname,
    f1_grc = b.e_wa2_grc, 
    f1_reasoncode = b.e_wa2_reasoncode,
    f1_message = b.e_wa1_message,
    f1a_normalized_hn = b.a_wa1_housenumberdisplay,
    f1a_normalized_sn = b.a_wa1_street1_streetname,
    bbl = b.a_wa2_bbl,
    f1a_grc = b.a_wa2_grc,
    f1a_reasoncode = b.a_wa2_reasoncode,
    f1a_message = b.a_wa1_message,
    fap_normalized_hn = b.ap_wa1_housenumberdisplay,
    fap_normalized_sn = b.ap_wa1_street1_streetname,
    addresspointid = b.ap_wa2_ap_id,
    addresspointid_xcoordinate = left(b.ap_wa2_xcoordinate, 7),
    addresspointid_ycoordinate = right(b.ap_wa2_ycoordinate,7),
    addresspointid_latitude = b.ap_wa2_latitude,
    addresspointid_longitude = b.ap_wa2_longitude,
    fap_grc = b.ap_wa2_grc,
    fap_reasoncode = b.ap_wa2_reasoncode,
    fap_message = b.ap_wa1_message
FROM melissa_corrections_geocode AS b 
WHERE melissa.id = b.id;

UPDATE melissa
SET borough_code = (CASE WHEN borough_code IS NULL THEN b.e_wa1_street1_boroughcode ELSE borough_code END),
    f1_normalized_hn = (CASE WHEN f1_normalized_hn IS NULL THEN b.e_wa1_housenumberdisplay ELSE f1_normalized_hn END),
    f1_normalized_sn = (CASE WHEN f1_normalized_sn IS NULL THEN b.e_wa1_street1_streetname ELSE f1_normalized_sn END),
    centerline_xcoordinate = (CASE WHEN centerline_xcoordinate IS NULL THEN b.e_wa2_xcoordinate ELSE centerline_xcoordinate END), 
    centerline_ycoordinate = (CASE WHEN centerline_ycoordinate IS NULL THEN b.e_wa2_ycoordinate ELSE centerline_ycoordinate END),
    centerline_latitude = (CASE WHEN centerline_latitude IS NULL THEN b.e_wa2_latitude ELSE centerline_latitude END), 
    centerline_longitude = (CASE WHEN centerline_longitude IS NULL THEN b.e_wa2_longitude ELSE centerline_longitude END),
    physicalid = (CASE WHEN physicalid IS NULL THEN b.e_wa2_physicalid ELSE physicalid END),
    blockfaceid = (CASE WHEN blockfaceid IS NULL THEN b.e_wa2_blockfaceid ELSE blockfaceid END),
    cd = (CASE WHEN cd IS NULL THEN b.e_wa2_communitydistrict ELSE cd END),
    nta = (CASE WHEN nta IS NULL THEN b.e_wa2_nta ELSE nta END),
    nta_name = (CASE WHEN nta_name IS NULL THEN b.e_wa2_ntaname ELSE nta_name END),
    f1_grc = (CASE WHEN f1_grc IS NULL THEN b.e_wa2_grc ELSE f1_grc END),
    f1_reasoncode = (CASE WHEN f1_reasoncode IS NULL THEN b.e_wa2_reasoncode ELSE f1_reasoncode END),
    f1_message = (CASE WHEN f1_message IS NULL THEN b.e_wa1_message ELSE f1_message END),
    f1a_normalized_hn = (CASE WHEN f1a_normalized_hn IS NULL THEN b.a_wa1_housenumberdisplay ELSE f1a_normalized_hn END),
    f1a_normalized_sn = (CASE WHEN f1a_normalized_sn IS NULL THEN b.a_wa1_street1_streetname ELSE f1a_normalized_sn END),
    bbl = (CASE WHEN bbl IS NULL THEN b.a_wa2_bbl ELSE bbl END),
    f1a_grc = (CASE WHEN f1a_grc IS NULL THEN b.a_wa2_grc ELSE f1a_grc END),
    f1a_reasoncode = (CASE WHEN f1a_reasoncode IS NULL THEN b.a_wa2_reasoncode ELSE f1a_reasoncode END),
    f1a_message = (CASE WHEN f1a_message IS NULL THEN b.a_wa1_message ELSE f1a_message END),
    fap_normalized_hn = (CASE WHEN fap_normalized_hn IS NULL THEN b.ap_wa1_housenumberdisplay ELSE fap_normalized_hn END),
    fap_normalized_sn = (CASE WHEN fap_normalized_sn IS NULL THEN b.ap_wa1_street1_streetname ELSE fap_normalized_sn END),
    addresspointid = (CASE WHEN addresspointid IS NULL THEN b.ap_wa2_ap_id ELSE addresspointid END),
    addresspointid_xcoordinate = (CASE WHEN addresspointid_xcoordinate IS NULL THEN left(b.ap_wa2_xcoordinate, 7) ELSE addresspointid_xcoordinate END),
    addresspointid_ycoordinate = (CASE WHEN addresspointid_xcoordinate IS NULL THEN right(b.ap_wa2_ycoordinate,7) ELSE addresspointid_xcoordinate END),
    addresspointid_latitude = (CASE WHEN addresspointid_latitude IS NULL THEN b.ap_wa2_latitude ELSE addresspointid_latitude END),
    addresspointid_longitude = (CASE WHEN addresspointid_longitude IS NULL THEN b.ap_wa2_longitude ELSE addresspointid_longitude END),
    fap_grc = (CASE WHEN fap_grc IS NULL THEN b.ap_wa2_grc ELSE fap_grc END),
    fap_reasoncode = (CASE WHEN fap_reasoncode IS NULL THEN b.ap_wa2_reasoncode ELSE fap_reasoncode END),
    fap_message = (CASE WHEN fap_message IS NULL THEN b.ap_wa1_message ELSE fap_message END)
FROM melissa_input_geocode AS b 
WHERE melissa.id = b.id;

-- logic for filling bins for corrected addresses
WITH correction AS (
    SELECT * FROM melissa_input_geocode
    WHERE id IN (
        SELECT DISTINCT(id)
	    FROM melissa_corrections_geocode
    )
)
UPDATE melissa
SET bin = (CASE
            WHEN a.a_wa2_tpadnewbin IS NOT NULL THEN a.a_wa2_tpadnewbin
            WHEN a.a_wa2_tpadnewbin IS NULL
                AND a.a_wa2_binofinputaddress IS NOT NULL 
            THEN a.a_wa2_binofinputaddress
            WHEN a.a_wa2_tpadnewbin IS NULL
                AND a.a_wa2_binofinputaddress IS NULL
                AND b.a_wa2_tpadnewbin IS NOT NULL 
            THEN b.a_wa2_tpadnewbin
            WHEN a.a_wa2_tpadnewbin IS NULL
                AND a.a_wa2_binofinputaddress IS NULL
                AND b.a_wa2_tpadnewbin IS NULL
                AND b.a_wa2_binofinputaddress IS NOT NULL 
            THEN b.a_wa2_binofinputaddress
            ELSE NULL
        END),
is_tpad_bin = (CASE
            WHEN a.a_wa2_tpadnewbin IS NOT NULL THEN 'Y'
            WHEN a.a_wa2_tpadnewbin IS NULL
                AND b.a_wa2_tpadnewbin IS NOT NULL THEN 'Y'
            ELSE NULL
            END)
FROM melissa_corrections_geocode AS a, correction AS b
WHERE melissa.id = b.id AND melissa.id = a.id;

-- logic for filling bins for non-corrected addresses
WITH no_correciton AS (
    SELECT * FROM melissa_input_geocode
    WHERE id NOT IN (
        SELECT DISTINCT(id)
	    FROM melissa_corrections_geocode
    )
)
UPDATE melissa
SET bin = (CASE
            WHEN b.a_wa2_tpadnewbin IS NOT NULL THEN b.a_wa2_tpadnewbin
            WHEN b.a_wa2_tpadnewbin IS NULL
                AND b.a_wa2_binofinputaddress IS NOT NULL 
            THEN b.a_wa2_binofinputaddress
            ELSE NULL
        END),
is_tpad_bin = (CASE
            WHEN b.a_wa2_tpadnewbin IS NOT NULL THEN 'Y'
            ELSE NULL
            END)
FROM no_correciton AS b
WHERE melissa.id = b.id;

-- logic for adding address, city, state, zip
WITH input AS (
    SELECT DISTINCT id, address, city, state, zip 
    FROM melissa_input
)
UPDATE melissa
SET address = b.address, 
    city = b.city,
    state = b.state, 
    zip = b.zip
FROM input AS b
WHERE melissa.id = b.id;