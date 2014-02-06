all: wordfreqdistro.out pcfg1.out

sort2.out: uniq1.out
	cat uniq1.out | sort -g -r -k 1 > sort2.out

uniq1.out: sort1.out
	cat sort1.out | uniq -c > uniq1.out

sort1.out: sed3.out
	cat sed3.out | sort > sort1.out

sed3.out: sed2.out
	cat sed2.out | sed 's/)//' > sed3.out

sed2.out: sed1.out
	cat sed1.out | grep -o '[^ )]\+)' > sed2.out

sed1.out: penn-wsj-line.txt
	cat penn-wsj-line.txt | sed 's/)/)\n/g' > sed1.out

wordfreqdistro.out: sort2.out
#	cat penn-wsj-line.txt | sed 's/)/)\n/g' | grep -o '[^ )]\+)' | sed 's/)//' | sort | uniq -c | sort -g -r -k 1 | sed 's/^ *//' > wordfreqdistro
	cat sort2.out | sed 's/^ *//' > wordfreqdistro.out

pcfg1.out: PCFG_extractor.jar
	java -jar PCFG_extractor.jar penn-wsj-line.txt pcfg1.out

clean:
	rm -vf *.out

penn-wsj-line.txt: corpora.zip
	unzip corpora.zip

PCFG_extractor.jar: treebanks.zip
	unzip treebanks.zip

corpora.zip:
	wget http://www.illc.uva.nl/LaCo/clas/ull14/corpora.zip

treebanks.zip:
	wget http://www.illc.uva.nl/LaCo/clas/ull14/treebanks.zip
