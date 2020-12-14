libname mylib '/folders/myfolders/SASDataFiles';

data work.ada_data;
set mylib.ada_diabetes;
if sddsrvyr in (7,8,9);

/*Code for race/ethnicity variables*/ 
if ridreth3 in (1,2) then eth=1; 
else if ridreth3 in (3) then eth=0;
else if ridreth3 in (4) then eth=2;
else if ridreth3 in (6) then eth=3;
else if ridreth3 in (7) then eth=3;

label eth = white, hispanic, black, multiple;

/* Sex */
if ridgendr in (1) then sex = 0;
else if ridgender in (2) then sex = 1;

label sex = male, female; 

/* Age */
if ridageyr lt 18 then age=.;
else if ridageyr ge 18 and ridageyr le 29 then age=1;
else if ridageyr ge 30 and ridageyr le 39 then age=2;
else if ridageyr ge 40 and ridageyr le 49 then age=3;
else if ridageyr ge 50 and ridageyr le 59 then age=4;
else if ridageyr ge 60 and ridageyr le 69 then age=5;
else if ridageyr ge 70 and ridageyr le 79 then age=6;
else if ridageyr ge 80 then age=7;

label age = 18-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80+;

*Code for ever smoker variable;
if smq020 in (1) then evsmk=1;
else if smq020 in (2) then evsmk=0;

label evsmk = ever smoker;

/*Code for smoking variable*/
if evsmk in (1) and smq040 in (1,2) then tobacco=1;
else if evsmk in (1) and smq040 in (3) then tobacco=2;
else if evsmk in (0) and smq040 in (.) then tobacco=0;

label tobacco = never smoker, current smoker, former smoker;

/*Code for general health variable*/
if hsd010 in (1,2,3) then healthstat=0;
else if hsd010 in (4,5) then healthstat=1;
else if hsd010 in (7,9,.) then healthstat=.;

label healthstat = good/excellent, fair/poor;

/*Code for actual BMI variable*/
if bmxbmi lt 18.5 then actbmi=1;
else if bmxbmi ge 18.5 and bmxbmi lt 25 then actbmi=0;
else if bmxbmi ge 25 and bmxbmi lt 30 then actbmi=2;
else if bmxbmi ge 30 then actbmi=3;

label actbmi = normal weight, underweight, overweight, obese;

/* Code for Diabetes */
if diq010 in (1) then diabetes=1;
else if diq010 in (2) then diabetes=0;

label diabetes = does not have diabetes, has diabetes;

/* Education */
if ridageyr le 19 then do;
if dmdeduc3 in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 55, 66) then cedu = 0;
else if dmdeduc3 in (13, 14, 15) then cedu = 1;
end;

label cedu = did not finish HS, finished HS;

if ridageyr ge 20 then do;
if dmdedu2 in (1, 2) or cedu in (0) then education = 0; 
else if cedu in (1) or dmdeduc2 in (3) then education = 1;
else if dmdeduc2 in (4) then education = 2;
else if dmdeduc2 in (5) then education = 3;
else if dmdeduc2 in (7,9,.) then education = .;

label education = below HS, HS, some college, bach and above;

/* Code for Insurance */
if hiq011 in (1) then cover=1;
else if hiq011 in (2) then cover=0;

label cover = not insured, insured;

if cover in (1) and hiq031A in (14) then insur = 0;
else if cover in (1) and hiq031B in (15) and hiq031C in (16) then insur = 1;
else if cover in (1) and hiq031D in (17) then insur = 2;
else if cover in (1) and hiq031F in (19) then insur = 3;
else if cover in (1) and hiq031H in (21) then insur = 4;
else if cover in (1) and hiq031I in (22) then insur = 5;
else if cover in (1) and hiq031J in (23) then insur = 6;
else if cover in (0) and hiq031AA in (40) then insur = 7;
else insur = .;

label insur = private insurance, any Medicare, Medicaid, military insurance, state sponsored, govenment insurance, single service plan, uninsured;

/* Family History of Diabetes */
if diq172 in (1) then risk = 1;
else if diq172 in (2) then risk = 0;

label risk = does not believe have risk, believes has risk;

if risk in (1) and diq175A in (10) then history = 1;
else if risk in (0) and diq175A in (.) then history = 0;

label history = no family history, family history;

run;

data mylib.ada_final;
set work.ada_data;