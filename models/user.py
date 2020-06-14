class Person:
    def __init__(self, id, fullname, address, gender, birthdate):
        self.id = id
        self.fullname = fullname
        self.address = address
        self.gender = gender
        self.birthdate = birthdate

class Student(Person):
    pass

class Teacher(Person):
    def __init__(self, id, fullname, gender, email, address, phonenumber, cardid, birthdate, group_id):
        super().__init__(id, fullname, address, gender, birthdate)