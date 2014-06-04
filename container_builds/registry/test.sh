#!/bin/bash

./build.sh -c 
docker run -i -t -v /registry-storage:/tmp/ my-registry:run /bin/bash
