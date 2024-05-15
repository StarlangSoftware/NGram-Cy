from NGram.SimpleSmoothing cimport SimpleSmoothing


cdef class NoSmoothing(SimpleSmoothing):

    cpdef setProbabilities(self,
                           object nGram,
                           int level):
        """
        Calculates the N-Gram probabilities with no smoothing
        :param nGram: N-Gram for which no smoothing is done.
        :param level: Height of the NGram node.
        """
        nGram.setProbabilityWithPseudoCount(0.0, level)

