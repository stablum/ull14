# vim: set noexpandtab :

BASE_URL = http://www.illc.uva.nl/LaCo/clas/ull14/
O = out/
C = corpora/
T = treebanks/
D = docs/
TMP = tmp/

all: docs $(O)wordfreqdistro.out $(O)pcfg1.out

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
	cat $(C)penn-wsj-line.txt | sed 's/)/)\n/g' > $(O)sed1.out

$(O)wordfreqdistro.out: $(O)sort2.out
#	cat penn-wsj-line.txt | sed 's/)/)\n/g' | grep -o '[^ )]\+)' | sed 's/)//' | sort | uniq -c | sort -g -r -k 1 | sed 's/^ *//' > wordfreqdistro
	cat sort2.out | sed 's/^ *//' > $(O)wordfreqdistro.out

$(O)pcfg1.out: $(T)PCFG_extractor.jar
	java -jar $(T)PCFG_extractor.jar $(C)penn-wsj-line.txt $(O)pcfg1.out

$(O)plotfreqs.png: $(O)wordfreqdistro.out freqs.gnuplot
	cat freqs.gnuplot | gnuplot

clean:
	rm -vrf *.out $(D) $(O) $(C) $(T) $(TMP)

$(C)penn-wsj-line.txt: $(C)

$(C): $(TMP)corpora.zip
	unzip $(TMP)corpora.zip -d $(C)

$(T)PCFG_extractor.jar: $(T)

$(T): $(TMP)treebanks.zip
	unzip $(TMP)treebanks.zip -d $(T)

$(TMP):
	mkdir -pv $(TMP)

$(TMP)corpora.zip: $(TMP)
	cd $(TMP) && wget $(BASE_URL)corpora.zip

$(TMP)treebanks.zip: $(TMP)
	cd $(TMP) && wget $(BASE_URL)treebanks.zip

$(D):
	mkdir -pv $(D)
	cd docs && wget -nd -A pdf,txt -r -l 1 $(BASE_URL)

.PHONY: plotfreqs help

