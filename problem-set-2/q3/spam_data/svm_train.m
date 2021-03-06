% Before using this method, set num_train to be the number of training
% examples you wish to read.

num_train = 1400;

[sparseTrainMatrix, tokenlist, trainCategory] = ...
    readMatrix(sprintf('MATRIX.TRAIN.%d', num_train));

% Make y be a vector of +/-1 labels and X be a {0, 1} matrix.
ytrain = (2 * trainCategory - 1)';
Xtrain = full(1.0 * (sparseTrainMatrix > 0));

numTrainDocs = size(Xtrain, 1);
numTokens = size(Xtrain, 2);

% Xtrain is a (numTrainDocs x numTokens) sparse matrix.
% Each row represents a unique document (email).
% The j-th column of the row $i$ represents if the j-th token appears in
% email i.

% tokenlist is a long string containing the list of all tokens (words).
% These tokens are easily known by position in the file TOKENS_LIST

% trainCategory is a (1 x numTrainDocs) vector containing the true 
% classifications for the documents just read in. The i-th entry gives the 
% correct class for the i-th email (which corresponds to the i-th row in 
% the document word matrix).

% Spam documents are indicated as class 1, and non-spam as class 0.
% For the SVM, we convert these to +1 and -1 to form the numTrainDocs x 1
% vector ytrain.

%  Implement stochastic gradient descent to update the parameter vector
%  average_alpha
%   > Update all elements of alpha simultaneously against 
%     one training example.
%  Define rbf bandwidth, learning rate, and regularization
%  hyperparameters first.

average_alpha = zeros(numTrainDocs, 1);
tau = 8;
lambda = 1./(64.*numTrainDocs);
% The learning rate is such that at iteration t of stochastic gradient
% descent we use rate 1./sqrt(t)
K = rbf_kernel(Xtrain, tau);

for t = 1:40*numTrainDocs
   ix = randi([1, numTrainDocs], 1, 1);
   learning_rate = 1./sqrt(t);
   Ki = K(ix, :); % Vector of example ix's similarities to other examples
   yi = ytrain(ix);
   average_alpha = average_alpha - learning_rate.*cost_gradient(average_alpha, K, Ki, yi, lambda);
end

