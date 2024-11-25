# To use web fonts: https://fonts.google.com/knowledge/using_type/using_web_fonts
# To load web fonts: https://fonts.google.com/knowledge/using_type/using_web_fonts_from_a_font_delivery_service
# For the HTML header:
# <link rel="preconnect" href="https://fonts.googleapis.com">
# <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
# <link href="https://fonts.googleapis.com/css2?family=Micro+5&display=swap" rel="stylesheet">
# <link href="https://fonts.googleapis.com/css2?family=Sedan:ital@0;1&display=swap" rel="stylesheet">
# <link href="https://fonts.googleapis.com/css2?family=Source+Code+Pro:ital,wght@0,200..900;1,200..900&display=swap" rel="stylesheet">
# For the Micro-5 font:
# .micro-5-regular {
#   font-family: "Micro 5", sans-serif;
#   font-weight: 400;
#   font-style: normal;
# }
# .sedan-regular {
#   font-family: "Sedan", serif;
#   font-weight: 400;
#   font-style: normal;
# }
# .sedan-regular-italic {
#   font-family: "Sedan", serif;
#   font-weight: 400;
#   font-style: italic;
# }
# // <uniquifier>: Use a unique and descriptive class name
# // <weight>: Use a value from 200 to 900

# .source-code-pro-<uniquifier> {
#   font-family: "Source Code Pro", monospace;
#   font-optical-sizing: auto;
#   font-weight: <weight>;
#   font-style: normal;
# }
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

USER $NB_UID
ADD /fonts/*.zip /home/${NB_USER}/
SHELL ["/bin/bash", "-c"]
RUN mkdir -p /home/${NB_USER}/.config/fontconfig/conf.d
COPY ../fonts/1-fonts.conf /home/${NB_USER}/.config/fontconfig/conf.d/10-custom-fonts.conf
RUN mkdir -p /home/${NB_USER}/local/share/fonts/ \
    && for i in `ls /home/${NB_USER}/*.zip`; \
        do \
            unzip -o "$i"; \
            for j in `find . -name "*.ttf"`; \
                do \
                    mv "$j" /home/${NB_USER}/local/share/fonts/; \
                done; \
            rm "$i"; \
        done \
    && chown -R ${NB_USER} /home/${NB_USER}/local/share/fonts \
    && fc-cache -f -v 
    #&& rm -fr ~/.cache/matplotlib