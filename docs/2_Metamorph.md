# Metamorph phase
In the following document, we describe all features of the third phase. This phase is associated with the milestone `Metamorph (2)`.

### Compare Headers
We provide a complete module to compare two given headers.
It compares two headers and determines :

- if one header encompasses the other : we return the most encompassing
- what are the differences between both headers
- all the information about the link between both headers

### JSON template
We provide a complete module to read a JSON template based on `Mustache`. Those templates describe how the header should be and the user configuration.

We differentiate two kind of template:

- the header JSON template
- the user JSON template

The header template is a JSON template describing the style and the shape of the header: 

- if there is an outline with `{{subject}}`
- where is placed this information in the header
- what is the max size of this information
- what is the alignment of the text 

The organization of the JSON is more detailed in the documentation file.

The user template is the template provided by the user to fill all fields corresponding in the header template, such as the author name. All of this will be described in the documentation file.

We interpret the eos template and create a header corresponding to the user information.

### Basic cmdline
We add new basic commands : 

- ```eos change [name]```: choose the template and add it to *.eos/auto.json*
- ```eos show```: display template chosen with eos
- ```eos list```: list templates installed on the computer
- ```eos update [-vc]```: put new template in files and in *.eos/*. 
  - `-v` option corresponds to the verbose mode and displays all changed files. 
  - `-c` option is the confirm mode and asks for modification on all files with `[y/n]` questions.

### Files
We put our functions in different files : 

- ```comparator.ml```:  module to handle comparison between two strings
- ```cmdline.ml```: add ```cmdline``` options
- ```choice.ml```: module to manage template installed on the computer
- ```writer.ml```: module to write text in a file
- ```reader.ml``` :improve file reading
- ```formatter.ml```: module to transform templates and *.eos/config.json* into a String (construct of header)
