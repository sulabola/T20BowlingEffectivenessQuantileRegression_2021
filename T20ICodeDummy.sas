/* Uploading the data set */
proc import out=T20
	datafile="F:\QuantileRegression\percentage\T20IDataDummy.xlsx"
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

proc gchart data=T20;
	vbar BowlingStyle/group=SecondBat g100 type=percent;
	*format BowlingStyle $BowlingStyle.;
	label SecondBat='Team' BowlingStyle='Bowling Style';
	axis2 label=('Percentage');
run;

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
	label SecondBat='Team' Run='Average Runs' BowlingStyle='Bowling Style';
	*title "Original data";
run;

/* Average runs concede in each stage by different teams */
proc gchart data=T20;
	vbar Stage/sumvar=Run type=mean group=SecondBat Discrete;
	label SecondBat='Team' Run='Average Runs';
	*title "Original data";
run;

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

/* Quantile regression model - With dummy variables */

/* Overall quantle regression model */
proc quantreg data=T20 algorithm=interior;/*ci=resampling algorithm=interior*/
class Stage BowlingStyle;
model Run=DStage1 DStage2 DStage4 DFast DSpin /quantile=.25 .50 .75;
run;

/* OLS & Quantile Regression models for each team */

/* Australia */
data T20Aus;
	set T20;
	if SecondBat="Australia";
run;
/* OLS */
proc mixed data=T20Aus;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
/* Quantile Regression */
proc quantreg data=T20Aus algorithm=interior;
class Stage BowlingStyle;
model Run=DStage1 DStage2 DStage4 DFast DSpin/quantile=.25 .50 .75;
run;

/* Bangladesh */
data T20Ban;
	set T20;
	if SecondBat="Bangladesh";
run;
/* OLS */
proc mixed data=T20Ban;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
/* Quantile Regression */
proc quantreg data=T20Ban algorithm=interior;
class Stage BowlingStyle;
model Run=DStage1 DStage2 DStage4 DFast DSpin/quantile=.25 .50 .75;
run;

/* England */
data T20Eng;
	set T20;
	if SecondBat="England";
run;
/* OLS */
proc mixed data=T20Eng;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
/* Quantile Regression */
proc quantreg data=T20Eng algorithm=interior;
class Stage BowlingStyle;
model Run=DStage1 DStage2 DStage4 DFast DSpin/quantile=.25 .50 .75;
run;

/* India */
data T20Ind;
	set T20;
	if SecondBat="India";
run;
/* OLS */
proc mixed data=T20Ind;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
/* Quantile Regression */
proc quantreg data=T20Ind algorithm=interior;
class Stage BowlingStyle;
model Run=DStage1 DStage2 DStage4 DFast DSpin/quantile=.25 .50 .75;
run;

/* New Zealand */
data T20Nz;
	set T20;
	if SecondBat="New Zealand";
run;
/* OLS */
proc mixed data=T20Nz;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
/* Quantile Regression */
proc quantreg data=T20Nz algorithm=interior;
class Stage BowlingStyle;
model Run=DStage1 DStage2 DStage4 DFast DSpin/quantile=.25 .50 .75;
run;

/* For Pakistan */
data T20Pak;
	set T20;
	if SecondBat="Pakistan";
run;
/* OLS */
proc mixed data=T20Pak;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
proc quantreg data=T20Pak algorithm=interior;
class Stage BowlingStyle;
model Run=DStage1 DStage2 DStage4 DFast DSpin/quantile=.25 .50 .75;
run;

/* South Africa */
data T20Sa;
	set T20;
	if SecondBat="South Africa";
run;
/* OLS */
proc mixed data=T20Sa;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
/* Quantile Regression */
proc quantreg data=T20Sa algorithm=interior;
class Stage BowlingStyle;
model Run=DStage1 DStage2 DStage4 DFast DSpin/quantile=.25 .50 .75;
run;

/* Sri Lanka */
data T20Sl;
	set T20;
	if SecondBat="Sri Lanka";
run;
/* OLS */
proc mixed data=T20Sl;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
/* Quantile Regression */
proc quantreg data=T20Sl algorithm=interior;
class Stage BowlingStyle;
model Run=DStage1 DStage2 DStage4 DFast DSpin/quantile=.25 .50 .75;
run;

/* West Indies */
data T20Wi;
	set T20;
	if SecondBat="West Indies";
run;
/* OLS */
proc mixed data=T20Wi;
class Stage(ref="3") BowlingStyle(ref="Medium");
model Run=Stage BowlingStyle/s;
run;
/* Quantile Regression */
proc quantreg data=T20Wi algorithm=interior;
class Stage BowlingStyle;
model Run=DStage1 DStage2 DStage4 DFast DSpin/quantile=.25 .50 .75;
run;

/* Bayesian Quantile Regression */

/* Histogram  of the response variable */
proc sgplot data=T20;
  histogram Run / nbins=50;
  xaxis label="Percentage of runs conceded per over";
