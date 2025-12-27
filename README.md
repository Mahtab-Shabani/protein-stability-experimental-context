# protein-stability-experimental-context

# protein-stability-experimental-context

## Dataset Description <br />
This project uses  ``` FireProtDB ``` , a comprehensive and manually curated database of protein stability data for single-point mutations. <br />

#### 📥 How to download FireProtDB data <br />
The FireProtDB dataset can be downloaded from: https://loschmidt.chemi.muni.cz/fireprotdb/download/ (download  ``` CSV Export ```.)  <br />
Because ``` CSV Export ```  is too big (1.65 GB), we shrunk it to a small version by  ``` shrink.m ``` , and the first 50,000 records were selected instead of processing the entire database. The resulting dataset  ``` (FireProtDB_small.csv) ```  represents a compact yet biologically meaningful subset of the original database. <br />
### Dataset Features <br />
The final dataset contains the following variables: <br />
| Feature | Description |
|--------|------------|
| PROTEIN | Identifier of the mutated protein |
| ORGANISM | Source organism of the protein |
| ΔΔG (DDG) | Change in Gibbs free energy upon mutation (kcal/mol), used as the primary stability metric |
| TM | Melting temperature of the protein (°C), when available |
| PH | Experimental pH at which ΔΔG was measured |
| METHOD | Experimental technique used to measure stability |  <br />

Only single-point mutations with valid ΔΔG measurements were retained. ΔΔG values were later used both as a continuous target (regression) and as a binary label (stabilizing vs. destabilizing mutations). <br />

### Rationale for feature selection <br />
The selected features reflect the multiparametric nature of protein stability measurements. The changes in stability are due not only to the sequence alterations but also to the different experimental variables, including pH, temperature, organism, and the measurement technique used. <br />
This design meets the primary aim of the project, which is to determine the extent to which the different experimental variables affect the variability of protein stability measurements, and the potential and constraints of data-driven approaches to model enzymes iteratively. <br />

## Data cleaning and curation <br />
Because of FireProtDB's heterogeneous provenance, important experimental values like ΔΔG, melting temperature (TM), and pH are not kept in a coherent numeric format, and they may contain missing or non-numeric values. These types of inconsistencies block statistical and machine learning analyses from being executed. <br />
To resolve this kind of problem, a specialized cleaning step was applied to achieve uniform numerical coherence throughout all quantitative features. All thermodynamic variable (ΔΔG, TM, pH) were securely and safely converted to numerical form, and entries without valid ΔΔG measurement were eliminated, as ΔΔG is the main variable of interest of this study. <br />
After cleaning, the dataset was reduced from 4,420 extracted records to 598 high-quality entries. Although this represents a substantial reduction in size, it reflects the limited availability of complete and experimentally consistent stability measurements, a common challenge in data-driven protein engineering. <br />

## ΔΔG filtering and physical sanity check <br />
Prior to downstream analysis, a physical sanity check was applied to remove ΔΔG values outside a realistic thermodynamic range. Only mutations with ΔΔG values between −20 and +20 kcal/mol were retained. This is because values outside the range highly are not likely to be meaningful, reflect a single mutation which may be the result of a physical experimental error or be the result of error in an annotation.  <br />
The filtering step resulted in a set containing 317 mutations which have plausible stability changes. The resulting ΔΔG distribution was examined using summary statistics and histogram visualization to confirm its suitability for statistical analysis and machine learning. <br />

<img width="500" alt="image" src="https://github.com/user-attachments/assets/5b1ed816-0931-4483-a2af-44c547b65053" />

## Exploratory analysis of protein stability <br />
After the physical filtering, an exploratory analysis was performed to characterize the stability landscape of the selected mutations.<br />
Mutations were first categorized into stabilizing (ΔΔG < 0) and destabilizing (ΔΔG > 0) classes, allowing the continuous thermodynamic signal to be interpreted in biologically meaningful terms. The resulting class distribution reveals a strong imbalance toward destabilizing mutations, consistent with known trends in protein stability experiments.<br />
Approximately 90% of the analyzed variants exhibit positive ΔΔG values, highlighting an intrinsic bias in protein stability datasets and posing an important challenge for downstream machine learning models. <br />

