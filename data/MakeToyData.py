import argparse
import numpy as np

def arr2Rstr(arr):
    if arr.dtype == np.float:
        fmt = "%.6e"
    else:
        fmt = "%d"
    return "c(" + ",".join([fmt % (a) for a in arr]) + ")"

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--N", type=int, default=50)
    parser.add_argument("--K", type=int, default=7)
    parser.add_argument("--alpha", type=float, default=1.0)
    parser.add_argument("--pi_K", type=str, default="0.3,0.2,0.1,0.1,0.1,0.1,0.1")
    parser.add_argument("--seed", type=int, default=424242)
    args = parser.parse_args()
    # Dump parsed args into local namespace
    locals().update(args.__dict__)

    pi_K = np.asarray([float(x) for x in pi_K.split(",")])
    pi_K /= np.sum(pi_K)
    K = pi_K.size

    PRNG = np.random.RandomState(seed=seed)
    z_N = np.zeros(N, dtype=np.int32)
    for n in range(N):
        z_N[n] = PRNG.choice(K, p=pi_K)
    z_N += 1 # make it one-based indexing

    alpha_K = alpha / K * np.ones(K)

    #print "# True pi vector"
    print "pi_K <- %s" % (arr2Rstr(pi_K))
    #print "# Hyperparameters for Dir model"
    #print "# pi_K ~ Dir(alpha/K, alpha/K, ... alpha/K)"
    print "alpha_K <- %s" % (arr2Rstr(alpha_K))
    #print "# Hyperparameters for LSB model"
    print "sigma <- 1"
    #print "# Hyperparameters for hierarchical LSB model"
    print "a <- 0.001"
    print "b <- 0.001"
    #print "# Observed count data"
    print "N <- %d" % (N)
    print "K <- %d" % (K)
    print "z_N <- %s" % (arr2Rstr(z_N))
