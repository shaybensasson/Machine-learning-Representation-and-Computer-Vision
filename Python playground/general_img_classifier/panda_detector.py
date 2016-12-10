import numpy as np
import visual_bow as bow
from sklearn.cluster import MiniBatchKMeans
from sklearn.svm import SVC
from sklearn.grid_search import GridSearchCV
from sklearn.ensemble import AdaBoostClassifier
from sklearn.externals import joblib
import glob
import random
import warnings

SCORING = 'f1_micro'
print 'Scoring grid search with metric: %s' % SCORING

# Get all possible negative images and label them False
positive_folder='panda'
all_negs = [(path, False) for path in bow.neg_img_cal101(positive_folder)]
print '%i total negative imgs to choose from' % len(all_negs)
print all_negs[:5]

# Get all the positive images you have (in the panda_rip folder) and label them True
positive_imgs = [(path, True) for path in glob.glob('panda_rip/*')]
print '%i positive images' % len(positive_imgs)
print positive_imgs[:5]

# take N random negative images, where N is no of positive images
# then concatenate N pos + N neg and shuffle.
chosen_negs = random.sample(all_negs, len(positive_imgs))
imgs = chosen_negs + positive_imgs

np.random.shuffle(imgs)

print '%i total images (1:1 positive:negative)' % len(imgs)
print imgs[:5]


img_descs, y = bow.gen_sift_features(imgs)

# generate indexes for train/test/val split
training_idxs, test_idxs, val_idxs = bow.train_test_val_split_idxs(
    total_rows=len(imgs),
    percent_test=0.15,
    percent_val=0.15
)

# Cluster the SIFT descriptors

K_CLUSTERS = 250

# MiniBatchKMeans annoyingly throws tons of deprecation warnings that fill up the notebook. Ignore them.
warnings.filterwarnings('ignore')

X, cluster_model = bow.cluster_features(
    img_descs,
    training_idxs=training_idxs,
    cluster_model=MiniBatchKMeans(n_clusters=K_CLUSTERS)
)

warnings.filterwarnings('default')

X_train, X_test, X_val, y_train, y_test, y_val = bow.perform_data_split(X, y, training_idxs, test_idxs, val_idxs)

# Classify with svm

# c_vals = [0.0001, 0.01, 0.1, 1, 10, 100, 1000]
#c_vals = [0.1, 1, 5, 10]
c_vals = [10]

#gamma_vals = [0.5, 0.1, 0.01, 0.0001, 0.00001]
# gamma_vals = [0.5, 0.1]
# gamma_vals = [0.1]
gamma_vals = [0.0001]

param_grid = [
  #{'C': c_vals, 'kernel': ['linear']},
  {'C': c_vals, 'gamma': gamma_vals, 'kernel': ['rbf']},
 ]

svc = GridSearchCV(SVC(), param_grid, n_jobs=-1, scoring=SCORING)
svc.fit(X_train, y_train)
print 'train score (%s):'%SCORING, svc.score(X_train, y_train)
print 'test score (%s):'%SCORING, svc.score(X_test, y_test)

print svc.best_estimator_


# We have our estimator, this is how it could classify random pictures
for img_path, label in random.sample(all_negs, 10):
    print img_path, svc.predict(bow.img_to_vect(img_path, cluster_model))