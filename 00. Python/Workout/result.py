
def findTotal(marks):
    return sum(marks)

def findResult(marks, passMark=45):
    for mark in marks:
        if mark < passMark:
            result = 'Fail'
            break
    else:
        result = 'Pass'
    return result

def findPercentage(marks):
    return round(sum(marks)/len(marks),2)

def calculateResult(student):
    print(__name__)
    passMark=45
    student['total'] = findTotal(student['marks'])
    student['result'] = findResult(student['marks'], passMark)      
    if student['result'] == 'Pass':
        student['percentage'] = findPercentage(student['marks'])
    return student
