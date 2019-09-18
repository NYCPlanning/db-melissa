from multiprocessing import Pool, cpu_count
from sqlalchemy import create_engine
from geosupport import Geosupport, GeosupportError
from pathlib import Path
import pandas as pd
import usaddress
import json
import re
import os 

g = Geosupport()

def geocode(input):
    # collect inputs
    address = input.pop('address')
    zip_code = input.pop('zip_code')
    id = str('' if address is None else address) +\
        str('' if zip_code is None else zip_code)
    hnum = get_hnum(address)
    sname = get_sname(address)

    geo1E = parse_1e(geo_try(hnum, sname, zip_code, '1E', 'extended'))
    geo1A = parse_1a(geo_try(hnum, sname, zip_code, '1A', 'tpad'))
    geoAP = parse_ap(geo_try(hnum, sname, zip_code, 'AP', 'extended'))

    geo = {**geo1A, **geo1E, **geoAP}
    geo.update(dict(id=id))
    return geo

def geo_try(hnum, sname, zip_code, func, mode): 
    try: 
        return g[func](street_name=sname, house_number=hnum, zip_code=zip_code, mode=mode)
    except GeosupportError as e:
        return e.result

def get_hnum(address):
        result = [k for (k,v) in usaddress.parse(address) \
                if re.search("Address", v)]  if address is not None else ''
        return ' '.join(result)

def get_sname(address):
        result = [k for (k,v) in usaddress.parse(address) \
                if re.search("Street", v)]  if address is not None else ''
        return ' '.join(result)

def parse_1e(geo):
    return dict(
                WA1_HouseNumberDisplay = geo.get('House Number - Display Format', ''),
                WA1_STREET1_BoroughCode = geo.get('BOROUGH BLOCK LOT (BBL)', {}).get('Borough Code', '',),
                WA1_STREET1_StreetName = geo.get('First Street Name Normalized', ''),
                WA1_Message = geo.get('Message', 'msg err'),
                WA2_XCoordinate = geo.get('SPATIAL X-Y COORDINATES OF ADDRESS', {}).get('X Coordinate', '',),
                WA2_YCoordinate = geo.get('SPATIAL X-Y COORDINATES OF ADDRESS', {}).get('Y Coordinate', '',),
                WA2_CommunityDistrict = geo.get('COMMUNITY DISTRICT', {}).get('COMMUNITY DISTRICT', ''),
                WA2_NTA = geo.get('Neighborhood Tabulation Area (NTA)', ''),
                WA2_PhysicalID = geo.get('Physical ID', ''),
                WA2_NTAname = geo.get('NTA Name', ''),
                WA2_Latitude = geo.get('Latitude', ''),
                WA2_Longitude = geo.get('Longitude', ''),
                WA2_BlockfaceID = geo.get('Blockface ID', ''),
                WA2_ReasonCode = geo.get('Reason Code', ''),
                WA2_GRC = geo.get('Geosupport Return Code (GRC)', ''),        
            )

def parse_1a(geo):
    return dict(
                WA1_HouseNumberDisplay = geo.get('House Number - Display Format', ''),
                WA1_STREET1_StreetName = geo.get('First Street Name Normalized', ''),
                WA1_Message = geo.get('Message', 'msg err'),
                WA2_BBL = geo.get('BOROUGH BLOCK LOT (BBL)', {}).get('BOROUGH BLOCK LOT (BBL)', '',),
                WA2_BinOfInputAddress = geo.get('Building Identification Number (BIN) of Input Address or NAP', ''),
                WA2_TPADNewBin = geo.get('TPAD New BIN', ''),
                WA2_ReasonCode = geo.get('Reason Code', ''),
                WA2_GRC = geo.get('Geosupport Return Code (GRC)', ''),        
            )

def parse_ap(geo):
    xy_coord = geo.get('X-Y Coordinates of Address Point', '')
    return dict(
                WA1_HouseNumberDisplay = geo.get('House Number - Display Format', ''),
                WA1_STREET1_StreetName = geo.get('First Street Name Normalized', ''),
                WA2_GRC = geo.get('Geosupport Return Code (GRC)', ''),
                WA2_ReasonCode = geo.get('Reason Code', ''),
                WA1_Message = geo.get('Message', 'msg err'),
                WA2_Latitude = geo.get('Latitude', ''),
                WA2_Longitude = geo.get('Longitude', ''),
                WA2_XCoordinate = xy_coord, 
                WA2_YCoordinate = xy_coord,
                WA2_AP_ID = geo.get('Address Point ID', '')
            )

if __name__ == '__main__':
    # connect to postgres db
    engine = create_engine(os.environ['BUILD_ENGINE'])

    # read in housing table
    df = pd.read_sql("SELECT DISTINCT address, zip as zip_code FROM melissa_input;", engine)

    records = df.to_dict('records')
    
    os.system('echo "\ngeocoding begins here ..."')

    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 100000)
    
    print('geocoding finished, dumping tp postgres ...')
    df = pd.DataFrame(it)
    df.to_csv(Path(__file__).parent.parent/'output/melissa_input_geocode.csv', index=False)
    df.to_sql('melissa_input_geocode', engine, if_exists='replace', chunksize=100000)