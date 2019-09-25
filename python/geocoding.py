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
    boro = input.pop('boro')
    id = input.pop('id')

    boro = str('' if boro is None else boro)
    address = str('' if address is None else address)
    zip_code = str('' if zip_code is None else zip_code)
    id = str('' if id is None else id)

    hnum = get_hnum(address)
    sname = get_sname(address)

    geo1E = parse_1e(geo_try(hnum, sname, zip_code, boro, '1E', 'extended'))
    geo1A = parse_1a(geo_try(hnum, sname, zip_code, boro, '1A', 'tpad+extended'))
    geoAP = parse_ap(geo_try(hnum, sname, zip_code, boro, 'AP', 'extended'))

    geo = {**geo1A, **geo1E, **geoAP}
    geo.update(dict(id=id, hnum=hnum, sname=sname))
    return geo

def geo_try(hnum, sname, zip_code, boro, func, mode):
    try:
        if boro == '':
            return g[func](street_name=sname, house_number=hnum, zip_code=zip_code, mode=mode)
        else: 
            return g[func](street_name=sname, house_number=hnum, borough=boro, mode=mode)
    except GeosupportError as e:
        return e.result

def get_hnum(address):
    if '|' in address: 
        return address.split('|')[0]
    elif 'term mkt' in address.lower():
        return address.split(' ')[0]
    else: 
        fraction = re.findall('\d+[\/]\d+', address)
        rear = re.findall(' rear ', address, re.IGNORECASE)
        result = [k for (k,v) in usaddress.parse(address) \
                if re.search("Address", v)]  if address is not None else ''
        hnum = ' '.join(result)
        if bool(re.search('\d+[\/]\d+', hnum)) and len(fraction) != 0:
            pass
        else:
            if not bool(re.search('\d+[\/]\d+', hnum)) and len(fraction) != 0:
                hnum = f'{hnum} {fraction[0]}'

        if len(rear) != 0:
            hnum = f'{hnum} rear'
        return hnum

def get_sname(address):
    if '|' in address: 
        return address.split('|')[1]
    elif 'term mkt' in address.lower():
        return ' '.join(address.split(' ')[1:])
    else: 
        fraction = re.findall('\d+[\/]\d+', address)
        rear = re.findall(' rear ', address, re.IGNORECASE)

        result = [k for (k,v) in usaddress.parse(address) \
                if re.search("Street", v)]  if address is not None else ''
        result = ' '.join(result)
        if len(fraction) != 0: 
            for i in fraction: 
                result = result.replace(i, '')
        if len(rear) != 0:
            result = result.lower().replace('rear', '')
        if result == '':
            return address
        else:
            return result

def parse_1e(geo):
    return dict(
                e_WA1_HouseNumberDisplay = geo.get('House Number - Display Format', ''),
                e_WA1_STREET1_BoroughCode = geo.get('BOROUGH BLOCK LOT (BBL)', {}).get('Borough Code', '',),
                e_WA1_STREET1_StreetName = geo.get('First Street Name Normalized', ''),
                e_WA1_Message = geo.get('Message', 'msg err'),
                e_WA2_XCoordinate = geo.get('SPATIAL X-Y COORDINATES OF ADDRESS', {}).get('X Coordinate', '',),
                e_WA2_YCoordinate = geo.get('SPATIAL X-Y COORDINATES OF ADDRESS', {}).get('Y Coordinate', '',),
                e_WA2_CommunityDistrict = geo.get('COMMUNITY DISTRICT', {}).get('COMMUNITY DISTRICT', ''),
                e_WA2_NTA = geo.get('Neighborhood Tabulation Area (NTA)', ''),
                e_WA2_PhysicalID = geo.get('Physical ID', ''),
                e_WA2_NTAname = geo.get('NTA Name', ''),
                e_WA2_Latitude = geo.get('Latitude', ''),
                e_WA2_Longitude = geo.get('Longitude', ''),
                e_WA2_BlockfaceID = geo.get('Blockface ID', ''),
                e_WA2_ReasonCode = geo.get('Reason Code', ''),
                e_WA2_GRC = geo.get('Geosupport Return Code (GRC)', ''),        
            )

def parse_1a(geo):
    return dict(
                a_WA1_HouseNumberDisplay = geo.get('House Number - Display Format', ''),
                a_WA1_STREET1_StreetName = geo.get('First Street Name Normalized', ''),
                a_WA1_Message = geo.get('Message', 'msg err'),
                a_WA2_BBL = geo.get('BOROUGH BLOCK LOT (BBL)', {}).get('BOROUGH BLOCK LOT (BBL)', '',),
                a_WA2_BinOfInputAddress = geo.get('Building Identification Number (BIN) of Input Address or NAP', ''),
                a_WA2_TPADNewBin = geo.get('TPAD New BIN', ''),
                a_WA2_ReasonCode = geo.get('Reason Code', ''),
                a_WA2_GRC = geo.get('Geosupport Return Code (GRC)', ''),        
            )

def parse_ap(geo):
    xy_coord = geo.get('X-Y Coordinates of Address Point', '')
    return dict(
                ap_WA1_HouseNumberDisplay = geo.get('House Number - Display Format', ''),
                ap_WA1_STREET1_StreetName = geo.get('First Street Name Normalized', ''),
                ap_WA2_GRC = geo.get('Geosupport Return Code (GRC)', ''),
                ap_WA2_ReasonCode = geo.get('Reason Code', ''),
                ap_WA1_Message = geo.get('Message', 'msg err'),
                ap_WA2_Latitude = geo.get('Latitude', ''),
                ap_WA2_Longitude = geo.get('Longitude', ''),
                ap_WA2_XCoordinate = xy_coord, 
                ap_WA2_YCoordinate = xy_coord,
                ap_WA2_AP_ID = geo.get('Address Point ID', '')
            )

if __name__ == '__main__':
    # connect to postgres db
    engine = create_engine(os.environ['BUILD_ENGINE'])

    # read in housing table
    df = pd.read_sql('''SELECT DISTINCT id,
                        address, 
                        zip as zip_code, 
                        boro 
                        FROM melissa_input;''', engine)

    records = df.to_dict('records')
    
    os.system('clear')
    os.system('echo "\ngeocoding starts here ..."')

    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 10000)
    
    os.system('echo "\ngeocoding finished, writing to csv ..."')
    df = pd.DataFrame(it)
    df.to_csv(Path(__file__).parent.parent/'output/melissa_input_geocode.csv', index=False)

     # read in housing table
    df_corrections = pd.read_sql('''SELECT DISTINCT id,
                        concat(corrected_hn, '|', corrected_street) as address, 
                        '' as zip_code,
                        corrected_borough as boro
                        FROM melissa_corrections;''', engine)

    records_corrections = df_corrections.to_dict('records')
    
    os.system('echo "\ngeocoding corrections starts here ..."')

    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        it_corrections = pool.map(geocode, records_corrections, 10000)
    
    os.system('echo "\ngeocoding finished, writing corrections to csv ..."')
    df_corrections = pd.DataFrame(it_corrections)
    df_corrections.to_csv(Path(__file__).parent.parent/'output/melissa_corrections_geocode.csv', index=False)