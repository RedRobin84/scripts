#! /bin/bash

set -euo pipefail

exit_badly() {
	echo "$1"
	exit 1
}

is_number() {
    [[ "$1" =~ ^[-+]?[0-9]+(\.[0-9]+)?$ ]]
}

is_integer() {
	[[ "${1}" =~ ^[0-9]+$ ]]
}

in_range() {
	(( "${1}" >= 0 && "${1}" <= "${2}" ))
}

save_definition() {
	file_name="definitions.txt"
	echo "$1" >> "$file_name"
}

definition_input() {
	while true; do
		echo "Enter a definition: "
		read -a user_input
		arr_length="${#user_input[@]}"
		
		if [ "$arr_length" -ne 2 ]; then
			echo "The definition is incorrect!"
			continue
		fi

		definition="${user_input[0]}"
		constant="${user_input[1]}"

		re='^[a-zA-Z]+_to_[a-zA-Z]+$'
		if [[ ! "$definition" =~ $re ]]; then
			echo "The definition is incorrect!"
			continue
		fi

		if ! is_number "$constant"; then
			echo "The definition is incorrect!"
			continue
		fi

		save_definition "${definition} ${constant}"
		return 0
	done
}

file_exists() {
	[[ -s "${1}" ]]
}

convert_units() {
	if ! file_exists "definitions.txt"; then
		echo "Please add a definition first!"
		return 0
	fi
	echo "Type the line number to convert units or '0' to return"
	cat definitions.txt | nl -w1 -s'. '
	readarray -t definitions < definitions.txt
	while true; do
		read input
		if is_integer "${input}" && in_range "${input}" "${#definitions[@]}"; then
			if [ "${input}" == 0 ]; then
				return 0
			fi
			echo "Enter a value to convert: "
			while true; do
				read value
				if is_number "$value"; then
					break
				else
					echo "Enter a float or integer value!"
				fi
			done
			constant="$(echo "${definitions[$((input - 1))]}" | cut -d ' ' -f2)"
			result=$(echo "scale=2; $constant * $value" | bc -l)
			printf "Result: %s\n" "$result"
			return 0
		else
			echo "Enter a valid line number!"
		fi
	done
}

delete_definition() {
if file_exists "definitions.txt"; then
	echo "Type the line number to delete or '0' to return"
	cat definitions.txt | nl -w1 -s'. '
	readarray -t definitions < definitions.txt
	while true; do
		read input
		if is_integer "${input}" && in_range "${input}" "${#definitions[@]}"; then
			if [ "${input}" == 0 ]; then
				return 0
			fi
			sed -i "${input}d" definitions.txt
			return 0
		else
			echo "Enter a valid line number!"
		fi
	done
else
	echo "Please add a definition first!"
fi
}

echo "Welcome to the Simple converter!"
valid=true
while "$valid"; do
echo "Select an option
0. Type '0' or 'quit' to end program
1. Convert units
2. Add a definition
3. Delete a definition
"
    read value
    case "$value" in
	    1 )
		    convert_units ;;
	    2 )
		    definition_input ;;  
	    3 )
		    delete_definition ;;
	    quit | 0 )
		    echo "Goodbye!"
		    valid=false
		    ;;
	    *)
		    echo "Invalid option!";;
    esac
done
exit 0

