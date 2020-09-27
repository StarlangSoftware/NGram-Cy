from NGram.SimpleSmoothing cimport SimpleSmoothing


cdef class GoodTuringSmoothing(SimpleSmoothing):

    cpdef list __linearRegressionOnCountsOfCounts(self, list countsOfCounts)
    cpdef setProbabilities(self, object nGram, int level)