from NGram.SimpleSmoothing cimport SimpleSmoothing


cdef class NoSmoothing(SimpleSmoothing):

    cpdef setProbabilities(self, object nGram, int level)
