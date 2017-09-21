# python2perl

## _Introduction_

Our task is to write a Python compiler. Generally compilers take a high level language as input and output assembler, which can then can be directly executed. Your compiler will take a Python script as input and output a Perl script. Such a translation is useful because programmers sometimes need to convert Python scripts to Perl.

Possible reasons for this include integration of existing Python code into a Perl program and shifting a complete Python program to a new platform which requires Perl.
Our task is to automate this conversion. We will be writing a Perl program which takes as input a Python script and outputs an equivalent Perl program.

The translation of some Python code to Perl is straightforward. The translation of other Python code is difficult or infeasible. So your program will not be able to translate all Python code to Perl. But a tool that performs only a partial translation of Python to Perl could still be very useful.

We assume the Perl code output  will be subsequently read and modified by humans. In other words, the output should be a readable Perl code. For example, you should aim to preserve variable names and comments, and to output properly indented Perl code.
