/* Uploading the data set */
proc import out=T20
	datafile="F:\QuantileRegression\percentage\T20IData.xlsx"
	dbms=xlsx replace;getnames=yes;
run;

/* Print the data set */
proc print data=T20(obs=50);
run;

/* Add a format to bowling styles */
proc format;
value $BowlingStyle 'Fast'='Fast'
					'Medium'="Medium"
					'Spin'='Spinners';
run;

/* Insights of the data set */
/* Total runs conceded */
proc means data=T20;
var Total;
run;
/* Response of the matches - For first bowling team */
proc freq data=T20;
tables Response;
run;
/* Percentage of win/l/t conceding more than 150 runs by first bowling team */
proc freq data=T20;
where Total>120;
tables Response;
run;
proc freq data=T20;
where Total>150;
tables Response;
run;
proc freq data=T20;
where Total>175;
tables Response;
run;

/* Overall Percentage of Bowlers Types */
proc freq data=T20;
tables BowlingStyle;
*format BowlingStyle $BowlingStyle.;
run;

/* Different types of bowlers in each team */
/*
proc gchart data=T20;
	vbar BowlingStyle/group=SecondBat G100 type=percent;
	title "Original data";
run;
*/
proc gchart data=T20;
	vbar BowlingStyle/group=SecondBat g100 type=percent;
	*format BowlingStyle $BowlingStyle.;
	label SecondBat='Country' BowlingStyle='Bowling Style';
	axis2 label=('Percentage');
run;
/*
Color graph
proc SGPLOT data=T20;
vbar SecondBat /
stat=percent
group=BowlingStyle
groupdisplay=cluster;
vline SecondBat /
stat=percent
group=BowlingStyle
groupdisplay=cluster lineattrs=(thickness=0px);
run;
*/
/*
proc tabulate data=T20 out=T20ColorBowlingStyles;
class BowlingStyle SecondBat;
tables SecondBat,BowlingStyle*rowpctn;
run;
*/
/*
proc SGPLOT data=T20ColorBowlingStyles;
vbarparm category=SecondBat response=pctn_01/ group=BowlingStyle;
scatter x=SecondBat y=pctn_01/group=BowlingStyle
markerchar=pctn_01 groupdisplay=cluster;
yaxis label='Percentage' values=(0 to 100 by 10);
xaxis label='Country';
format BowlingStyle $BowlingStyle.;
label SecondBat='Country'
			BowlingStyle='Bowling Style';
run;
*/

/* Average runs conceded by different types of bowlers */
proc means data=T20;
Class BowlingStyle;
var Run;
run;

/* Overall average runs conceded in different stages */
proc means data=T20 mean std q1 median q3;
class Stage;
var Run;
run;

/* Average runs concede by each team with different bowlers */
proc gchart data=T20;
	vbar BowlingStyle/sumvar=Run type=mean group=SecondBat Discrete;
	label SecondBat='Country' Run='Average Runs' BowlingStyle='Bowling Style';
	*title "Original data";
run;

/* Average runs concede in each stage by different teams */
proc gchart data=T20;
	vbar Stage/sumvar=Run type=mean group=SecondBat Discrete;
	label SecondBat='Country' Run='Average Runs';
	*title "Original data";
run;
/*
proc gchart data=t20update1;
	vbar Stage/sumvar=Run type=mean group=FirstBat Discrete;
	title "Updated data";
label FirstBat='Country'
		Run='Average Runs';
run;
*Color graph
PROC SGPLOT DATA=t20update1;
VBAR FirstBat / RESPONSE=Run group=Stage stat=mean groupdisplay=cluster;
yaxis label='Average Runs' values=(0 to 10 by 1);
xaxis label='Country';
run;
*/

/* Average runs conceded by each team
proc means data=T20;
class SecondBat;
var Run;
run;
/* Average runs conceded by different teams in each stage
proc means mean data=T20;
class SecondBat Stage;
var Run;
run;
*/

