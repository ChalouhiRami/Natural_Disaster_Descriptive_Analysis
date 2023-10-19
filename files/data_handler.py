import pandas as pd
import lookups
import error_handler
from logging_handler import configure_logger, log_error


def read_file(file_path):
    try:

        if file_path.endswith(lookups.Csv.value):
           return pd.read_csv(file_path)
        if file_path.endswith(lookups.Xlsx.value):
            return pd.read_excel(file_path)
    
        
    except Exception as error:
        prefix = lookups.ErrorHandling.Data_handler_error.value
        suffix = str(error)
        error_handler.print_error(suffix,prefix)
        log_error(f'An error occurred: {str(error)}')
        return None