#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * @brief Searches for a given term in the provided file and prints the containing line.
 *
 * This function takes a search term and a file pointer, and processes the file line-by-line
 * to find occurrences of the search term. If the search term is found in a line, the line is
 * subsequently printed to stdout.
 *
 * @param search_term The term to search for within the file.
 * @param f A pointer to the file to be searched.
 */
void do_the_thing(char *search_term, FILE *f)
{
  size_t size = 0;
  char *line = NULL;
  while (getline(&line, &size, f) != -1)
  {
    if (strstr(line, search_term) != NULL)
    {
      fputs(line, stdout);
    }
  }
  free(line);
}

/**
 * @brief Entry point for the wgrep utility.
 *
 * This function serves as the main entry point for the wgrep utility, which
 * is a simple implementation of the grep command. It takes command-line
 * arguments to search for a specified term in the given files or standard
 * input.
 *
 * @param argc The number of command-line arguments.
 * @param argv An array of command-line arguments, where argv[0] is the name
 *             of the program, argv[1] is the term to search for, and
 *             subsequent arguments are the files to search in.
 *
 * @return Returns 0 on successful execution, or a non-zero value if an error
 *         occurs.
 */
int main(int argc, char *argv[])
{
  if (argc < 2)
  {
    // Early exit if no search term is provided
    printf("wgrep: searchterm [file ...]\n");
    exit(1);
  }

  // If no files are provided, read from stdin
  if (argc == 2)
  {
    // Do the thing with stdin, in lieu of a file
    do_the_thing(argv[1], stdin);
    return 0;
  }

  // Otherwise read from the provided files
  for (int i = 2; i < argc; i++)
  {
    // Open the file for reading
    FILE *f = fopen(argv[i], "r");
    if (f == NULL)
    {
      printf("wgrep: cannot open file\n");
      exit(1);
    }

    // Do the thing with the file
    do_the_thing(argv[1], f);

    // Cleanup
    fclose(f);
  }

  return 0;
}
