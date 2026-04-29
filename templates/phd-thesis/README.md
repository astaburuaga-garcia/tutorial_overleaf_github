# Template for a PhD thesis
THis is a Latex-based template for a PhD thesis at the Faculty of Life Sciences of the Humboldt University Berlin. The PDF file `Template_for_a_PhD_thesis_at_Humboldt_University.pdf` shows the design of this template. The template is based on the package [ClassicThesis](https://ctan.org/pkg/classicthesis?lang=en) by André Miede. It was used and tested in Overleaf (Compiler `pdfLaTeX` and TeX Live Version `texlive-full:2023.1`).

## Set-up
1. Download this repo (zipped version works).
2. Go to [HU's Overleaf](https://latex.hu-berlin.de/project) and create a new project using the files here (or zipped file).
3. In the Overleaf profect, click the *Menu* button on the top left and choose `main.tex` as the Main file under *Settings*.
4. Compile!

## Usage
- Write your text into the various `.tex` files in the *chapters* folder.
- The `main.tex` file is used for compilation, hence all files you add must be included there.
- If you want to change the layout or use specific packages, edit the `preamble.tex` file (it is heavily commented, so search for your keywords to know where to edit).
- Don't change the `classcthesis.sty` file.

## Writing
I had a lot of success using [The most dangerous writing app](https://www.squibler.io/dangerous-writing-prompt-app) in combination with ChatGPT.
1. Set a timer from five to ten minutes and generate without a prompt.
2. Free-write a section for the set time without thinking.
3. Copy the raw and uncorrected text to ChatGPT with a prompt that tells it to correct spelling and improve grammar using scientific English.
4. Copy ChatGPT's text to any text editor and rephrase the text using your own words and add anything you forgot (you are now an editor basically).
5. Put the text into Latex form in the Overleaf project.
6. Repeat steps 1. to 5. for the next section.
