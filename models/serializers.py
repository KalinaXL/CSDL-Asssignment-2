from flask_restful import fields

class FormatDateTime(fields.String):
    def format(self, value):
        date = super().format(value)
        l = date.split('-')
        return '/'.join(l[::-1])

student_serializer = {
    'id': fields.String,
    'fullname': fields.String,
    'address': fields.String,
    'gender': fields.String,
    'birthdate': FormatDateTime
}