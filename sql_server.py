import json
import pyodbc

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
        self.cursor.execute("SELECT * FROM [User] WHERE username = '{username}' AND password = '{password}'")
        return self.cursor.arraysize

sql = SQLServer()