from flask import Flask, jsonify
from flaskext.mysql import MySQL
from flask_caching import Cache
#from config import BaseConfig
app = Flask(__name__)
#app.config.from_object(BaseConfig)
#cache = Cache(app)

mysql = MySQL()

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'sql'
app.config['MYSQL_DATABASE_PASSWORD'] = '123qwerR'
app.config['MYSQL_DATABASE_DB'] = 'pythonlogin'
app.config['MYSQL_DATABASE_HOST'] = 'svc-flask-db'

mysql.init_app(app)

# Redis Cache Config
#app.config.from_object(BaseConfig)


@app.route('/')
#@cache.cached(timeout=60)
def get():
    cur = mysql.connect().cursor()
    cur.execute('''select * from pythonlogin.accounts''')
    r = [dict((cur.description[i][0], value)
                for i, value in enumerate(row)) for row in cur.fetchall()]
    return jsonify({'myCollection' : r})

if __name__ == '__app__':
    app.run(host='0.0.0.0', port=5001)