/* Average runs conceded in each stage by different types of bowlers */
proc means mean data=T20;
class Stage BowlingStyle;
var Run;
run;

/* Average percentage of runs conceded per over in each stage with different types of bowlers by each team */
proc means mean data=T20;
class SecondBat Stage BowlingStyle;
var Run;
run;

/* Percentage of bowlers used by each team */
proc tabulate data=T20 out=T20ColorBowlingStyles;
class BowlingStyle SecondBat;
tables SecondBat,BowlingStyle*rowpctn;
run;
/* Percentage of bowlers used in different stage by each team */
proc sort data=T20 out=T20Temp1;
by SecondBat Stage;
run;
proc freq data=T20Temp1;
by SecondBat;
tables Stage*BowlingStyle/nofreq nopercent nocol;
run;

/* Response of the matches - For first bowling team - India */
proc freq data=T20;
where SecondBat='India';
tables Response;
run;

/* Response of the matches - For first bowling team - New Zealand */
proc freq data=T20;
where SecondBat='New Zealand';
tables Response;
run;

/* Response of the matches - For first bowling team - England */
proc freq data=T20;
where SecondBat='England';
tables Response;
run;

/* OLS model */
proc mixed data=T20;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;

/* Quantile regression model */
/* Changing order, "ref" is not available in QuantReg procedure */
proc format;
	value	StageNew	1=1
						2=2
						3=4
						4=3;
	value	$BOwlingStyleNew	"Fast"=1
								"Medium"=3
								"Spin"=2;
run;
data T20Temp1;
	set T20;
	format	Stage			StageNew.
			BowlingStyle	$BOwlingStyleNew.;
run;
proc quantreg data=T20Temp1 algorithm=interior;/*ci=resampling algorithm=interior*/
class Stage BowlingStyle;
model Run=Stage BowlingStyle /quantile=.25 .50 .75;
run;


/* OLS & Quantile Regression models for each team */

/* For Australia */
data T20AusOLS;
	set T20;
	if SecondBat="Australia";
run;
*proc print data=T20AusOLS(obs=50);
*run;
proc mixed data=T20AusOLS;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
data T20AusQR;
	set T20Temp1;
	if SecondBat="Australia";
run;
*proc print data=T20AusQR(obs=50);
*run;
proc quantreg data=T20AusQR algorithm=interior;
class Stage BowlingStyle;
model Run=Stage BowlingStyle/quantile=.25 .50 .75;
run;


/* For Bangladesh */
data T20BanOLS;
	set T20;
	if SecondBat="Bangladesh";
run;
proc print data=T20BanOLS(obs=50);
run;
proc mixed data=T20BanOLS;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
data T20BanQR;
	set T20Temp1;
	if SecondBat="Bangladesh";
run;
proc print data=T20BanQR(obs=50);
run;
proc quantreg data=T20BanQR algorithm=interior;
class Stage BowlingStyle;
model Run=Stage BowlingStyle/quantile=.25 .50 .75;
run;


/* For England */
data T20EngOLS;
	set T20;
	if SecondBat="England";
run;
proc print data=T20EngOLS(obs=50);
run;
proc mixed data=T20EngOLS;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
data T20EngQR;
	set T20Temp1;
	if SecondBat="England";
run;
proc print data=T20EngQR(obs=50);
run;
proc quantreg data=T20EngQR algorithm=interior;
class Stage BowlingStyle;
model Run=Stage BowlingStyle/quantile=.25 .50 .75;
run;


/* For India */
data T20IndOLS;
	set T20;
	if SecondBat="India";
run;
proc print data=T20IndOLS(obs=50);
run;
proc mixed data=T20IndOLS;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
data T20IndQR;
	set T20Temp1;
	if SecondBat="India";
run;
proc print data=T20IndQR(obs=50);
run;
proc quantreg data=T20IndQR algorithm=interior;
class Stage BowlingStyle;
model Run=Stage BowlingStyle/quantile=.25 .50 .75;
run;


