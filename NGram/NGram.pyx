from DataStructure.CounterHashMap cimport CounterHashMap
from NGram.MultipleFile cimport MultipleFile

import math


cdef class NGram:

    def __init__(self, NorFileName, corpus=None):
        """
        Constructor of NGram class which takes a list corpus and Integer size of ngram as input.
        It adds all sentences of corpus as ngrams.

        PARAMETERS
        ----------
        NorFileName
            size of ngram.
            fileName
        corpus : list
            list of sentences whose ngrams are added.
        """
        cdef int i, vocabularySize
        cdef list items
        cdef str line
        if isinstance(NorFileName, int):
            self.__N = NorFileName
            self.__vocabulary = set()
            self.__probabilityOfUnseen = self.__N * [0.0]
            self.__lambda1 = 0.0
            self.__lambda2 = 0.0
            self.__interpolated = False
            self.rootNode = NGramNode(None)
            if corpus is not None:
                for i in range(len(corpus)):
                    self.addNGramSentence(corpus[i])
        else:
            inputFile = open(NorFileName, mode="r", encoding="utf-8")
            line = inputFile.readline().strip()
            items = line.split()
            self.__N = int(items[0])
            self.__lambda1 = float(items[1])
            self.__lambda2 = float(items[2])
            self.__probabilityOfUnseen = self.__N * [0.0]
            self.__interpolated = False
            line = inputFile.readline().strip()
            items = line.split()
            for i in range(len(items)):
                self.__probabilityOfUnseen[i] = float(items[i])
            self.__vocabulary = set()
            vocabularySize = int(inputFile.readline().strip())
            for i in range(vocabularySize):
                self.__vocabulary.add(inputFile.readline().strip())
            self.rootNode = NGramNode(True, inputFile)
            inputFile.close()

    def initWithMultipleFile(self, *args):
        cdef MultipleFile multipleFile
        cdef int i, vocabularySize
        cdef list items
        cdef str line
        multipleFile = MultipleFile(list(args))
        line = multipleFile.readLine().strip()
        items = line.split()
        self.__N = int(items[0])
        self.__lambda1 = float(items[1])
        self.__lambda2 = float(items[2])
        self.__probabilityOfUnseen = self.__N * [0.0]
        self.__interpolated = False
        line = multipleFile.readLine().strip()
        items = line.split()
        for i in range(len(items)):
            self.__probabilityOfUnseen[i] = float(items[i])
        self.__vocabulary = set()
        vocabularySize = int(multipleFile.readLine().strip())
        for i in range(vocabularySize):
            self.__vocabulary.add(multipleFile.readLine().strip())
        self.rootNode = NGramNode(True, multipleFile)

    cpdef int getN(self):
        """
        RETURNS
        -------
        int
            size of ngram.
        """
        return self.__N

    cpdef setN(self, int N):
        """
        Set size of ngram.

        PARAMETERS
        ----------
        N : int
            size of ngram
        """
        self.__N = N

    cpdef addNGramSentence(self, list symbols, int sentenceCount = 1):
        """
        Adds given sentence to set the vocabulary and create and add ngrams of the sentence to NGramNode the rootNode

        PARAMETERS
        ----------
        symbols : list
            Sentence whose ngrams are added.
        sentenceCount : int
            Number of times this sentence is added.
        """
        cdef object s
        cdef int j
        for s in symbols:
            self.__vocabulary.add(s)
        for j in range(len(symbols) - self.__N + 1):
            self.rootNode.addNGram(symbols, j, self.__N, sentenceCount)

    cpdef addNGram(self, list symbols):
        """
        Adds given array of symbols to set the vocabulary and to NGramNode the rootNode

        PARAMETERS
        ----------
        symbols : list
            ngram added.
        """
        cdef object s
        for s in symbols:
            self.__vocabulary.add(s)
        self.rootNode.addNGram(symbols, 0, self.__N)

    cpdef int vocabularySize(self):
        """
        RETURNS
        -------
        int
            vocabulary size.
        """
        return len(self.__vocabulary)

    cpdef setLambda2(self, double lambda1):
        """
        Sets lambda, interpolation ratio, for bigram and unigram probabilities.
        ie. lambda1 * bigramProbability + (1 - lambda1) * unigramProbability

        PARAMETERS
        ----------
        lambda1 : float
            interpolation ratio for bigram probabilities
        """
        if self.__N == 2:
            self.__interpolated = True
            self.__lambda1 = lambda1

    cpdef setLambda3(self, double lambda1, double lambda2):
        """
        Sets lambdas, interpolation ratios, for trigram, bigram and unigram probabilities.
        ie. lambda1 * trigramProbability + lambda2 * bigramProbability  + (1 - lambda1 - lambda2) * unigramProbability

        PARAMETERS
        ----------
        lambda1 : float
            interpolation ratio for trigram probabilities
        lambda2 : float
            interpolation ratio for bigram probabilities
        """
        if self.__N == 3:
            self.__interpolated = True
            self.__lambda1 = lambda1
            self.__lambda2 = lambda2

    cpdef calculateNGramProbabilitiesTrained(self, list corpus, TrainedSmoothing trainedSmoothing):
        """
        Calculates NGram probabilities using given corpus and TrainedSmoothing smoothing method.

        PARAMETERS
        ----------
        corpus : list
            corpus for calculating NGram probabilities.
        trainedSmoothing : TrainedSmoothing
            instance of smoothing method for calculating ngram probabilities.
        """
        trainedSmoothing.train(corpus, self)

    cpdef calculateNGramProbabilitiesSimple(self, SimpleSmoothing simpleSmoothing):
        """
        Calculates NGram probabilities using simple smoothing.

        PARAMETERS
        ----------
        simpleSmoothing : SimpleSmoothing
        """
        simpleSmoothing.setProbabilitiesGeneral(self)

    cpdef calculateNGramProbabilitiesSimpleLevel(self, SimpleSmoothing simpleSmoothing, int level):
        """
        Calculates NGram probabilities given simple smoothing and level.

        PARAMETERS
        ----------
        simpleSmoothing : SimpleSmoothing
        level : int
            Level for which N-Gram probabilities will be set.
        """
        simpleSmoothing.setProbabilities(self, level)

    cpdef replaceUnknownWords(self, set dictionary):
        """
        Replaces words not in set given dictionary.

        PARAMETERS
        ----------
        dictionary : set
            dictionary of known words.
        """
        self.rootNode.replaceUnknownWords(dictionary)

    cpdef set constructDictionaryWithNonRareWords(self, int level, double probability):
        """
        Constructs a dictionary of nonrare words with given N-Gram level and probability threshold.

        PARAMETERS
        ----------
        level : int
            Level for counting words. Counts for different levels of the N-Gram can be set. If level = 1, N-Gram is
            treated as UniGram, if level = 2, N-Gram is treated as Bigram, etc.
        probability : float
            probability threshold for nonrare words.

        RETURNS
        -------
        set
            set of nonrare words.
        """
        cdef set result
        cdef CounterHashMap wordCounter
        cdef double total
        result = set()
        wordCounter = CounterHashMap()
        self.rootNode.countWords(wordCounter, level)
        total = wordCounter.sumOfCounts()
        for symbol in wordCounter.keys():
            if wordCounter[symbol] / total > probability:
                result.add(symbol)
        return result

    cpdef double __getUniGramPerplexity(self, list corpus):
        """
        Calculates unigram perplexity of given corpus. First sums negative log likelihoods of all unigrams in corpus.
        Then returns exp of average negative log likelihood.

        PARAMETERS
        ----------
        corpus : list
            corpus whose unigram perplexity is calculated.

        RETURNS
        -------
        float
            unigram perplexity of corpus.
        """
        cdef double total, p
        cdef int count, i, j
        total = 0
        count = 0
        for i in range(len(corpus)):
            for j in range(len(corpus[i])):
                p = self.getProbability(corpus[i][j])
                total -= math.log(p)
                count += 1
        return math.exp(total / count)

    cpdef double __getBiGramPerplexity(self, list corpus):
        """
        Calculates bigram perplexity of given corpus. First sums negative log likelihoods of all bigrams in corpus.
        Then returns exp of average negative log likelihood.

        PARAMETERS
        ----------
        corpus : list
            corpus whose bigram perplexity is calculated.

        RETURNS
        -------
        float
            bigram perplexity of corpus.
        """
        cdef double total, p
        cdef int count, i, j
        total = 0
        count = 0
        for i in range(len(corpus)):
            for j in range(len(corpus[i]) - 1):
                p = self.getProbability(corpus[i][j], corpus[i][j + 1])
                total -= math.log(p)
                count += 1
        return math.exp(total / count)

    cpdef double __getTriGramPerplexity(self, list corpus):
        """
        Calculates trigram perplexity of given corpus. First sums negative log likelihoods of all trigrams in corpus.
        Then returns exp of average negative log likelihood.

        PARAMETERS
        ----------
        corpus : list
            corpus whose trigram perplexity is calculated.

        RETURNS
        -------
        float
            trigram perplexity of corpus.
        """
        cdef double total, p
        cdef int count, i, j
        total = 0
        count = 0
        for i in range(len(corpus)):
            for j in range(len(corpus[i]) - 2):
                p = self.getProbability(corpus[i][j], corpus[i][j + 1], corpus[i][j + 2])
                total -= math.log(p)
                count += 1
        return math.exp(total / count)

    cpdef double getPerplexity(self, list corpus):
        """
        Calculates the perplexity of given corpus depending on N-Gram model (unigram, bigram, trigram, etc.)

        PARAMETERS
        ----------
        corpus : list
            corpus whose perplexity is calculated.

        RETURNS
        -------
        float
            perplexity of given corpus
        """
        if self.__N == 1:
            return self.__getUniGramPerplexity(corpus)
        elif self.__N == 2:
            return self.__getBiGramPerplexity(corpus)
        elif self.__N == 3:
            return self.__getTriGramPerplexity(corpus)
        else:
            return 0

    def getProbability(self, *args) -> float:
        """
        Gets probability of sequence of symbols depending on N in N-Gram. If N is 1, returns unigram probability.
        If N is 2, if interpolated is true, then returns interpolated bigram and unigram probability, otherwise returns
        only bigram probability.
        If N is 3, if interpolated is true, then returns interpolated trigram, bigram and unigram probability, otherwise
        returns only trigram probability.

        PARAMETERS
        ----------
        args
            symbols sequence of symbol.

        RETURNS
        -------
        float
            probability of given sequence.
        """
        if self.__N == 1:
            return self.__getUniGramProbability(args[0])
        elif self.__N == 2:
            if len(args) == 1:
                return self.__getUniGramProbability(args[0])
            if self.__interpolated:
                return self.__lambda1 * self.__getBiGramProbability(args[0], args[1]) + (1 - self.__lambda1) \
                       * self.__getUniGramProbability(args[1])
            else:
                return self.__getBiGramProbability(args[0], args[1])
        elif self.__N == 3:
            if len(args) == 1:
                return self.__getUniGramProbability(args[0])
            elif len(args) == 2:
                return self.__getBiGramProbability(args[0], args[1])
            if self.__interpolated:
                return self.__lambda1 * self.__getTriGramProbability(args[0], args[1], args[2]) + \
                       self.__lambda2 * self.__getBiGramProbability(args[1], args[2]) + \
                       (1 - self.__lambda1 - self.__lambda2) * self.__getUniGramProbability(args[2])
            else:
                return self.__getTriGramProbability(args[0], args[1], args[2])
        else:
            return 0.0

    cpdef double __getUniGramProbability(self, object w1):
        """
        Gets unigram probability of given symbol.

        PARAMETERS
        ----------
        w1
            a unigram symbol.

        RETURNS
        -------
        float
            probability of given unigram.
        """
        return self.rootNode.getUniGramProbability(w1)

    cpdef double __getBiGramProbability(self, object w1, object w2):
        """
        Gets bigram probability of given symbols.

        PARAMETERS
        ----------
        w1
            first gram of bigram
        w2
            second gram of bigram

        RETURNS
        -------
        float
            probability of bigram formed by w1 and w2.
        """
        cdef double probability
        probability = self.rootNode.getBiGramProbability(w1, w2)
        if probability != -1:
            return probability
        else:
            return self.__probabilityOfUnseen[1]

    cpdef double __getTriGramProbability(self, object w1, object w2, object w3):
        """
        Gets trigram probability of given symbols.

        PARAMETERS
        ----------
        w1
            first gram of trigram
        w2
            second gram of trigram
        w3
            third gram of trigram

        RETURNS
        -------
        float
            probability of trigram formed by w1, w2, w3.
        """
        cdef double probability
        probability = self.rootNode.getTriGramProbability(w1, w2, w3)
        if probability != -1:
            return probability
        else:
            return self.__probabilityOfUnseen[2]

    cpdef int getCount(self, list symbols):
        """
        Gets count of given sequence of symbol.

        PARAMETERS
        ----------
        symbols : list
            sequence of symbol.

        RETURNS
        -------
        int
            count of symbols.
        """
        return self.rootNode.getCountForListItem(symbols, 0)

    cpdef setProbabilityWithPseudoCount(self, double pseudoCount, int height):
        """
        Sets probabilities by adding pseudocounts given height and pseudocount.

        PARAMETERS
        ----------
        pseudoCount : float
            pseudocount added to all N-Grams.
        height : int
            height for NGram. if height = 1, If level = 1, N-Gram is treated as UniGram, if level = 2, N-Gram is treated
            as Bigram, etc.
        """
        cdef double vocabularySize
        if pseudoCount != 0:
            vocabularySize = self.vocabularySize() + 1
        else:
            vocabularySize = self.vocabularySize()
        self.rootNode.setProbabilityWithPseudoCount(pseudoCount, height, vocabularySize)
        if pseudoCount != 0:
            self.__probabilityOfUnseen[height - 1] = 1.0 / vocabularySize
        else:
            self.__probabilityOfUnseen[height - 1] = 0.0

    cpdef int __maximumOccurence(self, int height):
        """
        Find maximum occurrence in given height.

        PARAMETERS
        ----------
        height : int
            height for occurrences. If height = 1, N-Gram is treated as UniGram, if height = 2, N-Gram is treated as
            Bigram,
            etc.

        RETURNS
        -------
        int
            maximum occurrence in given height.
        """
        return self.rootNode.maximumOccurence(height)

    cpdef __updateCountsOfCounts(self, list countsOfCounts, int height):
        """
        Update counts of counts of N-Grams with given counts of counts and given height.

        PARAMETERS
        ----------
        countsOfCounts : list
            updated counts of counts.
        height : int
            height for NGram. If height = 1, N-Gram is treated as UniGram, if height = 2, N-Gram is treated as Bigram,
            etc.
        """
        self.rootNode.updateCountsOfCounts(countsOfCounts, height)

    cpdef list calculateCountsOfCounts(self, int height):
        """
        Calculates counts of counts of NGrams.

        PARAMETERS
        ----------
        height : int
            height for NGram. If height = 1, N-Gram is treated as UniGram, if height = 2, N-Gram is treated as Bigram,
            etc.

        RETURNS
        -------
        list
            counts of counts of NGrams.
        """
        cdef int maxCount
        cdef list countsOfCounts
        maxCount = self.__maximumOccurence(height)
        countsOfCounts = [0] * (maxCount + 2)
        self.__updateCountsOfCounts(countsOfCounts, height)
        return countsOfCounts

    cpdef setAdjustedProbability(self, list countsOfCounts, int height, double pZero):
        """
        Sets probability with given counts of counts and pZero.

        PARAMETERS
        ----------
        countsOfCounts : list
            counts of counts of NGrams.
        height : int
            height for NGram. If height = 1, N-Gram is treated as UniGram, if height = 2, N-Gram is treated as Bigram,
            etc.
        pZero : float
            probability of zero.
        """
        self.rootNode.setAdjustedProbability(countsOfCounts, height, self.vocabularySize() + 1, pZero)
        self.__probabilityOfUnseen[height - 1] = 1.0 / (self.vocabularySize() + 1)

    cpdef prune(self, double threshold):
        if threshold > 0.0 and threshold <= 1.0:
            self.rootNode.prune(threshold, self.__N - 1)

    cpdef saveAsText(self, str fileName):
        """
        Save this NGram to a text file.

        PARAMETERS
        ----------
        fileName : str
            String name of file where NGram is saved.
        """
        cdef double p
        cdef object symbol
        outputFile = open(fileName, mode="w", encoding="utf8")
        outputFile.write(self.__N.__str__() + " " + self.__lambda1.__str__() + " " + self.__lambda2.__str__() + "\n")
        for p in self.__probabilityOfUnseen:
            outputFile.write(p.__str__() + " ")
        outputFile.write("\n")
        outputFile.write(self.vocabularySize().__str__() + "\n")
        for symbol in self.__vocabulary:
            outputFile.write(symbol.__str__() + "\n")
        self.rootNode.saveAsText(True, outputFile, 0)
        outputFile.close()
