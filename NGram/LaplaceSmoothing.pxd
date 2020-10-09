from NGram.SimpleSmoothing cimport SimpleSmoothing


cdef class LaplaceSmoothing(SimpleSmoothing):

    cdef double __delta

    cpdef setProbabilities(self, object nGram, int level)
