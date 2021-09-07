import os
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine

from .utils import psql_insert_copy


if __name__ == "__main__":
    BUILD_ENGINE = create_engine(os.environ.get("BUILD_ENGINE", ""))
    df = pd.read_csv(
        Path(__file__).parent.parent / "data" / "MelissaData2021.txt",
        dtype=str,
        delimiter="|",
        index_col=False,
    )
    df.columns = [c.lower().replace(" ", "_") for c in df.columns]
    df.to_sql(
        "melissa_input",
        BUILD_ENGINE,
        if_exists="replace",
        method=psql_insert_copy,
        index=False,
    )

    pd.read_csv(
        Path(__file__).parent.parent / "data" / "melissa_corrections.csv",
        dtype=str,
        index_col=False,
    ).to_sql(
        "melissa_corrections",
        BUILD_ENGINE,
        if_exists="replace",
        method=psql_insert_copy,
        index=False,
    )

    pd.read_csv(
        Path(__file__).parent.parent / "data" / "melissa_outsideofnyc.csv",
        dtype=str,
        index_col=False,
    ).to_sql(
        "melissa_outsideofnyc",
        BUILD_ENGINE,
        if_exists="replace",
        method=psql_insert_copy,
        index=False,
    )
