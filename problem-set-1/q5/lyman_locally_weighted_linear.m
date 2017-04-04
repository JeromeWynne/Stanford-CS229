% A larger tau value resulted in a flatter allocation of weights among
% adjacent points, meaning that the 'local' fit was heavily influenced
% by points that were further away. This resulted in all thetas being
% similar, producing a more-or less constant-gradient result.
% This was in contrast to a small tau value, which meant that nearby points
% were weighted heavily and those further away ignored - this resulted
% in the theta reflecting the gradient in the direct neighborhood more closely.

% J = sum(w(i) * (y(i) - theta*x(i))^2 
% w(i) = exp(-(x - x(i)).^2 ./ 2*tau.^2)

[lambdas, train_qso, test_qso] = load_quasar_data();

query_x = (min(lambdas):max(lambdas))';
tau = 5;
qso_estimate = zeros(length(query_x), 1);

for i = 1:length(query_x)
    w = exp(-(query_x(i) - lambdas).^2/(2.*(tau.^2)));
    W = diag(w, 0);
    theta = (lambdas'*W*train_qso(1, :)')./(lambdas'*W*lambdas);
    qso_estimate(i) = theta*query_x(i);
end

plot(lambdas, train_qso(1, :), 'b-');
hold on
plot(query_x, qso_estimate, 'r-', 'LineWidth', 3);
    