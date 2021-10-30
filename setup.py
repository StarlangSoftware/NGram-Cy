from setuptools import setup

from pathlib import Path
this_directory = Path(__file__).parent
long_description = (this_directory / "README.md").read_text()
from Cython.Build import cythonize

setup(
    ext_modules=cythonize(["NGram/*.pyx"],
                          compiler_directives={'language_level': "3"}),
    name='NlpToolkit-NGram-Cy',
    version='1.0.7',
    packages=['NGram'],
    package_data={'NGram': ['*.pxd', '*.pyx', '*.c', '*.py']},
    url='https://github.com/StarlangSoftware/NGram-Cy',
    license='',
    author='olcaytaner',
    author_email='olcay.yildiz@ozyegin.edu.tr',
    description='NGram library',
    install_requires=['NlpToolkit-DataStructure-Cy', 'NlpToolkit-Sampling-Cy'],
    long_description=long_description,
    long_description_content_type='text/markdown'
)
