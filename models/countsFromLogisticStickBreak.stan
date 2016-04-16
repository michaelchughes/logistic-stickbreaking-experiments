data {
    int<lower=1> K; 
    int<lower=0> N; 
    real<lower=0> sigma;
    int<lower=0> z_N[N];
}

parameters {
    vector[K-1] realv_K;
}

transformed parameters {
    real unitv_K[K-1];
    vector[K] pi_K;

    for (k in 1:K-1) {
        unitv_K[k] <- inv_logit(realv_K[k]);
    }

    pi_K[K] <- 1.0;
    for (k in 1:K-1) {
        pi_K[k] <- unitv_K[k] * pi_K[K];
        pi_K[K] <- pi_K[K] - pi_K[k];
    }
}

model {
    for (k in 1:K-1) 
        realv_K[k] ~ normal(0, sigma);
    for (n in 1:N) 
        z_N[n] ~ categorical(pi_K);
}
