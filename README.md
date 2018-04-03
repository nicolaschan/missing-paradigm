# The Missing Paradigm
A program to search through possible programs for one that does what you want, drawing inspiration from [There Are Exactly Three Paradigms](http://wiki.c2.com/?ThereAreExactlyThreeParadigms).

## The Idea
*Goal*: Find a function that satisfies your constraints

*Idea*: Search through all possible programs until you find one that does what you want.

There are some obvious problems:
- How do you know the solution you find is good in the general case (i.e., not just a lookup table)?
  - We will assume the simplest solution (as in smallest syntax tree) is probably the more general one (although not always the case).
  - This can be further aided with additional (possibly randomized) tests.
- This is an exponential time problem. How do you make it efficient?
  - Using strong type checking, we can significantly limit our search space by only composing functions whose type signatures are compatible.
  - Constrain functions that we are allowed to search.
  - Manually tweak function priority to use the functions the programmer thinks will be the most useful.
  - Use path finding algorithms to find short paths where type-checking works out to serve as a starting point.

Additional ideas:
- Somehow "learn" patterns.
- Bootstrap up from simple functions to more complex ones. Can also inject human made building blocks.
- Make it help improve itself.
