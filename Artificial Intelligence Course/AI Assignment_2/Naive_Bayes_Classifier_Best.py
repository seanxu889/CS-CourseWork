import math, os, pickle, re, collections


class Bayes_Classifier_Best:

    def __init__(self, trainDirectory="db_txt_files/"):
        '''This method initializes and trains the Naive Bayes Sentiment Classifier.  If a
        cache of a trained classifier has been stored, it loads this cache.  Otherwise,
        the system will proceed through training.  After running this method, the classifier
        is ready to classify input text.'''
        self.trainDirectory = trainDirectory
        self.pos_dic = collections.defaultdict(int)
        self.neg_dic = collections.defaultdict(int)
        self.neg_files = 0
        self.pos_files = 0
        # load the data
        if os.path.isfile('pos_dic_best.pkl') and os.path.isfile('neg_dic_best.pkl'):
            self.pos_dic = self.load('pos_dic_best.pkl')
            self.neg_dic = self.load('neg_dic_best.pkl')
            self.neg_files = self.load('neg_files_best.pkl')
            self.pos_files = self.load('pos_files_best.pkl')
        else:
            self.train()
        self.total_positive = sum(self.pos_dic.values())
        self.total_negative = sum(self.neg_dic.values())
        print (self.total_positive, self.total_negative, self.pos_files, self.neg_files)

    def train(self):
        '''Trains the Naive Bayes Sentiment Classifier.'''
        IFileList = []      # list of filenames will be stored in lFileList
        for fFileObj in os.walk(self.trainDirectory):
            IFileList = fFileObj[2]
            break
        
        self.pos_files = 0
        self.neg_files = 0
        
        for file in IFileList:
            stars = file.split('-')[1]
            if stars == '1':
                self.neg_files += 1
                text = self.tokenize(self.loadFile(os.path.join(self.trainDirectory, file)))
                for i in range(len(text)-1):
                    self.neg_dic[str(text[i].lower()) + " " + str(text[i+1].lower())] += 1                    

            elif stars == '5':
                self.pos_files += 1
                text = self.tokenize(self.loadFile(os.path.join(self.trainDirectory, file)))
                for i in range(len(text)-1):
                    self.pos_dic[str(text[i].lower()) + " " + str(text[i+1].lower())] += 1
                    
        self.save(self.neg_dic, 'neg_dic_best.pkl')
        self.save(self.pos_dic, 'pos_dic_best.pkl')
        self.save(self.neg_files, 'neg_files_best.pkl')
        self.save(self.pos_files, 'pos_files_best.pkl')

    def classify(self, sText):
        '''Given a target string sText, this function returns the most likely document
        class to which the target string belongs. This function should return one of three
        strings: "pos_dic", "neg_dic" or "neutral".
        '''
        '''Given a target string sText, this function returns the most likely document
        class to which the target string belongs (i.e., pos_dic, neg_dic or neutral).
        '''
        
        # prior
        pos = math.log10(1.0*self.pos_files/(self.pos_files+self.neg_files))
        neg = math.log10(1.0*self.neg_files/(self.pos_files+self.neg_files))

        # each word
        text = self.tokenize(sText)
        for i in range(len(text)-1):
            pos += math.log10((self.pos_dic[str(text[i].lower()) + " " + str(text[i+1].lower())] + 1.0) / self.total_positive)
            neg += math.log10((self.neg_dic[str(text[i].lower()) + " " + str(text[i+1].lower())] + 1.0) / self.total_negative)
    
        # two probabilities are near
        if (abs(pos - neg) < .5):
            return "neutral"
        # positive or negative
        elif pos > neg:
            return "positive"
        elif neg > pos:
            return "negative"

    def loadFile(self, sFilename):
        '''Given a file name, return the contents of the file as a string.'''

        f = open(sFilename, "r")
        sTxt = f.read()
        f.close()
        return sTxt

    def save(self, dObj, sFilename):
        '''Given an object and a file name, write the object to the file using pickle.'''

        f = open(sFilename, "w")
        p = pickle.Pickler(f)
        p.dump(dObj)
        f.close()

    def load(self, sFilename):
        '''Given a file name, load and return the object stored in the file.'''

        f = open(sFilename, "r")
        u = pickle.Unpickler(f)
        dObj = u.load()
        f.close()
        return dObj

    def tokenize(self, sText):
        '''Given a string of text sText, returns a list of the individual tokens that
        occur in that string (in order).'''

        lTokens = []
        sToken = ""
        for c in sText:
            if re.match("[a-zA-Z0-9]", str(c)) != None or c == "\'" or c == "_" or c == '-':
                sToken += c
            else:
                if sToken != "":
                    lTokens.append(sToken)
                    sToken = ""
                if c.strip() != "":
                    lTokens.append(str(c.strip()))

        if sToken != "":
            lTokens.append(sToken)

        return lTokens


#a = Bayes_Classifier_Best()
#print (a.classify("I love school"))