# BigBang phase

In the following document, we will describe all features of the first phase. This phase is associated with the milestone `BigBang (0)`.

## Documentation

We provide a complete documentation for what we need to implement in eos and the purpose of all milestones.
Moreover, we implement a code of conducts, named `CONTRIBUTING.md`, which explains how to participate in the project.

Firstly, what is the main purpose of `eos` : to provide an autonomous header manager for all programmer's files (the first four milestones).
After this basic implementation, we will provide some other tools like an online template repository.

## Skeleton

It is the project structure.

### Test

We set up an entire testing system with `OUnit`. We locate it in a test folder.
For each feature, we provide tests to be ensured of the right behaviour.

### Compilation and execution

We set up an entire system for compiling and testing functionalities.
In order to do so, we establish a Travis on the GitHub project.
Moreover, to test the program on Travis, we use a Debian image over docker.

### Files 
We simply add all needed files for a basic project folder.