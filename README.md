mtypography
===========

Simple bash script introducing basic Polish typography in md (or compatible) files.

Replaces:

- `,,` with „ 
- `''` with ”
- '>>' with »
- '<<' with «

And adds non-breaking space in various formats according to Polska Norma (PN-83/P-55366)
+ some good practices

## Installing

Put it somewhere in your path with appropriate permissions.

## Usage

    mtypography.sh {option} < file.md | pandoc ...

Where option can be:

html (default when omitted)

: `u00a0` (NO-BREAK SPACE); word processor formats also accept this one; may be preferable for
  DOCX export (MS-Word format)

test

: `u2218` (RING OPERATOR)

docx

: `u200d+u0020` (ZERO-WIDTH JOINER + SPACE); apparently it depends on font used (Calibri and
  Arial work, TNR and Cambria not) and/or if program is in Compatibility mode(?), overall
  solution no-reliable, stick with 00a0 when in doubt

odt

: `u2060+u0020` (WORD JOINER + SPACE); works very nice, note: line below contains zero-width
  char

latex

: `~` (TILDE)

space

: `u0020` (SPACE); just do nothing with regard to spaces, stick with quotes replacement


## Problems with docx/odt export

Regular NO-BREAK SPACE is also called hard space due to its non elasticity. It will became
always the same width without regard to formatting of line in paragraph. It will be
especially visible when justifying paragraph.

Two char combination works flawlessly in ODT (LibreOffice Writer) but with mixed results
in DOCX (MS-Word) export.
