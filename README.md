es-membench
===========

es-membench is a simple wrapper script around Rally to run memory-sizing benchmarks.

Installation
------------

```
# Install Rally - do this in the directory *next* to your Elasticseach checkout. This allows you 
# to make local changes to Elasticsearch and directly benchmark them.
git clone https://github.com/elastic/rally.git
# make the 'rally' alias callable system-wide
ln -s $(pwd)/rally/rally /usr/local/bin/rally
# Run the initial Rally configuration routine
rally configure

# Install es-membench
git clone https://github.com/elastic/rally.git
```

Usage
-----

Run a benchmark with:

```
./benchmark.sh
```

Available command line parameters:

* `--heap="HEAP_SIZE"`: heap size for Elasticsearch. The default is `1g`.
* `--clients="CLIENTS"`: Number of indexing clients. The default is `8`.
* `--skip-build`: Allows to skip the build. The default is to build Elasticsearch every time.

You can adapt the Elasticsearch configuration in `es-config/cars/config`.

In case of an `OutOfMemoryError`, heap dumps are stored in `~/.rally/benchmarks/races/RACE_TIMESTAMP/rally-node-0/heapdump`.

License
-------
 
This software is licensed under the Apache License, version 2 ("ALv2"), quoted below.

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License. You may obtain a copy of
the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations under
the License.