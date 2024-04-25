from distutils.core import setup
from glob import glob

setup(
    name='visual_aids',
    version='2.0',
    description='Visual aids for Hands-On Data Analysis with Pandas.',
    author='Stefanie Molin',
    author_email='24376333+stefmolin@users.noreply.github.com',
    license='MIT',
    url='https://github.com/stefmolin/Hands-On-Data-Analysis-with-Pandas-2nd-edition',
    packages=['visual_aids'],
    package_data={'data': glob('data/*')},
    include_package_data=True
)
