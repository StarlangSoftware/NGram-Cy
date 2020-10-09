from NGram.NGram cimport NGram


cdef class LaplaceSmoothing(SimpleSmoothing):

    def __init__(self, delta=1.0):
        self.__delta = delta

    cpdef setProbabilities(self, object nGram, int level):
        """
        Wrapper function to set the N-gram probabilities with laplace smoothing.

        PARAMETERS
        ----------
        nGram : NGram
            N-Gram for which the probabilities will be set.
        level : int
            height for NGram. if level = 1, If level = 1, N-Gram is treated as UniGram, if level = 2, N-Gram is treated
            as Bigram, etc.
        """
        nGram.setProbabilityWithPseudoCount(self.__delta, level)
