# vim: set noexpandtab :

BASE_URL = http://www.illc.uva.nl/LaCo/clas/ull14/
O = out/
C = corpora/
T = treebanks/
D = docs/

all: docs wordfreqdistro.out pcfg1.out

help:
	more README.md

$(O):
	mkdir -pv $(O)

$(O)sort2.out: $(O) $(O)uniq1.out
	cat $(O)uniq1.out | sort -g -r -k 1 > $(O)sort2.out

$(O)uniq1.out: $(O) $(O)sort1.out
	cat $(O)sort1.out | uniq -c > $(O)uniq1.out

$(O)sort1.out: $(O) $(O)sed3.out
	cat $(O)sed3.out | sort > $(O)sort1.out

$(O)sed3.out: $(O) $(O)sed2.out
	cat $(O)sed2.out | sed 's/)//' > $(O)sed3.out

$(O)sed2.out: $(O) $(O)sed1.out
	cat $(O)sed1.out | grep -o '[^ )]\+)' > $(O)sed2.out

$(O)sed1.out: $(O) $(C)penn-wsj-line.txt
	cat penn-wsj-line.txt | sed 's/)/)\n/g' > $(O)sed1.out

wordfreqdistro.out: sort2.out
#	cat penn-wsj-line.txt | sed 's/)/)\n/g' | grep -o '[^ )]\+)' | sed 's/)//' | sort | uniq -c | sort -g -r -k 1 | sed 's/^ *//' > wordfreqdistro
	cat sort2.out | sed 's/^ *//' > wordfreqdistro.out

pcfg1.out: PCFG_extractor.jar
	java -jar PCFG_extractor.jar penn-wsj-line.txt pcfg1.out

plotfreqs.png: wordfreqdistro.out freqs.gnuplot
	cat freqs.gnuplot | gnuplot

clean:
	rm -vrf *.out $(D) $(O) $(C) $(T)

$(C)penn-wsj-line.txt: $(C)

$(C): corpora.zip
	unzip corpora.zip -d $(C)

PCFG_extractor.jar: $(T)

$(T): treebanks.zip
	unzip treebanks.zip -d $(T)

corpora.zip:
	wget $(BASE_URL)corpora.zip

treebanks.zip:
	wget $(BASE_URL)treebanks.zip

$(D):
	mkdir -pv $(D)
	cd docs && wget -nd -A pdf,txt -r -l 1 $(BASE_URL)

.PHONY: plotfreqs help
