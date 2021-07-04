# Crow phase
In the following document, we will describe all features of the fourth phase. This phase is associated with the milestone `Crow (3)`.

### Compare older and current header
In this phase, we link the two previous phases.

We set up a system to recognize the old header, and we compare it with the current header (generated with the JSON template).
We update the header by detecting the old header and changing it if needed.

### .eos directory
We put the configuration into a ```.eos``` directory with the following items: 

- auto.json: file used by eos to manage headers
- config.json: file where the user puts his configuration
- template: folder containing header's templates (each characterized by their name)

### Command line
We finish the command line system for eos. The name of the command will be `eos`.
Moreover, a manual will be implemented to understand each command : please refer to this manual for each command.
We add new basic commands to previous ones : 

- ```eos init [template]```: initialise a *.eos/auto.json*, a *.eos/config.json*  in the current directory (if they are not already present) and use the default configuration provided by the template creator
- ```eos change [name]```: choose the template and add it to *.eos/auto.json*
- ```eos list```: list templates installed on the computer
- ```eos status [-d]```: display files that needed to be updated. 
 - `-d` option displays differences between headers.
- ```eos check```: check if the *.eos/config.json* is correct with the template name

### Files
We put our functions in this file:

- ```choice.ml```: module to manage template installed on the computer
- ```updater.ml```: module to update file content.
