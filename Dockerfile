FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev     libboost-all-dev libssl-dev
RUN  wget https://github.com/Kitware/CMake/releases/download/v3.20.1/cmake-3.20.1.tar.gz
RUN tar xvfz cmake-3.20.1.tar.gz
WORKDIR /cmake-3.20.1
RUN ./bootstrap
RUN make
RUN make install
WORKDIR /
RUN  git clone https://github.com/adobe/svg-native-viewer
WORKDIR /svg-native-viewer/svgnative
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ .
RUN make
RUN cp ./example/testC/testC /adobe_svg_fuzz
RUN mkdir /svgCorpus
RUN wget https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/AJ_Digital_Camera.svg
RUN wget https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/Steps.svg
RUN wget https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/acid.svg
RUN wget https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/aa.svg
RUN wget https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/adobe.svg
RUN wget https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/anim1.svg
RUN wget https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/atom.svg
RUN mv *.svg /svgCorpus

ENTRYPOINT  ["afl-fuzz", "-i", "/svgCorpus", "-o", "/svgOut"]
CMD ["/adobe_svg_fuzz", "@@"]
