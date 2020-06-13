import requests
import json
from flask import Flask, request, render_template, redirect, url_for
from flask_restful import Api
from flask_login import login_required, LoginManager
from resources import UserLogin

with open("config.json", "r") as f:
    path = json.loads(f.read())["path"]

app = Flask(__name__)
app.secret_key = 'CSDL_ASSIGNMENT2'
login_manager = LoginManager(app)
login_manager.login_view = 'login'
api = Api(app = app, prefix = '/api/v1')
api.add_resource(UserLogin, "/auth/login")
@app.route('/', methods = ['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        user = {
            'username': request.form['username'],
            'password': request.form['password']
        }
        response = requests.post(f'{path}/api/v1/auth/login', data = user)
        if response:
            return redirect(url_for("dashboard"))
        else:
            error = response.json()['error']
    return render_template('login.html', title = 'Login', error = error)
@app.route('/dashboard', methods = ['GET', 'POST'])
def dashboard():
    return "Hello ! CSDL Assignment 2"
if __name__ == "__main__":
    app.run(debug = True)