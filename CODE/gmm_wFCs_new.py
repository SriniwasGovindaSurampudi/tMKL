import numpy as np
import sys
from scipy.io import loadmat, savemat
from sklearn import mixture
from sklearn import manifold

mat_params = loadmat('mat_params.mat')
num_comps = mat_params['num_comps'][0][0]
cv_type = mat_params['cv_type'][0]
num_init = mat_params['num_init'][0][0]
init_params = mat_params['init_params'][0]
X = mat_params['X']

gmm_params = {}

### Spectral Embedding ### 

se = manifold.SpectralEmbedding(n_components=num_comps,  
                affinity='rbf', 
                gamma=0.0042,
                random_state=None, 
                eigen_solver=None,
                n_jobs=-1)
X_new = se.fit_transform(X) # embedded wFCs
gmm_params['embedding_data'] = X_new
gmm_params['affinity_matrix'] = se.affinity_matrix_ 

### GMM ###

gmm = mixture.GaussianMixture(n_components = num_comps,
                              covariance_type = cv_type,
                              n_init = num_init,
                              max_iter = 100,
                              init_params = init_params,
                              verbose = 1)
gmm.fit(X_new)
gmm_params['soft_assigns'] = gmm.predict_proba(X_new) 
gmm_params['cluster_centers'] = gmm.means_
gmm_params['cluster_weights'] = gmm.weights_
gmm_params['cluster_covmats'] = gmm.covariances_

savemat('gmm_params.mat', gmm_params)
