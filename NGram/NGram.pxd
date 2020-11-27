from NGram.NGramNode cimport NGramNode
from NGram.SimpleSmoothing cimport SimpleSmoothing
from NGram.TrainedSmoothing cimport TrainedSmoothing


cdef class NGram:

    cdef NGramNode rootNode
    cdef int __N
    cdef double __lambda1, __lambda2
    cdef bint __interpolated
    cdef set __vocabulary
    cdef list __probabilityOfUnseen

    cpdef int getN(self)
    cpdef setN(self, int N)
    cpdef addNGramSentence(self, list symbols, int sentenceCount = *)
    cpdef addNGram(self, list symbols)
    cpdef int vocabularySize(self)
    cpdef setLambda2(self, double lambda1)
    cpdef setLambda3(self, double lambda1, double lambda2)
    cpdef calculateNGramProbabilitiesTrained(self, list corpus, TrainedSmoothing trainedSmoothing)
    cpdef calculateNGramProbabilitiesSimple(self, SimpleSmoothing simpleSmoothing)
    cpdef calculateNGramProbabilitiesSimpleLevel(self, SimpleSmoothing simpleSmoothing, int level)
    cpdef replaceUnknownWords(self, set dictionary)
    cpdef set constructDictionaryWithNonRareWords(self, int level, double probability)
    cpdef double __getUniGramPerplexity(self, list corpus)
    cpdef double __getBiGramPerplexity(self, list corpus)
    cpdef double __getTriGramPerplexity(self, list corpus)
    cpdef double getPerplexity(self, list corpus)
    cpdef double __getUniGramProbability(self, object w1)
    cpdef double __getBiGramProbability(self, object w1, object w2)
    cpdef double __getTriGramProbability(self, object w1, object w2, object w3)
    cpdef int getCount(self, list symbols)
    cpdef setProbabilityWithPseudoCount(self, double pseudoCount, int height)
    cpdef int __maximumOccurence(self, int height)
    cpdef __updateCountsOfCounts(self, list countsOfCounts, int height)
    cpdef list calculateCountsOfCounts(self, int height)
    cpdef setAdjustedProbability(self, list countsOfCounts, int height, double pZero)
    cpdef prune(self, double threshold)
    cpdef saveAsText(self, str fileName)