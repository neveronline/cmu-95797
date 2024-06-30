import duckdb
import sys

def get_table_row_counts(db):
    # Connect to DuckDB
    # conn = duckdb.connect('/Users/jun/Desktop/cmu-95797/main.db')
    # this should read from the command line
    conn = duckdb.connect(db)
    # List of tables to check
    tables = [
        'fhv_bases',
        'central_park_weather',
        'yellow_tripdata',
        'green_tripdata',
        'fhvhv_tripdata',
        'fhv_tripdata',
        'bike_data'
    ]

    # Iterate through tables and print row counts
    for table in tables:
        try:
            result = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()
            print(f"Table: {table}, Row Count: {result[0]}")
        except duckdb.Error as e:
            print(f"Error accessing table {table}: {e}")

if __name__ == '__main__':
    get_table_row_counts(sys.argv[1])
