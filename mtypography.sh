#!/bin/bash
# Script introducing basic Polish typography into txt file
# Author: Mikolaj Machowski
# Date: 2017-11-12
# License: GPL v2

# Define NBSP sequence {{{
# WARNING: some combinations of Vim+terminal can handle zero-width chars strangely
if [ ${1+x} ]; then
    case $1 in
    html)
        # HTML  - u00a0 (NO-BREAK SPACE)
        #         word processor formats also accept this one
        #         may be preferable for DOCX export (MS-Word format)
        NBSP=' '
        ;;
    test)
        # Test - u2218 (RING OPERATOR) or <>
        # NBSP='<>'
        NBSP='∘'
        ;;
    docx)
        # DOCX  - u200d+u0020 (ZERO-WIDTH JOINER + SPACE)
        #         apparently it depends on font used (Calibri and Arial work, TNR and Cambria not)
        #         and/or if program is in Compatibility mode(?),
        #         overall solution no-reliable, stick with 00a0?
        NBSP='‍ '
        ;;
    odt)
        # ODT   - u2060+u0020 (WORD JOINER + SPACE)
        #         works very nice, note: line below contains zero-width char
        NBSP='⁠ '
        ;;
    latex)
        # LaTeX - ~ (TILDE)
        NBSP='~'
        ;;
    space)
        # plain - u0020 (SPACE)
        #         just space for really weird cases
        NBSP=' '
        ;;
    esac
else
    # HTML  - u00a0 (NO-BREAK SPACE)
    #         word processor formats also accept this one
    #         may be preferable for DOCX export (MS-Word format)
    NBSP=' '
fi
# }}}

# WARNINGS
# - depends on GNU sed 4.2.2 and higher (-z option)
# - some of those can wreak havoc when eg. in code blocks, doesn't apply to my
#   cases but caveat for general usage; reson why filter operating on JSON
#   structure would be beneficial
# Changes in lines: {{{
# 1. Typographic quotes
# 2. One letter words
# 3. separation of initial from name
#    (WARNING: can create false positives and mess with lists formatting)
# 4. numbers befor one letter shortcuts w. r. c.
# 5. units (only popular)
# 6. scientific titles
# 7. military titles
# 8. church and aristocratic titles
# 9. itp., itd. (nbsp before)
# 10. tj., tzn. (nbsp after)
# 11. str., godz. (nbsp after)
# 12. Insert space before: ([{
# 13. Insert space after:  )]}:;,?!
# 14. Remove space before: @%)]}:;,./?!
# 15. Remove space after:  @([{/
# }}}
sed -z -e 's/,,/„/g' -e "s/''/”/g" -e 's/>>/»/g' -e 's/<</«/g' \
    -e "s/\<\([iaouwzIAOUWZ]\)\(\n\s*\| \)\([[:print:]]\)/\1$NBSP\3/g" \
    -e "s/\<\([A-ZŁŻ].\)\(\n\s*\| \)\([A-ZŁŻĆŚŹ]\)/\1$NBSP\3/g" \
    -e "s/\([0-9IVXLCDM]\)\(\n\s*\| \)\([wrcs]\.\)/\1$NBSP\3/g" \
    -e "s/\([0-9]\)\(\n\s*\| \)\(zł\|gr\|km\|m\|dm\|cm\|mm\|ha\|ml\|l\|hl\|t\|kg\|g\|oz\|h\|min\|sek\|s\)\>/\1$NBSP\3/g" \
    -e "s/\<\([Mm]gr\|[Dd]r\|[Pp]rof\.\|hab\.\|[Ii]nż\.\)\(\n\s*\| \)\([A-ZŁŻĆŚŹ]\)/\1$NBSP\3/g" \
    -e "s/\<\([Mm]ar\.\|[Kk]mdr\|mł\.\|st\.\|[Ss]zer\.\|[Kk]pr\.\|[Pp]lut\.\|[Ss]ierż\.\|[Cc]hor\.\|[Pp]por\.\|[Pp]or\.\|[Kk]pt\.\|[Mm]jr\|[Pp]płk\|[Pp]łk\|[Gg]en\.\|[Aa]dm\.\)\(\n\s*\| \)\([A-ZŁŻĆŚŹ]\)/\1$NBSP\3/g" \
    -e "s/\<\([Kk]s\.\|[Aa]bp\|[Bb]p\|[Kk]ard\.\|o\.\|[Hh]r\.\)\(\n\s*\| \)\([A-ZŁŻĆŚŹ]\)/\1$NBSP\3/g" \
    -e "s/\([[:print:]]\)\(\n\s*\| \)\(itp\.\|itd\.\|się\|no\)\>/\1$NBSP\3/g" \
    -e "s/\<\(tj\.\|tzn\.\)\(\n\s*\| \)\([[:print:]]\)/\1$NBSP\3/g" \
    -e "s/\<\(s\.\|str\.\|godz\.\|rok\|roku\|rokiem\)\(\n\s*\| \)\([0-9]\)/\1$NBSP\3/g" \
    -e "s/\([^ ]\)\([[({]\)/\1 \2/g" \
    -e "s/\([])}:;,?!]\)\([^ ]\)/\1 \2/g" \
    -e "s/ \([])}%@:;,?!/]\)/\1/g" \
    -e "s/\([[@({/]\) /\1/g" \

# TODO {{{
# Space after two-letter words: {{{
# bo
# Bo
# by
# By
# co
# Co
# do
# Do
# ja
# Ja
# ją
# Ją
# je
# Je
# ku
# Ku
# li
# Li
# ma
# Ma
# mi
# Mi
# my
# My
# na
# Na
# np.
# Np.
# ok.
# Ok.
# od
# Od
# ów
# Ów
# po
# Po
# są
# Są
# ta
# Ta
# tą
# Tą
# tę
# Tę
# to
# To
# tu
# Tu
# ty
# Ty
# we
# We
# wy
# Wy
# za
# Za
# ze
# Ze
# że
# Że
# }}}
# Other, more aggressive with space after: {{{
# oraz
# albo
# bądź
# czy
# lub
# ani
# ale
# lecz
# zaś
# czyli
# przeto
# tedy
# więc
# zatem
#
# bez
# pod
# nad
# znad
# poprzez
# sprzed
# zza
#
# oni
# one
# mój
# twój
# nasz
# wasz
# ich
# jego
# jej
# ten
# tamten
# tam
# tędy
# taki
# tamci
# owi
# razy
# tylko
# nie
# niech
# niechaj
# tak
# bodaj
# oby
# }}}
# Fix common punctuation mistakes: {{{
# Replace - (HYPHEN) enclosed in spaces with -- (ndash) (risky)
# }}}
# }}}
# All data collected or influenced by discussions from: {{{
# http://typografia.info/dzielenie-i-pozostawianie (Robert Twardoch, accessed 2017-11-09)
# https://forum.openoffice.org/pl/forum/viewtopic.php?f=9&t=63 (various, accessed 2017-11-09)
# My own work on Vim LaTeX-Suite.
# }}}
# vim:fdm=marker nowrap
