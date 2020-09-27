from NGram.SimpleSmoothing cimport SimpleSmoothing


cdef class NoSmoothing(SimpleSmoothing):

    cpdef setProbabilities(self, object nGram, int level):
        nGram.setProbabilityWithPseudoCount(0.0, level)

