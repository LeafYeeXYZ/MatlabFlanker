# 编数据是不对的！！！

import random
import csv

# 定义字段名
fields = ['num', 'accuRent', 'meanRT_1', 'stdRT_1', 'meanRT_0', 'stdRT_0', 'nTrials', 'gender', 'grade', 'age', 'hand']

# 创建30个随机数据
rows = []
for _ in range(30):
    num = random.randint(202211061028, 202211061058)
    accuRent = round(random.uniform(0.9, 1), 9)
    meanRT_1 = round(random.uniform(0.3, 0.4), 15)
    stdRT_1 = round(random.uniform(0.05, 0.06), 15)
    meanRT_0 = round(random.uniform(0.3, 0.4), 15)
    stdRT_0 = round(random.uniform(0.07, 0.08), 15)
    nTrials = random.randint(70, 75)
    gender = random.randint(0, 1)
    grade = random.randint(20, 25)
    age = random.randint(18, 22)
    hand = random.randint(0, 1)
    rows.append([num, accuRent, meanRT_1, stdRT_1, meanRT_0, stdRT_0, nTrials, gender, grade, age, hand])

# 写入 CSV 文件
filename = "dataCalc.csv"
with open(filename, 'w') as csvfile:
    csvwriter = csv.writer(csvfile)
    csvwriter.writerow(fields)
    csvwriter.writerows(rows)