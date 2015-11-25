#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#include <nss.h>

int main()
{
  int ret = 0;
  SECStatus s;
  char *t = strdup("/tmp/nss.XXXXXX");
  char *tmpdir = mkdtemp(t);

  if (tmpdir == NULL)
    fprintf(stderr, "Failed to create temp directory: %s", strerror(errno));
 
  s = NSS_InitReadWrite(tmpdir);
  if (s != SECSuccess)
    ret = 2;
 
  NSS_Shutdown();
  free(t);

  return ret;
}
