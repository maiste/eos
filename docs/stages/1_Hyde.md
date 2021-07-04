# Hyde phase
In the following document, we will describe all features of the second phase. This phase is associated with the milestone `Hyde (1)`.

### Basic command line
We provide a command line user interface to use eos. We add basic commands : 

- ```eos --help```: display help
- ```eos files```: display files tracked by eos.

### Read basic configuration
We define a **.eos/config.json** file where the configuration is stored for the project. During the Hyde phase, we only use following fields in the JSON file:

```json
  "name" : "eos",
  "files": [
      "ex*.json",
      "tests/"
    ]
```
We will describe it in the future documentation. It will be written with **Sphinx**.
### Files
We put our functions in different files : 

- ```reader.ml```: module to read files in different formats
- ```conf.ml```: module to read and update configuration
- ```cmdline.ml```: module in charge of the command line user interface
- ```eos.ml```: main module linking all modules
