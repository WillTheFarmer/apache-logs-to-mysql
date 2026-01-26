# version 4.0.1 - 01/24/2026 - Proper Python code, NGINX format support and Python/SQL repository separation - see changelog
# application-level error handle
from apis.error_app import add_error

import pymysql
import sys

from os import getenv
from dotenv import load_dotenv

load_dotenv() # Load environment variables from .env file

mysql_host = getenv('MYSQL_HOST')
mysql_port = int(getenv('MYSQL_PORT'))
mysql_user = getenv('MYSQL_USER')
mysql_password = getenv('MYSQL_PASSWORD')
mysql_schema = getenv('MYSQL_SCHEMA')

def get_connection():
    """Establishes and returns a database connection."""
    # Database connection parameters
    db_params = {
        'host': mysql_host,
        'port': mysql_port,
        'user': mysql_user,
        'password': mysql_password,
        'database': mysql_schema,
        'connect_timeout': 5,
        'local_infile': True
    }

    try:
    # Attempt to establish the connection
        conn = pymysql.connect(host=mysql_host,
                               port=mysql_port,
                               user=mysql_user,
                               password=mysql_password,
                               database=mysql_schema,
                               connect_timeout=5,
                               local_infile=True)  
        # You can now proceed with creating a cursor and executing queries
        # print("ENV Connection successful!")
        return conn

    except pymysql.err.OperationalError as e:
        add_error({__name__},{type(e).__name__}, f"Database connection failed: {e}")

    except pymysql.err.MySQLError as e:
        # Catch specific PyMySQL errors during connection attempt
        add_error({__name__},{type(e).__name__}, f"Error connecting to MySQL database: {e}")
        # print(f"Error connecting to MySQL database: {e}")
        # You might want to log the error, display a user-friendly message, or exit the program
        sys.exit(1) # Exit the script upon connection failure

    except Exception as e:
        # Catch any other potential exceptions
        add_error({__name__},{type(e).__name__}, f"An unexpected error occurred: {e}")
        # print(f"An unexpected error occurred: {e}")
        sys.exit(1)
