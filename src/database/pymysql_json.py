import pymysql
import sys

def getConnection(parms):
    """Establishes and returns a database connection."""
    # Database connection parameters
    db_params = {
            'host': parms.get("host"),
            'port': parms.get("port"),
            'user': parms.get("user"),
            'password': parms.get("password"),
            'database': parms.get("schema"),
            'connect_timeout': 5,
            'local_infile': True,
            'cursorclass': pymysql.cursors.DictCursor
            }

    try:
    # Attempt to establish the connection
        conn = pymysql.connect(**db_params)
        # You can now proceed with creating a cursor and executing queries
        # print("JSON Connection successful!")
        # ...

    except pymysql.MySQLError as e:
        # Catch specific PyMySQL errors during connection attempt
        print(f"Error connecting to MySQL database: {e}")
        # You might want to log the error, display a user-friendly message, or exit the program
        sys.exit(1) # Exit the script upon connection failure

    except Exception as e:
        # Catch any other potential exceptions
        print(f"An unexpected error occurred: {e}")
        sys.exit(1)

    finally:
        # Ensure the connection is closed if it was opened successfully
        return conn
#        if 'conn' in locals() and conn.open:
#            conn.close()
#            print("Connection closed.")
