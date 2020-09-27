from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize(["NGram/*.pyx"],
                          compiler_directives={'language_level': "3"}),
    name='NlpToolkit-NGram-Cy',
    version='1.0.0',
    packages=['NGram'],
    package_data={'Hmm': ['*.pxd', '*.pyx', '*.c']},
    url='https://github.com/olcaytaner/NGram-Cy',
    license='',
    author='olcaytaner',
    author_email='olcaytaner@isikun.edu.tr',
    description='NGram library',
    install_requires=['NlpToolkit-DataStructure-Cy', 'NlpToolkit-Sampling-Cy']
)