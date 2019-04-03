import os
import sys

testFile = "Naive_Bayes_Classifier.py"
if testFile == "Naive_Bayes_Classifier.py":
    from Naive_Bayes_Classifier import Bayes_Classifier
elif testFile == "Naive_Bayes_Classifier_Best.py":
    from Naive_Bayes_Classifier_Best import Bayes_Classifier_Best as Bayes_Classifier

if len(sys.argv) == 1:
    trainDir = "db_txt_files/"
    testDir = "movies_reviews/"

    bc = Bayes_Classifier(trainDir)
    iFileList = []

    for fFileObj in os.walk(testDir + "/"):
        iFileList = fFileObj[2]
        break
    print '%d test reviews.' % len(iFileList)

    print "\nFile Classifications:"
    bc_matrix = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
    for filename in iFileList:
        fileText = bc.loadFile(testDir + filename)
        result1 = bc.classify(fileText)
        stars = filename.split('-')[1]
        if (stars == "1"):
            if result1 == "negative":
                bc_matrix[0][0] += 1
            if result1 == "neutral":
                bc_matrix[0][1] += 1
            if result1 == "positive":
                bc_matrix[0][2] += 1

        elif (stars == "5"):
            if result1 == "negative":
                bc_matrix[2][0] += 1
            if result1 == "neutral":
                bc_matrix[2][1] += 1
            if result1 == "positive":
                bc_matrix[2][2] += 1

        else:
            if result1 == "negative":
                bc_matrix[1][0] += 1
            if result1 == "neutral":
                bc_matrix[1][1] += 1
            if result1 == "positive":
                bc_matrix[1][2] += 1

    if testFile == "Naive_Bayes_Classifier.py":
        print("Naive_Bayes_Classifier")
    elif testFile == "Naive_Bayes_Classifier_Best.py":
        print("Naive_Bayes_Classifier_Best")
    print ("confusion matrix:")
    print (bc_matrix)

    accuracy = (bc_matrix[0][0] + bc_matrix[2][2]) * 1.0 / (sum(bc_matrix[0]) + sum(bc_matrix[1]) + sum(bc_matrix[2]))

    recall = (bc_matrix[0][0] + bc_matrix[2][2]) * 1.0 / (
                bc_matrix[0][0] + bc_matrix[2][2] + bc_matrix[0][2] + bc_matrix[2][0])

    f = 2 * accuracy * recall / (recall + accuracy)

    print ("accuracy:", accuracy)
    print ("recall:", recall)
    print ("f-measure:", f)
    
else:
    trainDir = "db_txt_files/"
    testDir = sys.argv[1]

    bc = Bayes_Classifier(trainDir)
    iFileList = []

    for fFileObj in os.walk(testDir):
        iFileList = fFileObj[2]
        break

    for filename in iFileList:
        fileText = bc.loadFile(os.path.join(testDir, filename))
        result1 = bc.classify(fileText)
        print (testDir + filename, result1)
