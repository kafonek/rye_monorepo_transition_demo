from setuptools import setup, find_packages
from pybind11.setup_helpers import Pybind11Extension, build_ext

ext_modules = [Pybind11Extension("foo", [])]
setup(
    name="foo",
    version="0.1",
    packages=find_packages(),
    install_requires=["flask<3"],
)
