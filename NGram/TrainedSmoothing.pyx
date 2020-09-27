cdef class TrainedSmoothing(SimpleSmoothing):

    cpdef learnParameters(self, list corpus, int N):
        pass

    cpdef double newLowerBound(self, double current, double currentLowerBound,
                      double currentUpperBound, int numberOfParts):
        """
        Calculates new lower bound.

        PARAMETERS
        ----------
        current : float
            current value.
        currentLowerBound : float
            current lower bound
        currentUpperBound : float
            current upper bound
        numberOfParts : int
            number of parts between lower and upper bound.

        RETURNS
        -------
        float
            new lower bound
        """
        if current != currentLowerBound:
            return current - (currentUpperBound - currentLowerBound) / numberOfParts
        else:
            return current / numberOfParts

    cpdef double newUpperBound(self, double current, double currentLowerBound,
                      double currentUpperBound, int numberOfParts):
        """
        Calculates new upper bound.

        PARAMETERS
        ----------
        current : float
            current value.
        currentLowerBound : float
            current lower bound
        currentUpperBound : float
            current upper bound
        numberOfParts : int
            number of parts between lower and upper bound.

        RETURNS
        -------
        float
            new upper bound
        """
        if current != currentUpperBound:
            return current + (currentUpperBound - currentLowerBound) / numberOfParts
        else:
            return current * numberOfParts

    cpdef train(self, list corpus, object nGram):
        """
        Wrapper function to learn parameters of the smoothing method and set the N-gram probabilities.

        PARAMETERS
        ----------
        corpus : list
            Train corpus used to optimize parameters of the smoothing method.
        nGram : NGram
            N-Gram for which the probabilities will be set.
        """
        self.learnParameters(corpus, nGram.getN())
        self.setProbabilitiesGeneral(nGram)
