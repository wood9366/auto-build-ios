# Auto Build IOS
Build scripts help to generate ipa with command line on mac

## Environment & Requirements

* Computer & OS: Mac mini(Late 2012), Yosemite 10.10.5
* Version Control: Git 2.5.0
* Unity Version: 5.1.1f1 with Personal license
* XCode Version: 7.2(7C68)

* Ruby 2.0.0p481 with xcodeproj 0.28.2 

## BuildIOS.sh
Build specific unity project and generate ipa to output folder.

Arguments:
- Project Path: Unity project path
- XCode Path: Directory of xcode proejct which will be generated from unity
- Output Path: Directory ipa file generated in
- Provision Profile Path: Apple development provision profile for app
- [Optional] Product Name: App product name. If not set, use default value set inside script.
- [OPtional] App Id: Apple App Id. If not set, use default value set inside script.



## JenkinsBuildIOS.sh
Setup build steps for Jenkins build job.

Steps:
* Build ipa file, put it into Jenkins workspace build folder.
* Copy ipa file to resources sharing server.

Rules:
* ipa name rules: ${JENKINS\_JOBNAME}\_${JENKINS\_BUILD\_NUMBER}\_${BUILD\_DATE}\_${GITVERSION}.ipa
* build date rules: YearMonthDay_HourMinuteSecond

## setup_xcodeproject.rb
Adjust build settings of generated xcode proejct by unity. This script should be change depends on unity version.

* Disable bitcode.
* Set code sign resolurce rule path. Ignore build issues.
