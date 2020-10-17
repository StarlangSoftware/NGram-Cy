cdef class MultipleFile:

    cdef int index
    cdef list fileNameList
    cdef list lines
    cdef int lineIndex

    cpdef str readLine(self)
