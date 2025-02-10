#include <stdio.h>
#include <stdlib.h>

/**
 * @brief Entry point for the wcat program.
 *
 * This function serves as the main entry point for the wcat utility, which
 * concatenates and displays the contents of files specified as command-line
 * arguments.
 *
 * @param argc The number of command-line arguments.
 * @param argv An array of strings representing the command-line arguments.
 *             The first argument (argv[0]) is the name of the program.
 *             Subsequent arguments (argv[1] to argv[argc-1]) are the names
 *             of the files to be concatenated and displayed.
 *
 * @return Returns 0 on successful execution, or a non-zero value if an error
 *         occurs.
 *
 *         1. Errors are printed on stdout, opposed to stderr.
 *         2. The program will exit immediately after the first error, instead of continuing.
 *
 *         1 & 2 are as specified in the requirements.
 */
int main(int argc, char *argv[])
{
  if (argc < 2)
  {
    // Early exit if no files are provided
    return 0;
  }

  char buf[BUFSIZ];

  for (int i = 1; i < argc; i++)
  {
    // Open the file for reading
    FILE *f = fopen(argv[i], "r");
    if (f == NULL)
    {
      printf("wcat: cannot open file\n");
      exit(1);
    }

    // Read and print the contents of the file line-by-line
    while (fgets(buf, sizeof(buf), f) != NULL)
    {
      fputs(buf, stdout);
    }

    // Check for read errors
    if (ferror(f))
    {
      printf("wcat: error reading file\n");
      fclose(f);
      exit(1);
    }

    fclose(f);
  }

  return 0;
}
