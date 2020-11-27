from DataStructure.CounterHashMap cimport CounterHashMap


cdef class NGramNode(object):

    cdef dict __children
    cdef object __symbol
    cdef int __count
    cdef double __probability, __probabilityOfUnseen
    cdef NGramNode __unknown

    cpdef int getCount(self)
    cpdef double getProbability(self)
    cpdef int size(self)
    cpdef int maximumOccurence(self, int height)
    cpdef double childSum(self)
    cpdef updateCountsOfCounts(self, list countsOfCounts, int height)
    cpdef setProbabilityWithPseudoCount(self, double pseudoCount, int height, double vocabularySize)
    cpdef setAdjustedProbability(self, list N, int height, double vocabularySize, double pZero)
    cpdef addNGram(self, list s, int index, int height, int sentenceCount = *)
    cpdef double getUniGramProbability(self, object w1)
    cpdef double getBiGramProbability(self, object w1, object w2)
    cpdef double getTriGramProbability(self, object w1, object w2, object w3)
    cpdef countWords(self, CounterHashMap wordCounter, int height)
    cpdef replaceUnknownWords(self, set dictionary)
    cpdef int getCountForListItem(self, list s, int index)
    cpdef object generateNextString(self, list s, int index)
    cpdef prune(self, double threshold, int N)
    cpdef saveAsText(self, bint isRootNode, object outputFile, int level)