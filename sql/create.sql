DROP TABLE IF EXISTS melissa;
CREATE TABLE melissa (
    id text,
    Corrected_Borough text,
    Corrected_House_Number text,
    Corrected_Street_Name text,
    Borough_Code text,
    F1_Normalized_HN text,
    F1_Normalized_SN text,
    Centerline_XCoordinate text,
    Centerline_YCoordinate text,
    Centerline_Latitude text,
    Centerline_Longitude text,
    PhysicalID text,
    BlockfaceID text,
    CD text,
    NTA text,
    NTA_Name text,
    F1_GRC text,
    F1_ReasonCode text,
    F1_Message text,
    F1A_Normalized_HN text,
    F1A_Normalized_SN text,
    BIN text,
    Is_TPAD_BIN text,
    BBL text,
    F1A_GRC text,
    F1A_ReasonCode text,
    F1A_Message text,
    FAP_Normalized_HN text,
    FAP_Normalized_SN text,
    AddressPointID text,
    AddressPointID_XCoordinate text,
    AddressPointID_YCoordinate text,
    AddressPointID_Latitude text,
    AddressPointID_Longitude text,
    FAP_GRC text,
    FAP_ReasonCode text,
    FAP_Message text
);

INSERT INTO melissa (id)
SELECT b.id
FROM (SELECT DISTINCT id FROM melissa_input) AS b;