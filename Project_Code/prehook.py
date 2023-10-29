import database_handler
import data_handler
import lookups
import os 
import glob 

def execute_prehook_statements(db_session):
    sql_files = glob.glob("**/*.sql")

    for sql_file in sql_files:
         
        file_name = sql_file.split("\\")[-1]
         
        if "_prehook" in file_name:
            query = None
            print(file_name)   
            
            with open(sql_file, "r") as f:
                query = f.read()
            database_handler.execute_query(db_session, query)
            db_session.commit()

def generate_list_of_csv_sources():
    csv_list = []

     
    csv_files = glob.glob(os.path.join("C:/Datasets", "*.csv"))
    csv_list.extend(csv_files)
    print(f"csv_list: {csv_list}")
    return csv_list
     

def create_sql_staging_tables(db_session, csv_list):
    
    for csv_item in csv_list:
        stg_df = data_handler.read_data_as_dataframe(lookups.FileType.CSV, csv_item)
        schema_name = "dwreporting"
        table_name = csv_item.replace('\\', '/').split('/')[-1].replace('.csv', '').lower()
        create_statement = data_handler.return_create_statement_from_df(stg_df, schema_name, table_name)
        database_handler.execute_query(db_session, create_statement)
    
    