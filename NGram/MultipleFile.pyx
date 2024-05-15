cdef class MultipleFile:

    def __init__(self, fileList: list):
        """
        Constructor for MultipleFile class. Initializes the buffer reader with the first input file
        from the fileNameList. MultipleFile supports simple multipart file system, where a text file is divided
        into multiple files.
        :param fileList: A list of files.
        """
        self.__file_name_list = fileList
        file = open(self.__file_name_list[0])
        self.__lines = file.readlines()
        file.close()
        self.__line_index = 0
        self.__index = 0

    cpdef str readLine(self):
        """
        Reads a single line from the current file. If the end of file is reached for the current file,
        next file is opened and a single line from that file is read. If all files are read, the method
        returns null.
        :return: Read line from the current file.
        """
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
