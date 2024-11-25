#--- Quarto ---#
USER root

RUN apt-get install --no-install-recommends -y \
    #texlive \
    #pandoc \
    #pandoc-citeproc \
    texlive-fonts-recommended \
    lmodern \
    curl \
    gdebi-core

# Use the target platform to specify the Quarto version
RUN if [[ "$TARGETPLATFORM" = */arm64 ]]; then \
    curl -LO https://quarto.org/download/latest/quarto-linux-arm64.deb && \
        gdebi --non-interactive quarto-linux-arm64.deb && \
        rm quarto-linux-arm64.deb; \
  else \
    curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb && \
        gdebi --non-interactive quarto-linux-amd64.deb && \
        rm quarto-linux-amd64.deb; \
  fi

# Tidy up
RUN rm -rf /var/lib/apt/lists/*
