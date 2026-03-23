#include <stdio.h>
#include <stdlib.h>

/**
 * @brief Entry point for the wzip program.
 *
 * This function serves as the main entry point for the wzip program, which is
 * designed to compress files using a simple run-length encoding algorithm.
 *
 * If multiple files are provided, the output will be the concatenation of the
 * compressed contents of each file. That is, there will be one output file.
 *
 * @param argc The number of command-line arguments.
 * @param argv An array of strings representing the command-line arguments.
 *             The first argument (argv[0]) is the name of the program.
 *             Subsequent arguments are the names of the files to be compressed.
 *
 * @return Returns 0 on successful execution, or a non-zero value if an error occurs.
 */
int main(int argc, char *argv[])
{
  if (argc < 2)
  {
    printf("wzip: file1 [file2 ...]\n");
    exit(1);
  }

  FILE *fp;

  char c;
  char prev = '\0';
  int count = 0;

  for (int i = 1; i < argc; i++)
  {
    fp = fopen(argv[i], "r");
    if (fp == NULL)
    {
      printf("wzip: cannot open file\n");
      exit(1);
    }

    // Run-length encoding
    // Look behind to see if the current character is the same as the previous
    // If it is, increment the count
    // If it isn't, write the count and character to stdout, and reset
    while ((c = fgetc(fp)) != EOF)
    {
      if (c == prev)
      {
        count++;
        continue;
      }

      // Write the count and character to stdout (for redirection)
      // 5 bytes:
      //   4 bytes for the integer, in binary
      //   1 byte for the ASCII character
      if (count > 0)
      {
        fwrite(&count, sizeof(int), 1, stdout);
        fwrite(&prev, sizeof(char), 1, stdout);
      }

      // Set up for the next character
      count = 1;
      prev = c;
    }

    // Cleanup
    fclose(fp);
  }

  // Write the last character
  if (count > 0)
  {
    fwrite(&count, sizeof(int), 1, stdout);
    fwrite(&prev, sizeof(char), 1, stdout);
  }

  return 0;
}
