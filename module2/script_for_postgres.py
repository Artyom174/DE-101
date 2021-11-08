from configparser import ConfigParser
import psycopg2
import psycopg2.extras
import pandas as pd
import pandas.io.sql as sqlio
#при желании filename и section можно вынести и отдельно передавать в функцию.
def config(filename='C:/Users/User/database.ini', section='postgresql'):
    # create a parser
    parser = ConfigParser()
    # read config file
    parser.read(filename)

    # get section, default to postgresql
    db: dict[str, str] = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, filename))

    return db


def read_tables(sql_query):
    con = None
    try:
        # read the connection parameters
        params = config()
        # connect to the PostgreSQL server
        con = psycopg2.connect(**params)
        # read sql query
        return sqlio.read_sql_query(sql_query, con)

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        
