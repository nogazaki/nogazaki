# Problem Set 4A
# Name: <your name here>
# Collaborators:
# Time Spent: x:xx

import string


def get_permutations(sequence):
    """
    Enumerate all permutations of a given string

    sequence (string): an arbitrary string to permute. Assume that it is a
    non-empty string.

    You MUST use recursion for this part. Non-recursive solutions will not be
    accepted.

    Returns: a list of all permutations of sequence

    Example:
    >>> get_permutations('abc')
    ['abc', 'acb', 'bac', 'bca', 'cab', 'cba']

    Note: depending on your implementation, you may return the permutations in
    a different order than what is listed here.
    """

    if len(sequence) == 1:
        return list(sequence)

    result = []
    for sub in get_permutations(sequence[1:]):
        for i in range(len(sequence)):
            result.append(sub[:i] + sequence[0] + sub[i:])

    return result


if __name__ == "__main__":
    #    # EXAMPLE
    #    example_input = 'abc'
    #    print('Input:', example_input)
    #    print('Expected Output:', ['abc', 'acb', 'bac', 'bca', 'cab', 'cba'])
    #    print('Actual Output:', get_permutations(example_input))

    #    # Put three example test cases here (for your sanity, limit your inputs
    #    to be three characters or fewer as you will have n! permutations for a
    #    sequence of length n)

    inputs = ["a", "ab", "abc"]
    outputs = [["a"], ["ab", "ba"], ["abc", "acb", "bac", "bca", "cab", "cba"]]

    for input, output in zip(inputs, outputs):
        print("Input:", input)
        result = get_permutations(input)
        print("Result is", result, "does" if set(result) == set(output) else "doesn't", "match the expected")
