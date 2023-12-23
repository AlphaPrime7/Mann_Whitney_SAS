* author: Tingwei Adeck
* date: 2022-11-13
* purpose: Mann-Whitney (Nonparametric Independent t-test)
* license: public domain
* Input: mw_test.sav
* Output: MW_ _SAS.pdf
* Description: Understand the impact of gender on public engagement
* Results: Gender medians do not differ statistically and gender score distributions are equal
males and females engage equally (p = 0.0702 > 0.05);

%let path=/home/u40967678/sasuser.v94;


libname disney
    "&path/sas_umkc/input";
    
filename mwtest
    "&path/sas_umkc/input/mw_test.sav";   
    
ods pdf file=
    "&path/sas_umkc/output/MW_Gender_SAS.pdf";
    
options papersize=(8in 11in) nonumber nodate;

proc import file= mwtest
	out=disney.mwtest
	dbms=sav
	replace;
run;

*create a unique id or primary key(proc SQL) for use in transpose-a good habit;
data disney.mwtest_uid;
set disney.mwtest;
new_id = _N_;
run;

title 'summary of Gender-Enagement data';
proc print data =disney.mwtest_uid;
run;

*F-test of variance equality assumption;
/*perform F-test for equal variances*/
title 'F-test derived from a T-test';
proc ttest data=disney.mwtest_uid;
    class gender;
    var engagement;
run;


/*perform Mann Whitney U test*/
title 'Mann-Whitney Test on gender and engagement';
proc npar1way data=disney.mwtest_uid wilcoxon;
    class gender;
    var engagement;
run;

ods pdf close;
