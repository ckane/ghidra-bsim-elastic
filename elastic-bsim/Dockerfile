FROM elasticsearch:8.8.1

USER 0:0

RUN curl -LJ -o ghidra.zip https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.0_build/ghidra_11.0_PUBLIC_20231222.zip
RUN unzip ghidra.zip ghidra_11.0_PUBLIC/Extensions/Ghidra/ghidra_11.0_PUBLIC_20231222_BSimElasticPlugin.zip
RUN unzip ghidra_11.0_PUBLIC/Extensions/Ghidra/ghidra_11.0_PUBLIC_20231222_BSimElasticPlugin.zip

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install "file://$(pwd)/BSimElasticPlugin/data/lsh.zip"

RUN rm -rf ./ghidra_11.0_PUBLIC ./BSimElasticPlugin

USER 1000:0
