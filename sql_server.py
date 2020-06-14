import json
import pyodbc
import pandas as pd
from models import Student

with open("config.json", "r") as f:
    config = json.loads(f.read())
class SQLServer:
    def __init__(self, config = config['SQL-Server']):
        conn_str = ''
        for key, value in config.items():
            conn_str = f'{conn_str}{key}={value};'
        self.__open_connection(conn_str)
    def __open_connection(self, conn_str):
        try:
            self.conn = pyodbc.connect(conn_str)
            self.cursor = self.conn.cursor()
        except pyodbc.InterfaceError:
            print("[SQL Server] Driver not found")
            exit()
        except pyodbc.OperationalError:
            print("[SQL Server] Time out.. Can't open a connection to SQL Server")
            exit()
        except:
            print("[SQL Server] Can't open a connection to SQL Server")
            exit()
    def login(self, username, password):
        return pd.read_sql(f"SELECT * FROM [User] WHERE username = '{username}' AND password = '{password}'", self.conn).shape[0]

    def get_all_students(self):
        df =  pd.read_sql(f"SELECT * FROM Student", self.conn)
        return [Student(*kwargs.values()) for kwargs in df.to_dict(orient='records')]
    def close(self):
        self.conn.close()

sql = SQLServer()