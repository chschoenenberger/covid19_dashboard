import pandas as pd
import numpy as np
import time
import os
import datetime

def normalize_str(s):
    """ Function for name normalization (handle áéíóú). """
    return unicodedata.normalize("NFKD", s).encode("ascii","ignore").decode("ascii").upper()

CSVS_TO_DOWNLOAD = {
    'Argentina_Provinces.csv': 'https://raw.githubusercontent.com/mariano22/argcovidapi/master/csvs/Argentina_Provinces.csv',
    'SantaFe_AllData.csv': 'https://raw.githubusercontent.com/mariano22/argcovidapi/master/csvs/SantaFe_AllData.csv',
}
DATA_DIR = './data/'

def _download_expired_data():
    for csv_fn, csv_remote_fp in CSVS_TO_DOWNLOAD.items():
        csv_fp = os.path.join(DATA_DIR, csv_fn)
        if (not os.path.isfile(csv_fp)) or (time.time()-os.stat(csv_fp).st_mtime>30*60):
            print('Downloading',csv_fn)
            pd.read_csv(csv_remote_fp).to_csv(csv_fp,index=False)

def _load_National_data(csv_fp):
    df_arg = pd.read_csv(csv_fp)
    df_arg['LOCATION'] = 'ARGENTINA/' + df_arg['PROVINCIA']
    df_arg = df_arg.drop(columns=['PROVINCIA'])
    df_arg = df_arg.set_index(['TYPE','LOCATION'])
    df_arg = df_arg.rename(columns=lambda colname: pd.to_datetime(colname,format='%d/%m').replace(year=2020))

    total_arg = df_arg.groupby(level=[0]).sum()
    total_arg['LOCATION']='ARGENTINA'
    total_arg = total_arg.reset_index().set_index(['TYPE','LOCATION'])

    df_arg = pd.concat([df_arg,total_arg]).sort_index()
    return df_arg

def _set_location_safe(row):
    location_prefix = 'ARGENTINA/SANTA FE'
    if row['DEPARTMENT']=='##TOTAL':
        return location_prefix
    location_prefix += '/'+row['DEPARTMENT'][3:]
    if row['PLACE'].startswith('#'):
        return location_prefix
    return location_prefix +'/'+ row['PLACE']

def _load_SantaFe_data(csv_fp):
    df_safe = pd.read_csv(csv_fp)
    df_safe['LOCATION'] = df_safe.apply(_set_location_safe, axis=1)
    df_safe = df_safe[ (df_safe['TYPE']=='CONFIRMADOS') &  (df_safe['DEPARTMENT']!='##TOTAL') ]
    df_safe = df_safe.drop(columns=['DEPARTMENT', 'PLACE'])
    df_safe = df_safe.set_index(['TYPE','LOCATION'])
    df_safe = df_safe.rename(columns=lambda colname: pd.to_datetime(colname,format='%d/%m/%Y'))
    return df_safe

def _load_data_time_series():
    df_arg = _load_National_data(os.path.join(DATA_DIR, 'Argentina_Provinces.csv'))
    df_safe = _load_SantaFe_data(os.path.join(DATA_DIR, 'SantaFe_AllData.csv'))
    df = pd.concat([df_arg,df_safe])
    # Non described dates are 0's
    df = df.fillna(0).sort_index()

    df_diff = df.apply(lambda r : pd.concat([pd.Series([0]), r]).diff().drop(0),axis=1)
    df_diff.index = df_diff.index.map(lambda x : (x[0]+'_DIFF',x[1]) )
    df = pd.concat([df,df_diff]).sort_index()
    return df

def _only_povs(df):
    df = df[ df['LOCATION'].apply(lambda l : l.count('/')==1) ].copy()
    df['LOCATION'] = df['LOCATION'].apply(lambda l : l[10:])
    return df

def _soon_deprecated_data(df_time_series, df_info):
    df_time_series=_only_povs(df_time_series)
    df_info=_only_povs(df_info)
    df_time_series['2020-03-02 00:00:00']=0.0

    df = pd.melt(df_time_series, id_vars=['TYPE','LOCATION'], value_vars=df_time_series.columns[2:], var_name='date')
    df = df[ df['TYPE'].apply(lambda t: t in ['ACTIVOS','CONFIRMADOS','MUERTOS','RECUPERADOS']) ]
    df['TYPE'] = df['TYPE'].replace({
        'ACTIVOS': 'active',
        'CONFIRMADOS': 'confirmed',
        'MUERTOS': 'deceased',
        'RECUPERADOS': 'recovered',
    })
    df = pd.merge(df,df_info,on='LOCATION')
    df['Province/State']=df['LOCATION']
    df = df.rename(columns={
            'TYPE':'var',
            'LAT':'Lat',
            'LONG':'Long',
            'LOCATION':'Country/Region',
            'POPULATION': 'population',
        })
    df = df[ [ 'date', 'Country/Region', 'Province/State', 'var', 'value', 'Lat', 'Long', 'population' ] ]
    df = df.sort_values(by=['Country/Region','date','var'])
    df['value_new'] = df['value'].diff(4)
    df = df.sort_values(by=['date', 'Country/Region','var'])
    df = df[df['date']!='2020-03-02']
    return df

def _calculate_global_status():
    df_time_series =_load_data_time_series().reset_index()
    df_geoinfo =  pd.read_csv(os.path.join(DATA_DIR, 'info_arg.csv'))
    return {
        'timestamp': datetime.datetime.today().strftime('%Y-%m-%d-%H:%M:%S'),
        'geoinfo': df_geoinfo,
        'time_series': df_time_series,
        'soon_deprecated': _soon_deprecated_data(df_time_series, df_geoinfo)
    }

_global_status = None
def backend_update_data():
    global _global_status
    print("Updating backend...")
    _download_expired_data()
    _global_status = _calculate_global_status()

def backend_global_status_getter(field):
    global _global_status
    return _global_status[field]

def backend_data_at_date(date):
    global _global_status
    return _global_status['time_series'][date].swaplevel(0,1).unstack()
