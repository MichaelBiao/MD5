# MD5
implementation based on the solutions on this page without needing any external libraries
#Useage
import the MD5 file into your project and take the func 'toHexString()'

let tempString = "abc"
print(toHexString(bytes: md5(message: Array(tempString.utf8))))


