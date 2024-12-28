find . -name "*.out.dSYM" -type d -print -exec rm -rf {} +
find . -name "*.out" -type f -delete -print
find . -name "*.fifo" -type f -delete -print
find . -name "*.o" -type f -delete -print
