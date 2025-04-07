
clear all 

cd "C:/Users/Utente/Documents/UNIVE/CORSI/3° PERIODO/ECONOMIC OF RISK AND AGENT BEHAVIOR/Project"

import delimited "carcom_v3.csv", clear

merge 1:1 nquest using Dataset.dta

drop w 
drop cn
drop cd
drop risincert*
drop scoper
drop utscoper
drop spesecon
drop tweet
drop _merge
drop eta
drop cfred
drop b19a
drop b19b

save Data.dta, replace

// EDA

summarize(nquest) if sex == 1 // man 
summarize(nquest) if sex == 2 // women 


// Ditribution of educational attainment by sex 
preserve
keep if sex == 2
graph pie, over(studio) plabel(_all percent) ///
    legend(label(1 "No education") ///
           label(2 "Elementary school") ///
           label(3 "Middle school") ///
           label(4 "Professional diploma") ///
           label(5 "High school") ///
           label(6 "Bachelor's degree or equivalent") ///
           label(7 "Master's degree or equivalent") ///
           label(8 "PhD"))

restore

preserve
keep if sex == 1
graph pie, over(studio) plabel(_all percent) ///
    legend(label(1 "No education") ///
           label(2 "Elementary school") ///
           label(3 "Middle school") ///
           label(4 "Professional diploma") ///
           label(5 "High school") ///
           label(6 "Bachelor's degree or equivalent") ///
           label(7 "Master's degree or equivalent") ///
           label(8 "PhD"))

restore

// Disitribution of age by sex
preserve
keep if sex == 2
graph pie, over(cleta5) plabel(_all percent) ///
    legend(label(1 "Less than 34 years") ///
           label(2 "From 35 to 44 years") ///
           label(3 "From 45 to 54 years") ///
           label(4 "From 55 to 64 years") ///
           label(5 "More than 64 years"))
restore

preserve
keep if sex == 1
graph pie, over(cleta5) plabel(_all percent) ///
    legend(label(1 "Less than 34 years") ///
           label(2 "From 35 to 44 years") ///
           label(3 "From 45 to 54 years") ///
           label(4 "From 55 to 64 years") ///
           label(5 "More than 64 years"))
restore


// Distribution of educational attainment by cleta == 5
preserve
keep if sex == 2 & cleta5 == 5
graph pie, over(studio) plabel(_all percent)
restore

preserve
keep if sex == 1 & cleta5 == 5
graph pie, over(studio) plabel(_all percent)
restore


// Distribution of ncomp by sex 
tab ncomp 
tab ncomp if sex == 1 
tab ncomp if sex == 2 


// Risk aversion by sex 
preserve
keep if sex == 2
graph pie, over(risfin) plabel(_all percent) ///
    legend(label(1 "High return, high risk") ///
           label(2 "Good return, moderate risk") ///
           label(3 "Moderate return, low risk") ///
           label(4 "Low return, no risk"))

restore

preserve
keep if sex == 1
graph pie, over(risfin) plabel(_all percent) ///
    legend(label(1 "High return, high risk") ///
           label(2 "Good return, moderate risk") ///
           label(3 "Moderate return, low risk") ///
           label(4 "Low return, no risk"))

restore


// Risk aversion by age 
preserve
keep if cleta5 == 4
graph pie, over(risfin) plabel(_all percent) ///
    legend(label(1 "High return, high risk") ///
           label(2 "Good return, moderate risk") ///
           label(3 "Moderate return, low risk") ///
           label(4 "Low return, no risk"))

restore






// LINEAR REGRESSION 

correlate savings ncomp af net_income consumption // corrrelation among numerical variables

pwcorr net_income savings

gen log_savings = log(savings)
gen log_net_income = log(net_income)
drop ar

//b19b = mother's employment status 
// b19a = fater's emplyment status 
// b16 = number of children 

regress log_savings i.area3 i.b16 ncomp i.sex i.studio i.staciv i.cleta5 af consumption log_net_income, robust
outreg2 using results.doc, word replace sideway


vif

predict residuals, residuals
histogram residuals

estat imtest, white // there is heteroskedasticty in the model 



// LOGISTIC REGRESSION 
// risfin + rismotbis2_1 + rismotbis2_2

gen output = (savings /net_income > 0.2)

logit output i.area3 i.b16 ncomp i.sex i.studio i.staciv i.cleta5 consumption log_net_income i.pirposs i.risfin i.rismotbis2_1 i.rismotbis2_2 afa3 afb afc1 afc2 afc3 afd1 afd2 afd3 afd4 afe1 afe2 aff1 aff2 afg afh afi afdepos i.ctit i.coldis i.trading, robust

// i.internet 
// coldis 



margins sex 
margins area3
margins b16
margins studio
margins staciv
margins cleta5
margins risfin


summarize afd4
margins sex, at(afd4=(0 2282.904 5821218))
summarize afe1
margins sex, at(afe1=(0 22696.99 1.00e+08))


save Project.do, replace







