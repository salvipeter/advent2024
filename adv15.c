#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

bool move(char **map, int x, int y, int dx, int dy, bool dry_run) {
  bool ok;
  switch (map[y][x]) {
  case '[':
    x++;                        /* reduce to the ']' case */
  case ']':
    if (dy == 0) {
      if ((ok = move(map, dx < 0 ? x - 2 : x + 1, y, dx, dy, dry_run)) && !dry_run) {
        map[y][x] = '.';
        if (dx < 0)
          x -= 2;
        map[y][x]   = '[';
        map[y][x+1] = ']';
      }
      return ok;
    } else {
      if ((ok = move(map, x, y + dy, dx, dy, dry_run) &&
                move(map, x - 1, y + dy, dx, dy, dry_run)) &&
           !dry_run) {
        map[y][x-1]    = '.';
        map[y][x]      = '.';
        map[y+dy][x-1] = '[';
        map[y+dy][x]   = ']';
      }
      return ok;
    }
  case '#':
    return false;
  case '.':
    return true;
  }
}

/* 1st argument: 1 or 2; 2nd argument: msecs to wait (50000 by default) */
int main(int argc, char **argv) {
  int height = sizeof(map) / sizeof(char) / width - 1;
  int n = sizeof(moves) / sizeof(char) - 1;

  if (argc > 1) printf("[2J[?25l"); /* clear the screen and hide the cursor */
  int msecs = argc > 2 ? atoi(argv[2]) : 50000;

  /* Copy and double the map for Part 2 */
  char **dbl = (char **)malloc(height * sizeof(char *));
  for (int i = 0; i < height; ++i) {
    dbl[i] = (char *)malloc((width * 2 + 1) * sizeof(char));
    for (int j = 0; j < width; ++j)
      switch (map[i][j]) {
      case '#': dbl[i][2*j] = '#'; dbl[i][2*j+1] = '#'; break;
      case 'O': dbl[i][2*j] = '['; dbl[i][2*j+1] = ']'; break;
      case '.': dbl[i][2*j] = '.'; dbl[i][2*j+1] = '.'; break;
      case '@': dbl[i][2*j] = '@'; dbl[i][2*j+1] = '.'; break;
      }
    dbl[i][2*width] = '\0';
  }

  /* Find starting position */
  int startx = -1, starty = -1;
  for (int i = 0; startx < 0 && i < height; ++i)
    for (int j = 0; j < width; ++j)
      if (map[i][j] == '@') {
        startx = j;
        starty = i;
        break;
      }

  /* Robot movement */
  int x = startx, y = starty;
  for (int i = 0; i < n; ++i) {
    int dx, dy;
    switch (moves[i]) {
    case '<': dx = -1; dy =  0; break;
    case '>': dx =  1; dy =  0; break;
    case '^': dx =  0; dy = -1; break;
    case 'v': dx =  0; dy =  1; break;
    }
    int x1 = x + dx, y1 = y + dy;
    while (map[y1][x1] == 'O') {
      x1 += dx; y1 += dy;
    }
    if (map[y1][x1] == '.') {
      map[y1][x1] = map[y+dy][x+dx];
      map[y+dy][x+dx] = '@';
      map[y][x] = '.';
      x += dx; y += dy;
    }
    /* Display */
    if (argc > 1 && argv[1][0] == '1') {
      printf("[0;0H");        /* move cursor to the top-left */
      for (int i = 0; i < height; ++i)
        printf("%s\n", map[i]);
      usleep(msecs);
    }
  }

  /* GPS calculation */
  int gps = 0;
  for (int i = 0; i < height; ++i)
    for (int j = 0; j < width; ++j)
      if (map[i][j] == 'O')
        gps += i * 100 + j;
  printf("%d\n", gps);

  /* Part 2 */

  /* Robot movement */
  x = startx * 2; y = starty;
  for (int i = 0; i < n; ++i) {
    int dx, dy;
    switch (moves[i]) {
    case '<': dx = -1; dy =  0; break;
    case '>': dx =  1; dy =  0; break;
    case '^': dx =  0; dy = -1; break;
    case 'v': dx =  0; dy =  1; break;
    }
    int x1 = x + dx, y1 = y + dy;
    switch (dbl[y1][x1]) {
    case '[':
    case ']':
      if (move(dbl, x1, y1, dx, dy, true)) { /* first do a dry run */
        move(dbl, x1, y1, dx, dy, false);
        dbl[y1][x1] = '@';
        dbl[y][x] = '.';
        x = x1; y = y1;
      }
      break;
    case '.':
      dbl[y1][x1] = '@';
      dbl[y][x] = '.';
      x = x1; y = y1;
      break;
    case 'O':
      break;
    }
    /* Display */
    if (argc > 1 && argv[1][0] == '2') {
      printf("[0;0H");        /* move cursor to the top-left */
      for (int i = 0; i < height; ++i)
        printf("%s\n", dbl[i]);
      usleep(msecs);
    }
  }

  /* GPS calculation */
  gps = 0;
  for (int i = 0; i < height; ++i)
    for (int j = 0; j < 2 * width; ++j)
      if (dbl[i][j] == '[')
        gps += i * 100 + j;
  printf("%d\n", gps);

  if (argc > 1) printf("[?25h"); /* show the cursor */

  /* Free the doubled map */
  for (int i = 0; i < height; ++i)
    free(dbl[i]);
  free(dbl);
}