/* For New Zealand */
data T20NzOLS;
	set T20;
	if SecondBat="New Zealand";
run;
proc print data=T20NzOLS(obs=50);
run;
proc mixed data=T20NzOLS;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
data T20NzQR;
	set T20Temp1;
	if SecondBat="New Zealand";
run;
proc print data=T20NzQR(obs=50);
run;
proc quantreg data=T20NzQR algorithm=interior;
class Stage BowlingStyle;
model Run=Stage BowlingStyle/quantile=.25 .50 .75;
run;


/* For Pakistan */
data T20PakOLS;
	set T20;
	if SecondBat="Pakistan";
run;
proc print data=T20PakOLS(obs=50);
run;
proc mixed data=T20PakOLS;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
data T20PakQR;
	set T20Temp1;
	if SecondBat="Pakistan";
run;
proc print data=T20PakQR(obs=50);
run;
proc quantreg data=T20PakQR algorithm=interior;
class Stage BowlingStyle;
model Run=Stage BowlingStyle/quantile=.25 .50 .75;
run;


/* For South Africa */
data T20SaOLS;
	set T20;
	if SecondBat="South Africa";
run;
proc print data=T20SaOLS(obs=50);
run;
proc mixed data=T20SaOLS;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
data T20SaQR;
	set T20Temp1;
	if SecondBat="South Africa";
run;
proc print data=T20SaQR(obs=50);
run;
proc quantreg data=T20SaQR algorithm=interior;
class Stage BowlingStyle;
model Run=Stage BowlingStyle/quantile=.25 .50 .75;
run;


/* For Sri Lanka */
data T20SlOLS;
	set T20;
	if SecondBat="Sri Lanka";
run;
proc print data=T20SlOLS(obs=50);
run;
proc mixed data=T20SlOLS;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
data T20SlQR;
	set T20Temp1;
	if SecondBat="Sri Lanka";
run;
proc print data=T20SlQR(obs=50);
run;
proc quantreg data=T20SlQR algorithm=interior;
class Stage BowlingStyle;
model Run=Stage BowlingStyle/quantile=.25 .50 .75;
run;


/* For West Indies */
data T20WiOLS;
	set T20;
	if SecondBat="West Indies";
run;
proc print data=T20WiOLS(obs=50);
run;
proc mixed data=T20WiOLS;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
data T20WiQR;
	set T20Temp1;
	if SecondBat="West Indies";
run;
proc print data=T20WiQR(obs=50);
run;
proc quantreg data=T20WiQR algorithm=interior;
class Stage BowlingStyle;
model Run=Stage BowlingStyle/quantile=.25 .50 .75;
run;


/* Quantile Regression Approach */

/* Histogram  of the response variable */
proc sgplot data=T20;
  histogram Run / nbins=50;
  xaxis label="Percentage of runs conceded per over";
run;

/* MCMC procedure */
proc mcmc data=T20
          seed=5263
		  DIAG=ALL /* Computes all diagnostic tests and statistics */
		  STATS=All /* Computes all posterior statistics. */
          propcov=congra /* Specifies conjugate-gradient method used - Initial covariance matrix - Metropolis-Hasting algorithm */
          ntu=1000 /* Tuning iterations */
          mintune=10 /* Minimum proposal tuning loops */
          nmc=30000 /* MCMC iterations - excluding burn-in iterations */;
  begincnst;
    p=0.50; /* Quantile being fitted */
  endcnst;
  parms (b0-b2) 0; /* Model parameters - Initial value=0 */
  prior b: ~ general(0); /* Paramters have independent, improper uniform prior */
  mu= b0 + b1*Stage + b2*BowlingStyle1; /* mu - (Define) Location parameter of the Laplace distribution */
  u = Run - mu; /* Defines random variable u */
  ll = log(p)+log(1-p) - 0.5*(abs(u)+(2*p-1)*u); /* Defines log-likelihood function in terms of p and u */
  model Run ~ general(ll); /* Response variable have an asymmetric Laplace distribution define by log-likelihood function (ll) */
