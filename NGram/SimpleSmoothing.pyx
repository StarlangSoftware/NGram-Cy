cdef class SimpleSmoothing:

    cpdef setProbabilities(self,
                           object nGram,
                           int level):
        pass

    cpdef setProbabilitiesGeneral(self, object nGram):
        """
        Calculates the N-Gram probabilities with simple smoothing.
        :param nGram: N-Gram for which simple smoothing calculation is done.
        """
        self.setProbabilities(nGram, nGram.getN())
