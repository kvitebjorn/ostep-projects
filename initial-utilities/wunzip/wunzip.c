#include <stdio.h>
#include <stdlib.h>

/**
 * @brief Entry point for the wunzip utility.
 *
 * This function serves as the main entry point for the wunzip program, which
 * is designed to decompress files that were compressed using wzip.
 *
 * The compression scheme is such:
 *  - The file is read in chunks of 5 bytes
 *    - The first 4 bytes represent an integer, which is the count of the character
 *    - The last byte is the character to be repeated
 *
 * @param argc The number of command-line arguments.
 * @param argv An array of command-line arguments.
 * @return int Returns 0 on successful execution, or a non-zero error code on failure.
 */
int main(int argc, char *argv[])
{
  if (argc < 2)
  {
    printf("wunzip: file1 [file2 ...]\n");
    exit(1);
  }

  FILE *fp;

  char c;
  int count;

  // For each file, read the count and character,
  //   and print the character `count` times.
  for (int i = 1; i < argc; i++)
  {
    fp = fopen(argv[i], "r");
    if (fp == NULL)
    {
      printf("wunzip: cannot open file\n");
      exit(1);
    }

    while (fread(&count, sizeof(int), 1, fp) == 1)
    {
      fread(&c, sizeof(char), 1, fp);
      for (int j = 0; j < count; j++)
      {
        // All output will be concatenated to stdout as a single stream of text.
        printf("%c", c);
      }
    }

    fclose(fp);
  }

  return 0;
}
