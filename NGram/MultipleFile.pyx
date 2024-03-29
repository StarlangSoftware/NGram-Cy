cdef class MultipleFile:

    def __init__(self, fileList: list):
        self.__file_name_list = fileList
        file = open(self.__file_name_list[0])
        self.__lines = file.readlines()
        file.close()
        self.__line_index = 0
        self.__index = 0

    cpdef str readLine(self):
        cdef str line
        if self.__line_index == len(self.__lines):
            self.__index = self.__index + 1
            file = open(self.__file_name_list[self.__index])
            self.__lines = file.readlines()
            file.close()
            self.__line_index = 0
        line = self.__lines[self.__line_index]
        self.__line_index = self.__line_index + 1
        return line
