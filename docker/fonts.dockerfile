#####################
# Long term we probably want to install our own tinytex:
#   See: https://yihui.org/tinytex/#installation
#   And: https://github.com/rstudio/tinytex
#   And: https://github.com/rstudio/tinytex/issues/426
#   Since currently quarto install tinytex isn't supported.
#
#####################
# To use web fonts: https://fonts.google.com/knowledge/using_type/using_web_fonts
# To load web fonts: https://fonts.google.com/knowledge/using_type/using_web_fonts_from_a_font_delivery_service
#
#####################
# To get FontAwesome5 PDF support:
# 1. Unpack the fontawesome.tar.gz folder anywhere you need PDFs (e.g the practicals directory).
#    tar -xvf ./fontsrc/fontawesome.tar.gz -C ./work/practicals/
# 2. Adding the following to your _metadata.yml file (directory level):
# format:
#   pdf:
#     include-in-header:
#       text: |
#         \usepackage[fixed]{fontawesome5}
#
#####################
# Here's how to see the fonts available:
#
# ```{python}
# from matplotlib import font_manager
# from IPython.core.display import HTML

# flist = font_manager.findSystemFonts()
# names = [font_manager.FontProperties(fname=fname).get_name() for fname in flist]
# print(names)

# def make_html(fontname):
#     return "<p>{font}: <span style='font-family:{font}; font-size: 24px;'>{font}</p>".format(font=fontname)

# code = "\n".join([make_html(font) for font in sorted(set(names))])

# HTML("<div style='column-count: 2;'>{}</div>".format(code))
# ```
#####################
USER $NB_UID
COPY ../fonts ./fontsrc
ENV FONTCONF="/home/${NB_USER}/.config/fontconfig/conf.d"
ENV FONTPATH="/home/${NB_USER}/fonts"
SHELL ["/bin/bash", "-c"]
RUN tlmgr init-usertree \ 
    && mkdir -p ${FONTCONF} \ 
    && mkdir -p ${FONTPATH} \
    && cp ./fontsrc/?-fonts.conf ${FONTCONF}/ \
    && for i in `ls ./fontsrc/*.zip`; \
        do \
            unzip -o -d ${FONTPATH} "$i" -x __MACOSX; \
        done \
    && fc-cache -f -v 
    #&& rm -fr ~/.cache/matplotlib
