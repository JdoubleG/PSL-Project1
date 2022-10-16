### Basic Time Elapsed Script
library(NCmisc) # note that this is not necessary to use proc.time() but rather wait()

start = proc.time()
wait(60)
end = proc.time()
elapsed = end - start
print(elapsed) # elapsed should be 60 (or very close)
