from NGram.SimpleSmoothing cimport SimpleSmoothing


cdef class TrainedSmoothing(SimpleSmoothing):

    cpdef learnParameters(self, list corpus, int N)
    cpdef double newLowerBound(self, double current, double currentLowerBound,
                      double currentUpperBound, int numberOfParts)
    cpdef double newUpperBound(self, double current, double currentLowerBound,
                      double currentUpperBound, int numberOfParts)
    cpdef train(self, list corpus, object nGram)