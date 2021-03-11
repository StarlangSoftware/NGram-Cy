from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize(["NGram/*.pyx"],
                          compiler_directives={'language_level': "3"}),
    name='NlpToolkit-NGram-Cy',
    version='1.0.6',
    packages=['NGram'],
    package_data={'NGram': ['*.pxd', '*.pyx', '*.c', '*.py']},
    url='https://github.com/StarlangSoftware/NGram-Cy',
    license='',
    author='olcaytaner',
    author_email='olcay.yildiz@ozyegin.edu.tr',
    description='NGram library',
    install_requires=['NlpToolkit-DataStructure-Cy', 'NlpToolkit-Sampling-Cy']
)
