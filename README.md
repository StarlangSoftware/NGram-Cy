N-Gram
============

An N-gram is a sequence of N words: a 2-gram (or bigram) is a two-word sequence of words like “lütfen ödevinizi”, “ödevinizi çabuk”, or ”çabuk veriniz”, and a 3-gram (or trigram) is a three-word sequence of words like “lütfen ödevinizi çabuk”, or “ödevinizi çabuk veriniz”.

## Smoothing

To keep a language model from assigning zero probability to unseen events, we’ll have to shave off a bit of probability mass from some more frequent events and give it to the events we’ve never seen. This modification is called smoothing or discounting.

### Laplace Smoothing

The simplest way to do smoothing is to add one to all the bigram counts, before we normalize them into probabilities. All the counts that used to be zero will now have a count of 1, the counts of 1 will be 2, and so on. This algorithm is called Laplace smoothing.

### Add-k Smoothing

One alternative to add-one smoothing is to move a bit less of the probability mass from the seen to the unseen events. Instead of adding 1 to each count, we add a fractional count k. This algorithm is therefore called add-k smoothing.

Video Lectures
============

[<img src="https://github.com/StarlangSoftware/NGram/blob/master/video1.jpg" width="50%">](https://youtu.be/oNWKVUdPUJY)[<img src="https://github.com/StarlangSoftware/NGram/blob/master/video2.jpg" width="50%">](https://youtu.be/ZG5m6OFdudI)

For Developers
============

You can also see [Python](https://github.com/starlangsoftware/NGram-Py), [Java](https://github.com/starlangsoftware/NGram), [C](https://github.com/starlangsoftware/NGram-C), [C++](https://github.com/starlangsoftware/NGram-CPP), [Swift](https://github.com/starlangsoftware/NGram-Swift), [Js](https://github.com/starlangsoftware/NGram-Js), or [C#](https://github.com/starlangsoftware/NGram-CS) repository.

## Requirements

* [Python 3.7 or higher](#python)
* [Git](#git)

### Python 

To check if you have a compatible version of Python installed, use the following command:

    python -V
    
You can find the latest version of Python [here](https://www.python.org/downloads/).

### Git

Install the [latest version of Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

## Pip Install

	pip3 install NlpToolkit-NGram-Cy

## Download Code

In order to work on code, create a fork from GitHub page. 
Use Git for cloning the code to your local or below line for Ubuntu:

	git clone <your-fork-git-link>

A directory called NGram will be created. Or you can use below link for exploring the code:

	git clone https://github.com/starlangsoftware/NGram-Cy.git

## Open project with Pycharm IDE

Steps for opening the cloned project:

* Start IDE
* Select **File | Open** from main menu
* Choose `NGram-CY` file
* Select open as project option
* Couple of seconds, dependencies will be downloaded. 

Detailed Description
============

+ [Training NGram](#training-ngram)
+ [Using NGram](#using-ngram)
+ [Saving NGram](#saving-ngram)
+ [Loading NGram](#loading-ngram)

## Training NGram
     
To create an empty NGram model:

	NGram(N: int)

For example,

	a = NGram(2)

this creates an empty NGram model.

To add an sentence to NGram

	addNGramSentence(self, symbols: list)

For example,

	nGram = NGram(2)
	nGram.addNGramSentence(["jack", "read", "books", "john", "mary", "went"])
	nGram.addNGramSentence(["jack", "read", "books", "mary", "went"])


with the lines above, an empty NGram model is created and two sentences are
added to the bigram model.

NoSmoothing class is the simplest technique for smoothing. It doesn't require training.
Only probabilities are calculated using counters. For example, to calculate the probabilities
of a given NGram model using NoSmoothing:

	a.calculateNGramProbabilities(NoSmoothing())

LaplaceSmoothing class is a simple smoothing technique for smoothing. It doesn't require
training. Probabilities are calculated adding 1 to each counter. For example, to calculate
the probabilities of a given NGram model using LaplaceSmoothing:

	a.calculateNGramProbabilities(LaplaceSmoothing())

GoodTuringSmoothing class is a complex smoothing technique that doesn't require training.
To calculate the probabilities of a given NGram model using GoodTuringSmoothing:

	a.calculateNGramProbabilities(GoodTuringSmoothing())

AdditiveSmoothing class is a smoothing technique that requires training.

	a.calculateNGramProbabilities(AdditiveSmoothing())

## Using NGram

To find the probability of an NGram:

	getProbability(self, *args) -> float

For example, to find the bigram probability:

	a.getProbability("jack", "reads")

To find the trigram probability:

	a.getProbability("jack", "reads", "books")

## Saving NGram
    
To save the NGram model:

	saveAsText(self, fileName: str)

For example, to save model "a" to the file "model.txt":

	a.saveAsText("model.txt");              

## Loading NGram            

To load an existing NGram model:

	NGram(fileName: str)

For example,

	a = NGram("model.txt")

this loads an NGram model in the file "model.txt".

For Contibutors
============

### Setup.py file
1. Do not forget to set package list. All subfolders should be added to the package list.
```
    packages=['Classification', 'Classification.Model', 'Classification.Model.DecisionTree',
              'Classification.Model.Ensemble', 'Classification.Model.NeuralNetwork',
              'Classification.Model.NonParametric', 'Classification.Model.Parametric',
              'Classification.Filter', 'Classification.DataSet', 'Classification.Instance', 'Classification.Attribute',
              'Classification.Parameter', 'Classification.Experiment',
              'Classification.Performance', 'Classification.InstanceList', 'Classification.DistanceMetric',
              'Classification.StatisticalTest', 'Classification.FeatureSelection'],
```
2. Package name should be lowercase and only may include _ character.
```
    name='nlptoolkit_math',
```
3. Package data should be defined and must ibclude pyx, pxd, c and py files.
```
    package_data={'NGram': ['*.pxd', '*.pyx', '*.c', '*.py']},
```
4. Setup should include ext_modules with compiler directives.
```
    ext_modules=cythonize(["NGram/*.pyx"],
                          compiler_directives={'language_level': "3"}),
```

### Cython files
1. Define the class variables and class methods in the pxd file.
```
cdef class DiscreteDistribution(dict):

    cdef float __sum

    cpdef addItem(self, str item)
    cpdef removeItem(self, str item)
    cpdef addDistribution(self, DiscreteDistribution distribution)
```
2. For default values in class method declarations, use *.
```
    cpdef list constructIdiomLiterals(self, FsmMorphologicalAnalyzer fsm, MorphologicalParse morphologicalParse1,
                               MetamorphicParse metaParse1, MorphologicalParse morphologicalParse2,
                               MetamorphicParse metaParse2, MorphologicalParse morphologicalParse3 = *,
                               MetamorphicParse metaParse3 = *)
```
3. Define the class name as cdef, class methods as cpdef, and \_\_init\_\_ as def.
```
cdef class DiscreteDistribution(dict):

    def __init__(self, **kwargs):
        """
        A constructor of DiscreteDistribution class which calls its super class.
        """
        super().__init__(**kwargs)
        self.__sum = 0.0

    cpdef addItem(self, str item):
```
4. Do not forget to comment each function.
```
    cpdef addItem(self, str item):
        """
        The addItem method takes a String item as an input and if this map contains a mapping for the item it puts the
        item with given value + 1, else it puts item with value of 1.

        PARAMETERS
        ----------
        item : string
            String input.
        """
```
5. Function names should follow caml case.
```
    cpdef addItem(self, str item):
```
6. Local variables should follow snake case.
```
	det = 1.0
	copy_of_matrix = copy.deepcopy(self)
```
7. Variable types should be defined for function parameters, class variables.
```
    cpdef double getValue(self, int rowNo, int colNo):
```
8. Local variables should be defined with types.
```
    cpdef sortDefinitions(self):
        cdef int i, j
        cdef str tmp
```
9. For abstract methods, use ABC package and declare them with @abstractmethod.
```
    @abstractmethod
    def train(self, train_set: list[Tensor]):
        pass
```
10. For private methods, use __ as prefix in their names.
```
    cpdef list __linearRegressionOnCountsOfCounts(self, list countsOfCounts)
```
11. For private class variables, use __ as prefix in their names.
```
cdef class NGram:
    cdef int __N
    cdef double __lambda1, __lambda2
    cdef bint __interpolated
    cdef set __vocabulary
    cdef list __probability_of_unseen
```
12. Write \_\_repr\_\_ class methods as toString methods
13. Write getter and setter class methods.
```
    cpdef int getN(self)
    cpdef setN(self, int N)
```
14. If there are multiple constructors for a class, define them as constructor1, constructor2, ..., then from the original constructor call these methods.
```
cdef class NGram:

    cpdef constructor1(self, int N, list corpus):
    cpdef constructor2(self, str fileName):
    def __init__(self,
                 NorFileName,
                 corpus=None):
        if isinstance(NorFileName, int):
            self.constructor1(NorFileName, corpus)
        else:
            self.constructor2(NorFileName)
```
15. Extend test classes from unittest and use separate unit test methods.
```
class NGramTest(unittest.TestCase):

    def test_GetCountSimple(self):
```
16. For undefined types use object as type in the type declarations.
```
cdef class WordNet:

    cdef object __syn_set_list
    cdef object __literal_list
```
17. For boolean types use bint as type in the type declarations.
```
	cdef bint is_done
```
18. Enumerated types should be used when necessary as enum classes, and should be declared in py files.
```
class AttributeType(Enum):
    """
    Continuous Attribute
    """
    CONTINUOUS = auto()
    """
```
19. Resource files should be taken from pkg_recources package.
```
	fileName = pkg_resources.resource_filename(__name__, 'data/turkish_wordnet.xml')
```
