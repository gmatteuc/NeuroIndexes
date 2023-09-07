# Neuroindexes

Giulio's personal neural data analysis toolkit.

This repository is intended as a streamlined toolkit for neural data analysis in Matlab, providing functions and example scripts for exploring and quantifying neural and behavioral data. The toolkit was born out of a recurring need in my work to perform similar types of analyses across various projects and datasets. To address this, I've created a small library of functions and scripts that not only provide the necessary code to run these 'primitive' analyses but also offer annotated examples of how to use them in practice. It also provides open-access functions for calculating various neuronal selectivity indices, frequently requested by peers. While this toolkit is an ongoing side project with no claims of being comprehensive, it aims to evolve over time into a robust library of clear, reusable, and efficient code for the visualization, exploration, and statistical quantification of neuroscientific data.

---

## Repository Contents

#### 1. Comparing medians of distributions
- Functions and scripts for robustly comparing the medians of different distributions, a recurring need in neuroscience projects.
- **Status**: OK (Complete)

#### 2. Comparing psychometric curves
- Tools for comparing psychometric curves, including example scripts.
- **Status**: TODO (Incomplete)

#### 3. Computing pattern and component index
- A working set of scripts and functions to compute "pattern" and "component" indices, essential for quantifying a neuron's type of visual motion selectivity.
- **Status**: OK (Complete)

#### 4. Computing phase modulation index
- Scripts and functions for computing a phase modulation index, useful for categorizing a visual neuron as either "simple" or "complex."
- **Status**: OK (Complete)

#### 5. Computing pre-lick modulation index
- Scripts and functions for computing a pre-lick (or pre-action) modulation index, useful for quantifying sensory neurons' modulations by upcoming motor actions.
- **Status**: TODO (Incomplete)

#### 6. Computing visual selectivity indexes
- A suite of functions for computing various common visual selectivity indices.
- **Status**: TODO (Incomplete)

#### 7. Converting p-values to ci and back
- Functions for converting p-values to confidence intervals and vice versa, assuming normality.
- **Status**: OK (Complete)
  
#### 8. Inspecting correlation of distributions
- Tools for examining correlations across different bivariate distributions, another recurring need in neuroscience.
- **Status**: OK (Complete)
  
#### 9. Inspecting visual neuron responses
- Scripts and functions for inspecting and preprocessing visual neuron responses in experiments involving grating and sparse noise stimuli.
- **Status**: TODO (Incomplete)

#### 10. Computing spike triggered average
- Scripts and functions for computing a z-scored spike-triggered average from dense noise responses.
- **Status**: TODO (Incomplete)

---

Code written and tested in MATLAB R2023a.

Giulio Matteucci 2023.

