#!/bin/sh
logDir='log/'
srcName='statistics.log'
trgtName='val.log'
./bin/parse ${logDir}${srcName} > ${logDir}${trgtName}
grep 'Padding' ${logDir}${srcName} >> ${logDir}${trgtName}
grep 'Overflow' ${logDir}${srcName} >> ${logDir}${trgtName}
grep 'time' ${logDir}${srcName} >> ${logDir}${trgtName}
grep 'Comparison' ${logDir}${srcName} >> ${logDir}${trgtName}
echo "Content of ${logDir}${trgtName}-------------"
cat ${logDir}${trgtName}
