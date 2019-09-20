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
SET borough_code = b.e_wa1_street1_boroughcode,
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
    -- nta_name = 
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
FROM melissa_input_geocode b
WHERE melissa.id = b.id;