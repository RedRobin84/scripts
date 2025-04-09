#! /bin/bash
# Calls Google dictionary on a word / phrase.
# @param: english word / phrase
# @return: English explanation

url_to_call="https://api.dictionaryapi.dev/api/v2/entries/en/${1}"

curl -s ${url_to_call} | jq -r '.[0].meanings[0].definitions[0].definition'

