# Modeling T20I cricket bowling effectiveness: A quantile regression approach with a Bayesian extension

Bowling effectiveness is a key factor in winning cricket matches. The team captain should decide when to use the right bowler at the right moment so that the team can optimize the outcome of the game. In this study, we investigate the effectiveness of different types of bowlers at different stages of the game, based on the conceded percentage of runs from the innings total, for each over. In this article, the authors divided the twenty-over spell of a T20I match into four stages. In order to understand the broad spectrum of the behavior of game variables, a Quantile Regression methodology is used for statistical analysis. Following that, a Bayesian approach to Quantile Regression is undertaken.

The PDF copy of the paper can be downloaded from here: [Download Paper](https://journals.sagepub.com/doi/full/10.3233/JSA-200556) 

Programming Language: [SAS](https://www.sas.com/en_us/home.html)

Data: The data used is available in the Excel file in the repository. The source of data is [espncricinfo](https://www.espncricinfo.com/)

### Methodology

For modeling purposes, the twenty-over innings of a T20I match were divided into four stages: Stage 1 (overs 1-6 PowerPlay), Stage 2 (overs 7-10), Stage 3 (overs 11-15), and Stage 4 (overs 16-20). Additionally, bowlers were partitioned into three separate types: fast bowlers, medium-fast bowlers, and spinners. Given that ordinary least squares (OLS) regression can only model the conditional mean of the response variable, we have shown the relevance of quantile regression in modeling the entire spectrum of the distribution of the response variable. In order to alleviate other effects, like environmental conditions and ground effects, the percentage of runs conceded per over has been used as the response variable, instead of simply runs per over.

### Findings

Relative to Stage 3, bowlers have conceded more runs per over in Stage 1, and this difference appears to be decreasing with the quantile level of the response variable. Similarly, in Stage 2, bowlers have conceded fewer runs per over than in Stage 3, and this difference is increasing with the quantile level of the runs conceded per over. When compared to Stage 3, bowlers have conceded more runs per over in Stage 4, and this difference is more pronounced in the upper quantiles. With respect to Bowling Styles, when compared to medium-fast bowlers, spinners have conceded fewer runs per over, and this disparity is more visible for quantiles in the middle range. There is no significant difference between the number of runs conceded per over for fast bowlers when compared to medium-fast bowlers. Based on the results from the individual country models, it is noted that these patterns are consistent for most of the International Cricket Council (ICC) teams, but with a few exceptions.




