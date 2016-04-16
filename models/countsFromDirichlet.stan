data {
  int<lower=1> K; 
  int<lower=0> N; 
  vector[K] alpha_K;
  int<lower=0> z_N[N];
}

parameters {
  simplex[K] pi_K;
}

model {
  pi_K ~ dirichlet(alpha_K);
  for (n in 1:N) 
    z_N[n] ~ categorical(pi_K);
}
