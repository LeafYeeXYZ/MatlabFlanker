# 编数据是不对的！！！

import random
import csv

# 定义字段名
fields = ['num', 'accuRent', 'meanRT', 'stdRT', 'accuRent_1', 'meanRT_1', 'stdRT_1', 'accuRent_0', 'meanRT_0', 'stdRT_0', 'nTrials', 'gender', 'grade', 'age', 'hand']

# 创建30个随机数据
rows = []
for _ in range(30):
    num = random.randint(250101000000, 250101100000)
    accuRent = round(random.uniform(0.96, 1), 15)
    meanRT = round(random.uniform(0.325, 0.425), 15)
    stdRT = round(random.uniform(0.055, 0.075), 15)
    accuRent_1 = round(random.uniform(0.98, 1), 15)
    meanRT_1 = round(random.uniform(0.3, 0.4), 15)
    stdRT_1 = round(random.uniform(0.05, 0.07), 15)
    accuRent_0 = round(random.uniform(0.97, 0.99), 15)
    meanRT_0 = round(random.uniform(0.35, 0.45), 15)
    stdRT_0 = round(random.uniform(0.06, 0.08), 15)
    nTrials = 72
    gender = random.randint(0, 1)
    grade = random.randint(20, 23)
    age = random.randint(16, 24)
    hand = 1
    rows.append([num, accuRent, meanRT, stdRT, accuRent_1, meanRT_1, stdRT_1, accuRent_0, meanRT_0, stdRT_0, nTrials, gender, grade, age, hand])

# 写入 CSV 文件
filename = "dataCalc.csv"
with open(filename, 'w') as csvfile:
    csvwriter = csv.writer(csvfile)
    csvwriter.writerow(fields)
    csvwriter.writerows(rows)