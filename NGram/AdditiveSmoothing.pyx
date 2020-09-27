from Sampling.KFoldCrossValidation cimport KFoldCrossValidation

from NGram.NGram cimport NGram
from NGram.TrainedSmoothing cimport TrainedSmoothing
import math


cdef class AdditiveSmoothing(TrainedSmoothing):

    cdef double __delta

    cpdef double __learnBestDelta(self, list nGrams, KFoldCrossValidation kFoldCrossValidation, double lowerBound):
        """
        The algorithm tries to optimize the best delta for a given corpus. The algorithm uses perplexity on the
        validation set as the optimization criterion.

        PARAMETERS
        ----------
        nGrams : list
            10 N-Grams learned for different folds of the corpus. nGrams[i] is the N-Gram trained with i'th train fold
            of the corpus.
        kFoldCrossValidation: KFoldCrossValidation
            Cross-validation data used in training and testing the N-grams.
        lowerBound : float
            Initial lower bound for optimizing the best delta.

        RETURNS
        -------
        float
            Best delta optimized with k-fold crossvalidation.
        """
        cdef double bestPrevious, bestDelta, upperBound, bestPerplexity, value, perplexity
        cdef int numberOfParts
        bestPrevious = -1
        upperBound = 1
        bestDelta = (lowerBound + upperBound) / 2
        numberOfParts = 5
        while True:
            bestPerplexity = 100000000
            value = lowerBound
            while value <= upperBound:
                perplexity = 0
                for i in range(0, 10):
                    nGrams[i].setProbabilityWithPseudoCount(value, nGrams[i].getN())
                    perplexity += nGrams[i].getPerplexity(kFoldCrossValidation.getTestFold(i))
                if perplexity < bestPerplexity:
                    bestPerplexity = perplexity
                    bestDelta = value
                value += (upperBound - lowerBound) / numberOfParts
            lowerBound = self.newLowerBound(bestDelta, lowerBound, upperBound, numberOfParts)
            upperBound = self.newUpperBound(bestDelta, lowerBound, upperBound, numberOfParts)
            if bestPrevious != -1:
                if math.fabs(bestPrevious - bestPerplexity) / bestPerplexity < 0.001:
                    break
            bestPrevious = bestPerplexity
        return bestDelta

    cpdef learnParameters(self, list corpus, int N):
        """
        Wrapper function to learn the parameter (delta) in additive smoothing. The function first creates K NGrams
        with the train folds of the corpus. Then optimizes delta with respect to the test folds of the corpus.

        PARAMETERS
        ----------
        corpus : list
            Train corpus used to optimize delta parameter
        N : int
            N in N-Gram.
        """
        cdef int K, i
        cdef list nGrams
        cdef KFoldCrossValidation kFoldCrossValidation
        K = 10
        nGrams = []
        kFoldCrossValidation = KFoldCrossValidation(corpus, K, 0)
        for i in range(K):
            nGrams.append(NGram(N, kFoldCrossValidation.getTrainFold(i)))
        self.__delta = self.__learnBestDelta(nGrams, kFoldCrossValidation, 0.1)

    cpdef setProbabilities(self, object nGram, int level):
        """
        Wrapper function to set the N-gram probabilities with additive smoothing.

        PARAMETERS
        ----------
        nGram : NGram
            N-Gram for which the probabilities will be set.
        level : int
            Level for which N-Gram probabilities will be set. Probabilities for different levels of the N-gram can be
            set with this function. If level = 1, N-Gram is treated as UniGram, if level = 2, N-Gram is treated as
            Bigram, etc.
        """
        nGram.setProbabilityWithPseudoCount(self.__delta, level)

    cpdef double getDelta(self):
        """
        Gets the best delta.

        RETURNS
        -------
        float
            learned best delta
        """
        return self.__delta
