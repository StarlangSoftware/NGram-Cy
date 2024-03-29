from Sampling.KFoldCrossValidation cimport KFoldCrossValidation

from NGram.NGram cimport NGram
from NGram.TrainedSmoothing cimport TrainedSmoothing
import math


cdef class AdditiveSmoothing(TrainedSmoothing):

    cdef double __delta

    cpdef double __learnBestDelta(self,
                                  list nGrams,
                                  KFoldCrossValidation kFoldCrossValidation,
                                  double lowerBound):
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
        cdef double best_previous, best_delta, upper_bound, best_perplexity, value, perplexity
        cdef int number_of_parts
        best_previous = -1
        upper_bound = 1
        best_delta = (lowerBound + upper_bound) / 2
        number_of_parts = 5
        while True:
            best_perplexity = 100000000
            value = lowerBound
            while value <= upper_bound:
                perplexity = 0
                for i in range(0, 10):
                    nGrams[i].setProbabilityWithPseudoCount(value, nGrams[i].getN())
                    perplexity += nGrams[i].getPerplexity(kFoldCrossValidation.getTestFold(i))
                if perplexity < best_perplexity:
                    best_perplexity = perplexity
                    best_delta = value
                value += (upper_bound - lowerBound) / number_of_parts
            lowerBound = self.newLowerBound(best_delta, lowerBound, upper_bound, number_of_parts)
            upper_bound = self.newUpperBound(best_delta, lowerBound, upper_bound, number_of_parts)
            if best_previous != -1:
                if math.fabs(best_previous - best_perplexity) / best_perplexity < 0.001:
                    break
            best_previous = best_perplexity
        return best_delta

    cpdef learnParameters(self,
                          list corpus,
                          int N):
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
        cdef list n_grams
        cdef KFoldCrossValidation k_fold_cross_validation
        K = 10
        n_grams = []
        k_fold_cross_validation = KFoldCrossValidation(corpus, K, 0)
        for i in range(K):
            n_grams.append(NGram(N, k_fold_cross_validation.getTrainFold(i)))
        self.__delta = self.__learnBestDelta(n_grams, k_fold_cross_validation, 0.1)

    cpdef setProbabilities(self,
                           object nGram,
                           int level):
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
