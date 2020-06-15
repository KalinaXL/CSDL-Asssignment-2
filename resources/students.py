from flask_restful import Resource, marshal_with, reqparse
from sql_server import sql
from models import student_serializer

class StudentListApi(Resource):
    @marshal_with(student_serializer)
    def get(self):
        students = sql.get_all_students()
        if students:
            return students
        return {"error": "No students"}, 404
    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('id', required = True, help = 'Please enter a id')
        parser.add_argument('fullname', required = True, help = 'Please enter fullname')
        parser.add_argument('address', required = True, help = 'Please enter an address')
        parser.add_argument('gender', required = True, help = 'Please enter gender')
        parser.add_argument('birthdate', required = True, help = 'Please enter birthdate')
        args = parser.parse_args()
        result = sql.add_one_student(args)
        if isinstance(result, int):
            return {"message": f"Add student having id {args.id} successfully!"}
        return {"error": result + ' ' + args.id}, 401
class StudentApi(Resource):
    def delete(self, id):
        rowcount = sql.delete_one_student(id)
        if rowcount:
            return {"message": f"Delete student having id {id} successfully!"}
        return {"error": "Can't delete student having " + id}, 401