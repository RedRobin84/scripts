#! /bin/bash
# Gets english explanation of an english word / phrase and translates that explanation to czech
# @param: english word / phrase
# @return: czech explanation

param1=${1}

trans :cs "$(bash ./dict.sh ${param1})"

