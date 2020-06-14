from flask_restful import Resource, marshal_with
from sql_server import sql
from models import student_serializer

class StudentListApi(Resource):
    @marshal_with(student_serializer)
    def get(self):
        students = sql.get_all_students()
        if students:
            return students
        return {"error": "No students"}, 404