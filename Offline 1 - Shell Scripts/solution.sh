#!/bin/bash

not_in_ignore_list(){

	# checks if the extension is in the ignore list
	# param: $1 = extension
	
	for x in ${to_ignore[@]}
	do
		if [ $1 = $x ]; then
			return 1
		fi
	done
	return 0
}

collect_files(){


	while IFS= read -r file;
	do	 
		filename="`echo "$file" | rev | cut -d "/" -f 1 | rev`"
		ext="`echo "$filename" | cut -d "." -f 2`"
		
		
		if [ "$ext" = "$filename" ]; then
			ext="others"
		fi
		
		
		if not_in_ignore_list "$ext";
		then
			# 6. Gather all the required files in a separate output directory
			save_dir="$2$ext"
			mkdir -p "$save_dir/"
			
			# Check if file already exists in output dir
			if [[ -z $(find "$save_dir" -name "$filename" -mmin -5) ]];
			then
				
				cp "$file" "$save_dir/$filename"
				((count[$ext]++))
					
				# 7. add the relative paths(path from the root working directory) of all the files of that type
				echo "$file" >> $save_dir/desc_$ext.txt	
			fi
			
		else
			((count[ignored]++))

		fi
		
				
	done <<< $(find . -type f)


}

# 1.Take the working directory name (optional) and input file name as a command-line argument

if (($# < 1)); then
	
	# 3. If the user does not provide any input file name, show him a usage message (i.e. how to use this script of yours)
	echo "Enter working directory (optional) and input file name"
	exit
	
elif (($# == 1)); then
	# 2. If the user does not provide any working directory name, consider your script is lying in the root working directory
	working_dir="."
	input_file="$1"
else
	working_dir="$1"
	input_file="$2"
fi

echo "working dir: $working_dir , input file: $input_file"

# 4. Read the types of files to ignore from the input file 
# (if the input file does not exist, prompt the user to give a valid input file name)

if [ -f "$input_file" ]; then
	
	i=0
	while IFS=$' \r\n' read -r line || [ -n "$line" ]; 
	do
		((i++))
		to_ignore[$i]="$line"
	done < "$input_file"
	
	echo "total ignore = ${#to_ignore[@]}"
	echo "File extensions to ignore = ${to_ignore[@]}"
		
else
	echo "Enter a valid file name"
	exit
fi


# count will contain the number of files for each type
declare -A count

cd "$working_dir"
output_dir="../output_dir/"
mkdir -p "$output_dir"

echo "collecting files..."

collect_files "$working_dir" "$output_dir"

# 8. Create a .csv file containing two columns, namely file type, and number of files

output_csv="../output.csv"
echo "file_type, no_of_files" > "$output_csv"

for key in "${!count[@]}"; do
	echo "$key, ${count[$key]}" >> "$output_csv"
done

echo "Done!"

