import json
from flask_restful import Resource, reqparse

from sql_server import sql

class UserLogin(Resource):
    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument("username", required = True, help = 'Please enter an username')
        parser.add_argument('password', required = True, help = 'Please enter a password')
        args = parser.parse_args()
        username, password = args['username'], args['password']
        if sql.login(username, password):
            return {"message": "You have successfully logged in"}
        return {"error": "Incorrect username and/or password"}, 400