run;

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
  parms (b0-b5) 0; /* Model parameters - Initial value=0 */
  prior b: ~ general(0); /* Paramters have independent, improper uniform prior */
  mu= b0 + b1*DStage1 + b2*DStage2 + b3*DStage4 + b4*DFast + b5*DSpin; /* mu - (Define) Location parameter of the Laplace distribution */
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
  parms (b0-b5) 0;
  prior b: ~ general(0);
  mu = b0 + b1*DStage1 + b2*DStage2 + b3*DStage4 + b4*DFast + b5*DSpin;
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
  *title "Estimated Parameter by Quantile";
  *title2 "With 95% HPD Interval";
  series x=p y=mean / markers legendlabel="Intercept (b0)";
  band x=p lower=hpdlower upper=hpdupper /
       transparency=.5 legendlabel="HPD Interval";
  yaxis label="Intercept (b0)";
  xaxis label="Quantile";
  refline 0 / axis=y;
run;

/* Produce quantile process table - intercept (b0) */
proc print data=process(where=(parameter="b0")) noobs;
  *title "Estimated Parameter b0 by Quantile";
  *title2 "with 95% HPD Interval";
  var p mean hpdlower hpdupper;
run;

/* Produce quantile process plot - (b1) */
proc sgplot data=process(where=(parameter="b1"));
  *title "Estimated Parameter by Quantile";
  *title2 "With 95% HPD Interval";
  series x=p y=mean / markers legendlabel="Stage (b1)";
  band x=p lower=hpdlower upper=hpdupper /
       transparency=.5 legendlabel="HPD Interval";
  yaxis label="Stage (b1)";
  xaxis label="Quantile";
  refline 0 / axis=y;
run;

/* Produce quantile process table - (b1) */
proc print data=process(where=(parameter="b1")) noobs;
  *title "Estimated Parameter b1 by Quantile";
  *title2 "with 95% HPD Interval";
  var p mean hpdlower hpdupper;
run;

/* Produce quantile process plot - (b2) */
proc sgplot data=process(where=(parameter="b2"));
  *title "Estimated Parameter by Quantile";
  *title2 "With 95% HPD Interval";
  series x=p y=mean / markers legendlabel="Stage (b2)";
  band x=p lower=hpdlower upper=hpdupper /
       transparency=.5 legendlabel="HPD Interval";
  yaxis label="Stage (b2)";
  xaxis label="Quantile";
  refline 0 / axis=y;
run;

/* Produce quantile process table - (b2) */
proc print data=process(where=(parameter="b2")) noobs;
  *title "Estimated Parameter b2 by Quantile";
  *title2 "with 95% HPD Interval";
  var p mean hpdlower hpdupper;
run;

/* Produce quantile process plot - (b3) */
proc sgplot data=process(where=(parameter="b3"));
  *title "Estimated Parameter by Quantile";
  *title2 "With 95% HPD Interval";
  series x=p y=mean / markers legendlabel="Stage (b3)";
  band x=p lower=hpdlower upper=hpdupper /
       transparency=.5 legendlabel="HPD Interval";
  yaxis label="Stage (b3)";
  xaxis label="Quantile";
  refline 0 / axis=y;
run;

/* Produce quantile process table - (b3) */
proc print data=process(where=(parameter="b3")) noobs;
  *title "Estimated Parameter b3 by Quantile";
  *title2 "with 95% HPD Interval";
  var p mean hpdlower hpdupper;
run;

/* Produce quantile process plot - (b4) */
proc sgplot data=process(where=(parameter="b4"));
  *title "Estimated Parameter by Quantile";
  *title2 "With 95% HPD Interval";
  series x=p y=mean / markers legendlabel="Bowling Style (b4)";
  band x=p lower=hpdlower upper=hpdupper /
       transparency=.5 legendlabel="HPD Interval";
  yaxis label="Bowling Style (b4)";
  xaxis label="Quantile";
  refline 0 / axis=y;
run;

/* Produce quantile process table - (b4) */
proc print data=process(where=(parameter="b4")) noobs;
  *title "Estimated Parameter b4 by Quantile";
  *title2 "with 95% HPD Interval";
  var p mean hpdlower hpdupper;
run;

/* Produce quantile process plot - (b5) */
proc sgplot data=process(where=(parameter="b5"));
  *title "Estimated Parameter by Quantile";
  *title2 "With 95% HPD Interval";
  series x=p y=mean / markers legendlabel="Bowling Style (b5)";
  band x=p lower=hpdlower upper=hpdupper /
       transparency=.5 legendlabel="HPD Interval";
  yaxis label="Bowling Style (b5)";
  xaxis label="Quantile";
  refline 0 / axis=y;
run;

/* Produce quantile process table - (b5) */
proc print data=process(where=(parameter="b5")) noobs;
  *title "Estimated Parameter b5 by Quantile";
  *title2 "with 95% HPD Interval";
  var p mean hpdlower hpdupper;
run;

