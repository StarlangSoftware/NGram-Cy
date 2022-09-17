cdef class MultipleFile:

    cdef int __index
    cdef list __file_name_list
    cdef list __lines
    cdef int __line_index

    cpdef str readLine(self)
