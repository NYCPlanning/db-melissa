import os
import pandas as pd
from pathlib import Path
from .utils import psql_insert_copy
from sqlalchemy import create_engine

# importer.import_table(schema_name='melissa_corrections')
# importer.import_table(schema_name='melissa_outsideofnyc')


if __name__ == "__main__":
    BUILD_ENGINE = create_engine(os.environ.get('BUILD_ENGINE', ''))
    df = pd.read_csv(Path(__file__).parent.parent/'data' /
                     'MelissaData2021.txt', dtype=str, delimiter='|', index_col=False)
    df.columns = [c.lower().replace(' ', '_') for c in df.columns]
    df.to_sql('melissa_input', BUILD_ENGINE,
              if_exists='replace', method=psql_insert_copy, index=False)