run;


/* Usefull to examine the quantile process/ how thw estimated parameters for each covariate changes as p varies */

/* Range of p in increments */
data by_T20;
  set T20;
  do p = .10 to .90 by .10; /* 19 quantiles, 19 copies of original data set */
    output;
  end;
run;

proc print data=by_T20(obs=50);
run;

/* Indexed and sort the new dataset by p */
proc sort data=by_T20;
  by p;
run;

proc print data=by_T20(obs=50);
run;

ods output postsummaries=by_ps postintervals=by_pi; /* Save posterior summaries (by_ps) and posterior intervals (by_pi) */
proc mcmc data=by_T20
          seed=73625
		  STATISTICS=INTERVAL /* To get posterior intervals */
		  STATISTICS=SUMMARY /* To get posterior summaries */
          propcov=congra
          ntu=1000
          nmc=30000
          mintune=10;
  by p;
  parms (b0-b2) 0;
  prior b: ~ general(0);
  mu = b0 + b1*Stage + b2*BowlingStyle1;
  u = Run - mu;
  ll = log(p)+log(1-p) - 0.5*(abs(u)+(2*p-1)*u);
  model Run ~ general(ll);
run;

/* Merge two data sets - by_ps & by_pi */ 
data process;
  merge by_ps by_pi;
run;

/* Sort the merged data set */
proc sort data=process out=process;
  by parameter p;
run;

/* Produce quantile process plot - intercept (b0) */
proc sgplot data=process(where=(parameter="b0"));
  title "Estimated Parameter by Quantile";
  title2 "With 95% HPD Interval";
  series x=p y=mean / markers legendlabel="Intercept (b0)";
  band x=p lower=hpdlower upper=hpdupper /
       transparency=.5 legendlabel="HPD Interval";
  yaxis label="Intercept (b0)";
  xaxis label="Quantile";
  refline 0 / axis=y;
run;

/* Produce quantile process table - intercept (b0) */
proc print data=process(where=(parameter="b0")) noobs;
  title "Estimated Parameter b0 by Quantile";
  title2 "with 95% HPD Interval";
  var p mean hpdlower hpdupper;
run;

/* Produce quantile process plot - intercept (b1) */
proc sgplot data=process(where=(parameter="b1"));
  title "Estimated Parameter by Quantile";
  title2 "With 95% HPD Interval";
  series x=p y=mean / markers legendlabel="Stage (b1)";
  band x=p lower=hpdlower upper=hpdupper /
       transparency=.5 legendlabel="HPD Interval";
  yaxis label="Stage (b1)";
  xaxis label="Quantile";
  refline 0 / axis=y;
run;

/* Produce quantile process table - intercept (b1) */
proc print data=process(where=(parameter="b1")) noobs;
  title "Estimated Parameter b1 by Quantile";
  title2 "with 95% HPD Interval";
  var p mean hpdlower hpdupper;
run;

/* Produce quantile process plot - intercept (b2) */
proc sgplot data=process(where=(parameter="b2"));
  title "Estimated Parameter by Quantile";
  title2 "With 95% HPD Interval";
  series x=p y=mean / markers legendlabel="Bowling Style (b2)";
  band x=p lower=hpdlower upper=hpdupper /
       transparency=.5 legendlabel="HPD Interval";
  yaxis label="Bowling Style (b2)";
  xaxis label="Quantile";
  refline 0 / axis=y;
run;

/* Produce quantile process table - intercept (b2) */
proc print data=process(where=(parameter="b2")) noobs;
  title "Estimated Parameter b2 by Quantile";
  title2 "with 95% HPD Interval";
  var p mean hpdlower hpdupper;
run;

