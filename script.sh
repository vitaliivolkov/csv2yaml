#!/bin/bash

########################
# Read input file name #
########################
readArguments() {
 echo "Processing argument: ${1}"
  if [[ $1 ]]; then
    if [[ -f ${1} ]]; then
     inputFile="${1}"
     echo "Input file: $inputFile"
    else
     echo "Input file not found (received '${1}')"
    fi
  else
    echo "Missing the FILE value"
  fi
}

############################
# Setting Output file name #
############################
setOutputFile() {
  outputFile=`echo "${inputFile}" | sed s/'.csv'/'.yml'/g`
  echo "Output file: ${outputFile}"
}

writeToYAML() {
  yamlLine="${1}"

  echo "YAML line: ${yamlLine}"
  echo "${yamlLine}" >> "${outputFile}"
}

#######################
# Convert CSV to YAML #
#######################
convertFile() {
    echo "Starting convertion"

    read first_line < ${inputFile}
    a=0
    headings=`echo $first_line | awk -F, {'print NF'}`
    lines=`cat ${inputFile} | wc -l`
    while [ $a -lt $headings ]
    do
        head_array[$a]=$(echo $first_line | awk -v x=$(($a + 1)) -F"," '{print $x}')
        a=$(($a+1))
    done
    c=0
    while [ $c -lt $((lines+1)) ]
    do
        read each_line
        if [ $c -ne 0 ]; then
                d=0
                writeToYAML "-"
                while [ $d -lt $headings ]
                do
                        each_element=$(echo $each_line | awk -v y=$(($d + 1)) -F"," '{print $y}')
                        writeToYAML "${head_array[$d]}:${each_element}"
                        d=$(($d+1))
                done
        fi
        c=$(($c+1))
    done < ${inputFile}
}

##########
# Script #
##########
readArguments "$@"
setOutputFile
convertFile