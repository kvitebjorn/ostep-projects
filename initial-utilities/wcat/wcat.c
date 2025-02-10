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
 *       Errors are printed on stdout, opposed to stderr, as specified in the requirements.
 *       The program will exit immediately after the first error, instead of continuing,
 *       as specified in the requirements.
 */
int main(int argc, char *argv[])
{
  if (argc < 2)
  {
    // Early exit if no files are provided
    return 0;
  }

  // Buffer to read the file content into
  char buf[BUFSIZ];

  // Loop through all the files
  for (int i = 1; i < argc; i++)
  {
    // Open the file in read-only mode
    FILE *f = fopen(argv[i], "r");
    if (f == NULL)
    {
      printf("wcat: cannot open file\n");
      exit(1);
    }

    // Get the file content line-by-line, and print it
    while (fgets(buf, sizeof(buf), f) != NULL)
    {
      printf("%s", buf);
    }

    // Cleanup
    if (feof(f))
    {
      // If we reached the end of the file, we can close it
      fclose(f);
    }
    else
    {
      // If we didn't reach the end of the file, there was an error
      printf("wcat: error reading file\n");
      exit(1);
    }
  }

  return 0;
}
