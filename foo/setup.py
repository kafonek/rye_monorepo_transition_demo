from setuptools import setup, find_packages

setup(
    name="foo",
    version="0.1",
    packages=find_packages(),
    install_requires=["flask<3"],
)
