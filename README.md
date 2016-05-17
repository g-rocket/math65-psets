# Math 65 problem sets
-----
Problems here are based off of `gsypset`, a custom documentclass I made.
It uses a similar structure to `hmcpset`, but looks (IMHO) nicer, and adds an additional feauture: subproblems.
By using the `subproblems` environment within a `problem` environment, `gsypset` allows you write the solution to each part
of a large multi-part problem immediately under the problem statement for that part of the problem.

###How to use this repository:
---
* PDF files are intended to be printed directly, and are what you get by passing the options `printing` and `blanks` to `gsypset`
  before typseting the corresponding TeX file.
* Personalized PDF files can be generated by filling out `\name` and similar at the top of the document,
  passing `printing` to `gsypset`, then typesetting and printing the resulting document.
* TeX files have a similar structure to `hmcpset`, where problems are given in `problem` environments and
  solutions go in `solution` environments.
  * For most problems, the `solution` environment goes immediately after the `problem` environment: e.g.
  
    ```LaTeX
    \begin{problem}[problem number]
      The problem statement
    \end{problem}
    \begin{solution}
      Your solution
    \end{solution}
    ```
  * For a problem with subproblems, the `solution` environment goes inside the `subproblems` environment immediately after the
    subproblem's problem statement (given with `\subproblem`): e.g.
    
    ```LaTeX
    \begin{problem}[problem number]
      The general part of the problem statement
      \begin{subproblems}
        \subproblem A problem statement for the first subproblem
        \begin{solution}
          The solution to the first subproblem
        \end{solution}
        \subproblem Another subproblem
        \begin{solution}
          The solution to the second subproblem
        \end{solution}
      \end{subproblem}
    \end{problem}
    ```
    * A problem with subproblems should *not* be followed by a `solution` environment, although nothing should break too badly if it is.
  * `problem` environments can take an optional argument for the problem number; if not given they will be numbered sequentially.
  * The pset starts with four commands to define information about it:
    
    ```LaTeX
    \name{Your Name}
    \class{Class name}{Optional section number}
    \assignment{Assignment name}
    \duedate{the due date}
    ```
    * The second set of curly brackets with the section number can be left off of `\class`
  * There's more stuff; hopefully it's clear by looking at the source; ask me if you have questions.