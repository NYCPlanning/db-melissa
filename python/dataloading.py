from cook import Importer
import os

def ETL():
    RECIPE_ENGINE = os.environ.get('RECIPE_ENGINE', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')

    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name='melissa_input')
    importer.import_table(schema_name='melissa_corrections')
    importer.import_table(schema_name='melissa_outsideofnyc')

if __name__ == "__main__":
    ETL()