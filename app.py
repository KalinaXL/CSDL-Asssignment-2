import requests
import json
from functools import wraps
from flask import Flask, request, render_template, redirect, url_for, session, flash
from flask_restful import Api
from resources import UserLogin, StudentListApi, StudentApi
from utils import is_name, is_email, is_phone_number, is_valid_date
with open("config.json", "r") as f:
    config = json.loads(f.read())
app_config = config['app']
path = config['path'] + app_config['prefix_api']


def login_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if 'logged_in' in session and session['logged_in']:
            return f(*args, **kwargs)
        else:
            return redirect(url_for('login'))
    return wrapper

app = Flask(__name__)
app.secret_key = app_config['secret_key']
api = Api(app = app, prefix = app_config['prefix_api'])
api.add_resource(UserLogin, "/auth/login")
api.add_resource(StudentListApi, '/students')
api.add_resource(StudentApi, '/students/<string:id>' )

@app.route('/', methods = ['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        user = {
            'username': request.form['username'],
            'password': request.form['password']
        }
        response = requests.post(f'{path}/auth/login', data = user)
        if response:
            session['logged_in'] = True
            return redirect(url_for("dashboard"))
        else:
            error = response.json()['error']
    return render_template('login.html', title = 'Login', error = error)


@app.route('/dashboard', methods = ['GET', 'POST'])
@login_required
def dashboard():
    response = requests.get(f'{path}/students')
    if response:
        students = response.json()
    else:
        students = []
    return render_template("dashboard.html", title = "Dashboard", students = students, teachers = [])
@app.route('/logout')
@login_required
def logout():
    session['logged_in'] = False
    return redirect(url_for('login'))
@app.route('/add_student', methods = ['GET', 'POST'])
@login_required
def add_student():
    def is_valid_user(args):
        return is_name(args['fullname']) and args['gender'].upper() in ('M', 'F') and is_valid_date(args['birthdate'])
    if request.method == 'POST':
        if not is_valid_user(request.form):
            flash("Invalid input", 'error')
        else:
            response = requests.post(f'{path}/students', data = request.form)
            output = response.json()
            if 'error' in output:
                flash(output['error'], 'error')
            else:
                flash(output['message'], 'success')
        return redirect(url_for('dashboard'))
@app.route('/')
def edit_student(id):
    return 'add student'

@login_required
@app.route('/delete_student/<string:id>')
def delete_student(id):
    response = requests.delete(f'{path}/students/{id}')
    output = response.json()
    if 'error' in output:
        flash(output.get('error'), 'error')
    else:
        flash(output.get('message'), 'success')
    return redirect(url_for('dashboard'))
@app.route('/')
def delete_teacher(id):
    return 'delete student'
@app.route('/')
def edit_teacher(id):
    return 'delete student'
@app.route('/')
def add_teacher():
    return 'delete student'
@app.route('/')
def add_subject():
    return 'delete student'
if __name__ == "__main__":
    app.run(debug = True)