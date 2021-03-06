/**
 * orphan-reaper — Place subreapers in your process tree to keep it structured
 * Copyright © 2014  Mattias Andrée (maandree@member.fsf.org)
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <stddef.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>
#include <stdio.h>


int main(int argc, char** argv)
{
  pid_t pid;
  (void) argc;
  
  for (;;)
    if (pid = wait(NULL), pid == -1)
      {
	if (errno == ECHILD)
	  return 0;
	else if (errno != EINTR)
	  return perror(*argv), 2;
      }
}

