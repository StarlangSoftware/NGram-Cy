cdef class SimpleSmoothing:

    cpdef setProbabilities(self, object nGram, int level):
        pass

    cpdef setProbabilitiesGeneral(self, object nGram):
        self.setProbabilities(nGram, nGram.getN())
