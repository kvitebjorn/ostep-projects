#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <errno.h>

/**
 * @brief Opens a file and gets its file status.
 *
 * @param filename The name of the file to open.
 * @param mode The mode in which to open the file.
 * @param sb A pointer to a struct stat to store the file status.
 * @return A pointer to the opened file, or NULL if an error occurred.
 */
FILE *open_file(const char *filename, const char *mode, struct stat *sb)
{
  FILE *file = fopen(filename, mode);
  if (file == NULL)
  {
    fprintf(stderr, "reverse: cannot open file '%s'\n", filename);
    return NULL;
  }

  if (lstat(filename, sb) == -1)
  {
    perror("reverse: error getting file info");
    fclose(file);
    return NULL;
  }

  return file;
}

/**
 * @file reverse.c
 * @brief This file contains the main function for a program
 *        that reverses the contents of a file.
 *
 * Usage: reverse <input> <output>
 *
 * Both <input> and <output> are optional.
 * If not provided, stdin and stdout will be used.
 *
 * @param argc The number of command-line arguments.
 * @param argv An array of command-line arguments.
 */
int main(int argc, char *argv[])
{
  if (argc > 3)
  {
    fprintf(stderr, "usage: reverse <input> <output>\n");
    exit(1);
  }

  struct stat sb_input, sb_output;
  FILE *input = stdin;
  FILE *output = stdout;

  if (argc > 1)
  {
    input = open_file(argv[1], "r", &sb_input);
    if (input == NULL)
    {
      exit(1);
    }
  }

  if (argc > 2)
  {
    output = open_file(argv[2], "w", &sb_output);
    if (output == NULL)
    {
      fclose(input);
      exit(1);
    }

    if (sb_input.st_ino == sb_output.st_ino)
    {
      fprintf(stderr, "reverse: input and output file must differ\n");
      fclose(input);
      fclose(output);
      exit(1);
    }
  }

  // Store the input stream line-by-line into a list of strings
  char **lines = NULL;
  size_t lines_size = 0;
  size_t lines_capacity = 0;
  char *line = NULL;
  size_t line_size = 0;

  while (getline(&line, &line_size, input) != -1)
  {
    // Only `realloc` when necessary by doubling the capacity as we approach it
    if (lines_size >= lines_capacity)
    {
      lines_capacity = lines_capacity == 0 ? 1 : lines_capacity * 2;
      char **temp = realloc(lines, lines_capacity * sizeof(char *));
      if (temp == NULL)
      {
        fprintf(stderr, "reverse: memory allocation error\n");
        for (size_t i = 0; i < lines_size; i++)
          free(lines[i]);
        free(lines);
        free(line);
        fclose(input);
        fclose(output);
        exit(1);
      }
      lines = temp;
    }
    lines[lines_size] = line; // Use getline's buffer directly
    line = NULL;              // Ensure getline allocates a new buffer next iteration
    line_size = 0;
    lines_size++;
  }
  free(line); // Free the last allocated but unused buffer

  // Write the list of strings to the output stream, in reverse
  for (int i = lines_size - 1; i >= 0; i--)
  {
    fprintf(output, "%s", lines[i]);
    free(lines[i]);
  }

  // Cleanup
  free(lines);
  fclose(input);
  if (fclose(output) == EOF)
  {
    perror("reverse: error closing output file");
    exit(1);
  }

  return 0;
}
