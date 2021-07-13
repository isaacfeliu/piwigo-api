# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

0.5.9 - 2021-07-13 
- Update version to fix github actions

0.5.8 - 2021-07-13 
- Update dependencies address CVE-2021-32740

0.5.7 - 2020-03-01
- Fixed open-ended dependency on codecov

0.5.6 - 2020-03-01
- Update dependencies to address security vulnerability

0.5.5 - 2019-11-26
- Fix another encoding issue when synchronizing folder with accented characters.

0.5.4 - 2019-11-26
- Fix crash in sniff_attributes when the image dosn't contain a valid EXIF data
- Fix parent albums when syncronizing a folder-tree of albums into Piwigo

0.5.3 - 2019-11-25
- Fixed to coverage reports
- Only generate coverage reports during CI build
- codecov.io seems to be ignoring some test files in the coverage report
- Use EXIF data to pull out the original image date when uploading to Piwigo

0.5.1 - 2019-11-23
- Fixed minor bug in image.lookup

0.5.0 - 2019-11-23
- Added a directory of example scripts
- Added a folder-album syncronization methods

0.4.0 - 2019-11-20
- Add methods to check for the existance of a specific image and to upload images

0.3.1 - 2019-11-20
- Add a codecov.yaml for coverage reports

0.3.0 - 2019-11-17
- Added a documentation URL pointing to rubydoc.info
- Added build badges
- Added ability to page though the images in an album

0.2.0 - 2019-11-17
- Refactored the Session to make it easier to use
- Support adding/deleting & listing albums

0.1.1 - 2019-11-16 
- Initial Version, supports login/logout against a piwigo server
- Fixing spec consistency issues