#### Figure – Distribution of stabilizing and destabilizing mutations <br />
A strong imbalance toward destabilizing mutations is observed, reflecting the intrinsic bias of protein stability datasets. <br />
<img width="500"  alt="image" src="https://github.com/user-attachments/assets/82e26d09-e2fd-48a6-bfc1-c477b0ebdf8d" />

## Effect of experimental methodology on ΔΔG variability <br />
The influence of experimental methodology on ΔΔG variability was further examined. For each experimental technique with sufficient sample size, the mean and standard deviation of ΔΔG were computed. <br />
This analysis demonstrates that ΔΔG measurements are not solely mutation-dependent but are also sensitive to experimental conditions, underscoring the importance of incorporating methodological and environmental metadata in data-driven protein stability models. <br />

<img width="600" alt="image" src="https://github.com/user-attachments/assets/641706b8-523a-477e-8194-d2380e6ec089" />
<img width="600"  alt="image" src="https://github.com/user-attachments/assets/6ab52536-c29d-44ef-b1a6-69cb08fce2e4" />

## Regression Analysis: Predicting ΔΔG as a Continuous Variable <br />
As a baseline regression task, a simple linear model was trained to predict ΔΔG as a continuous variable. The feature set consisted of coarse experimental indicators, including organism identity and the availability of experimental conditions (pH and melting temperature), rather than detailed sequence or structural descriptors. <br />
 <br />
 Despite its simplicity, the model achieved an RMSE of 3.19 kcal/mol, which falls within the typical experimental noise range reported for ΔΔG measurements. This result suggests that even minimal experimental context contains meaningful predictive signal for protein stability changes. <br />

## Binary Classification: Stabilizing vs. Destabilizing Mutations <br />
In many protein engineering applications, the exact ΔΔG value is less critical than the qualitative distinction between stabilizing and destabilizing mutations. <br />
### Class Imbalance Handling <br />
Due to the strong class imbalance, stabilizing mutations were oversampled to create a balanced training dataset prior to model fitting. <br />
### Logistic Regression Results <br />
The logistic regression model achieved an accuracy of 92.51%, with a recall of 1.0 for stabilizing mutations. This indicates that the model successfully identifies all stabilizing variants in the test set, albeit at the cost of some false positives. <br />

## Decision Tree: Interpretability over performance <br />
A decision tree classifier was trained on the same feature set to enhance interpretability. The resulting tree revealed a few dominant decision rules, mostly related to organism identity and experimental conditions, and achieved perfect accuracy on the test set. <br />
 <br />
Despite the high apparent performance, the tree's shallow structure and small feature space point to possible overfitting, underscoring the necessity of validation on separate datasets. <br />
According to the learned decision tree, stability classification is heavily influenced by experimental context variables (such as organism and pH), frequently surpassing the direct thermodynamic signal. This finding supports the use of experimental metadata in data-driven protein engineering pipelines and highlights the multiparametric character of protein stability measurements. <br />

<img width="550" alt="image" src="https://github.com/user-attachments/assets/54a360e1-263d-4622-a359-4bad9df47dbc" />

## Limitations <br />
This study is limited by the absence of sequence- and structure-level features, such as residue identity, solvent accessibility, or predicted structural effects. Furthermore, even after strict filtering, the dataset size is still small, and experimental heterogeneity adds noise that basic models are unable to adequately capture. <br />

## How to improve <br />
Future studies may involve constructing more complex machine learning models using sequence embeddings or structural representations (i.e., AlphaFold) and exploring all combinations of varying (i.e., temporal) experimental parameter values. Validation on newly generated experimental data, as planned within collaborative protein engineering projects, would further improve model robustness and practical applicability. <br />

Dependency
------------
This code is implemented purely in Matlab2014a and doesn't depends on any other toolbox.

