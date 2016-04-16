data {
    int<lower=1> K; 
    int<lower=0> N; 
    int<lower=0> z_N[N];
    real<lower=0> a;
    real<lower=0> b;
}

parameters {
    real<lower=0> lambda;   
    vector[K-1] realv_Km1;
}

transformed parameters {
    real mu_Km1[K-1];
    real unitv_Km1[K-1];
    vector[K] pi_K;

    // Effective mean of pi(v) is [1/K, 1/K, ... 1/K]
    for (k in 1:K-1) {
        mu_Km1[k] <- logit( 1.0 / (K - k + 1.0) );
    }

    for (k in 1:K-1) {
        unitv_Km1[k] <- inv_logit(realv_Km1[k]);
    }

    pi_K[K] <- 1.0;
    for (k in 1:K-1) {
        pi_K[k] <- unitv_Km1[k] * pi_K[K];
        pi_K[K] <- pi_K[K] - pi_K[k];
    }
}

model {
    lambda ~ gamma(a, b);
    for (k in 1:K-1) 
        realv_Km1[k] ~ normal(mu_Km1[k], 1.0/sqrt(lambda));
    for (n in 1:N) 
        z_N[n] ~ categorical(pi_K);
}
