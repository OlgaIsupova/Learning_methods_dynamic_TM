# Learning_methods_dynamic_TM
Code for the models introduced in the paper "Learning Methods for Dynamic Topic Modeling in Automated Behavior Analysis" by Olga Isupova, Danil Kuzin, Lyudmila Mihaylova. Published in [IEEE Transactions on Neural Networks and Learning Systems, 2017](http://ieeexplore.ieee.org/document/8052214/?denied)

Two learning methods for the Markov Clustering Topic Model (MCTM) are developed - Expectation-Maximisation (EM) algorithm and Variational Bayes (VB) inference.
Implementation is done in Matlab.

## Getting started
### EM
1. Run em_path_add.m to add to matlab path everything required to run EM-algorithm on data
2. Run ./EM_inference_for_MCTM/EM_MCTM.m to obtain estimates of the parameters by the EM-algorithm on training data:
      
      em_estimates = EM_MCTM(train_data, param);
   
   Please refer to comments in EM_MCTM.m for details of arguments of the function.
3. Run ./Anomaly_detection/Calculate_saliency_for_test_data.m to compute normality measure on test data:
      
      em_normality_measure_values = Calculate_saliency_for_test_data(test_data, em_estimates);
   
   where em_estimates is the output of the EM_MCTM. Please refer to comment in Calculate_saliency_for_test_data for details of the format of test_data
   
### VB
1. Run vb_path_add.m to add to matlab path everything required to run VB-algorithm on data
2. Run ./VB_inference_for_MCTM/VB_MCTM.m to obtain estimates of the hyperparameters by the VB-algorithm on training data:
      
      vb_hyperparameter_estimates = VB_MCTM(train_data, param);
   
   Please refer to comments in VB_MCTM.m for details of arguments of the function.
3. Run ./VB_inference_for_MCTM/Calculate_vb_parameter_estimates.m to obtain point estimates of the parameters from the computed estimates of the hyperparameters by the VB-algorithm (for plug-in approximation of the log likelihood of test data):
   
      vb_estimates = Calculate_vb_parameter_estimates(vb_hyperparameter_estimates);
   
   Or
   
   Run ./VB_inference_for_MCTM/Generate_random_samples_of_distributions.m to obtain samples from the posterior distributions of the parameters based on the computed estimates of the hyperparameters by the VB-algorithm (for Monte Carlo approximation of the log likelihood of test data):
      
      vb_estimates = Generate_random_samples_of_distributions(vb_hyperparameter_estimates, number_of_samples);
   
   where vb_hyperparameter_estimates is the output of the VB_MCTM.
4. Run ./Anomaly_detection/Calculate_saliency_for_test_data.m to compute normality measure on test data:
      
      vb_normality_measure_values = Calculate_saliency_for_test_data(test_data, vb_estimates);
   
   where vb_estimates are obtained either from Calculate_vb_parameter_estimates or Generate_random_samples_of_distributions. Please refer to comment in Calculate_saliency_for_test_data for details of the format of test_data
