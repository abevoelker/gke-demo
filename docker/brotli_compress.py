import fnmatch
import magic
import os
import stat
import sys
import subprocess

MIME_WHITELIST = [
  'application/atom+xml',
  'application/javascript',
  'application/json',
  'application/ld+json',
  'application/manifest+json',
  'application/rss+xml',
  'application/vnd.geo+json',
  'application/vnd.ms-fontobject',
  'application/x-font-ttf',
  'application/x-web-app-manifest+json',
  'application/xhtml+xml',
  'application/xml',
  'font/opentype',
  'image/bmp',
  'image/svg+xml',
  'image/x-icon',
  'text/cache-manifest',
  'text/css',
  'text/plain',
  'text/vcard',
  'text/vnd.rim.location.xloc',
  'text/vtt',
  'text/x-component',
  'text/x-cross-domain-policy',
]

if len(sys.argv) > 1:
    compressdir = sys.argv[1]
else:
    compressdir = '.'

print('Brotli compressing files in %s...' % compressdir)

matches = []
for root, dirnames, basenames in os.walk(compressdir):
    for basename in basenames:
        # skip files that have already been gzipped
        if basename.endswith('.gz'):
            continue
        full_path = os.path.join(root, basename)
        mime_type = magic.from_file(full_path, mime=True)
        stinfo = os.stat(full_path)
        if mime_type in MIME_WHITELIST or stinfo.st_size == 0:
            compress_path = "%s.br" % full_path
            print("compressing %s" % compress_path)
            subprocess.call(["brotli", "--input", full_path, "--output", compress_path])
            # set mtime and atime to uncompressed file's values
            os.utime(compress_path,(stinfo.st_atime, stinfo.st_mtime))
            # set file permissions to uncompressed file's values
            uncompressed_perms = stat.S_IMODE(os.lstat(full_path).st_mode)
            os.chmod(compress_path, uncompressed_perms)
