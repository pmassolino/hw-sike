################################################################################
##
# This script is an adaptation of the Magma script optimalstrategies.mag with
# the following copyright. Obtained from https://github.com/Microsoft/PQCrypto-SIDH
# This code also has an extra function not in the original code to transform the
# the Splits into a different format.
##
################################################################################
#                                                               
# Efficient algorithms for supersingular isogeny Diffie-Hellman 
# Craig Costello, Patrick Longa, Michael Naehrig, 2016         
# (c) 2016 Microsoft Corporation. All rights reserved.         
#                                                               
###############################################################################
##

base = 10.0
difference = 0

def NextCpq (p,q,Cpq,PQcounts):
###
# Computes the cost of an optimal strategy for traversing a tree on n leaves
# together with the operation counts in terms of scalar multiplications and 
# isogeny evaluation, given this information for trees on 1 up to n-1 leaves.
# 
# Input: 
# - The cost p for a scalar multiplication by \ell,
# - the cost q for the evaluation of an \ell-isogeny,
# - a list Cpq of length n-1 that contains the cost of an optimal strategy 
#   for traversal of a tree with i leaves in Cpq[i], and 
# - a list PQcounts of pairs such that the i-th pair contains the number 
#   PQcounts[i][1] of \ell-scalar multiplications and the number 
#   PQcounts[i][2] of \ell-isogeny evaluations in order to traverse a tree 
#   on i leaves using the optimal strategy with cost Cpq[i]. 
# 
# Output: 
# - The cost newCpq of an optimal strategy for traversing a tree on n leaves, 
# - the corresponding operation counts newPQcount, and 
# - the splitting newSpq of the n-node strategy into two optimal 
#   sub-strategies.
###

    pgtq = p > q;  
    n = len(Cpq);
    newCpqs = [(Cpq[i] + Cpq[n-i-1] + ((n-i)*p + (i+1)*q)) for i in range(0,n)];  
    
    newCpq = newCpqs[0];
    m = 0;
    ## Choose the cheapest strategy.
    for i in range(1,n):
        tmpCpq = newCpqs[i]; 
        if((newCpq - tmpCpq) >= (difference)): 
        ## including equality in the condition prefers larger number of isogenies
            newCpq = tmpCpq;
            m = i;
    ## chosen strategy (m-leave sub-tree on the left, (n-m)-subtree on the right) 
    newSpq = [m+1,n-m]; 
    ## updating operation counts
    newPQcount = [PQcounts[m][0] + PQcounts[n-m-1][0] + (n-m), PQcounts[m][1] + PQcounts[n-m-1][1] + m + 1]; 
    
    return newCpq, newSpq, newPQcount;

################################################################################

def GetStrategies(n,p,q):
###
# Computes a list of optimal strategies for traversing trees with number of 
# leaves between 1 and n.
# 
# Input: 
# - The number n of leaves on the tree,
# - the cost p for scalar multiplication by \ell, and 
# - the cost q for \ell-isogeny evaluation. 
# 
# Output:
# - A list Spq of length n containing the splits into two subtrees for all
#   optimal strategies on trees with 1<=i<=n leaves.
# - A list PQcounts of length n containing operation counts for the above 
#   strategies. 
###
    assert n >= 3;
    ## Cost for sub-trees with one leaf (=0) and two leaves (p+q) 
    Cpq = [0, p+q];             

    ## Splits for these sub-trees
    Spq = [[0,0], [1,1]];
    ## Operation counts for these sub-trees
    PQcounts = [[0,0], [1,1]];
    
    ## Compute in sequence all optimal strategies for trees with 3<=i<=n leaves. 
    while((len(Cpq)) != n):
        newCpq, newSpq, newPQcount = NextCpq(p,q,Cpq,PQcounts);
        Cpq += [newCpq];
        Spq += [newSpq];
        PQcounts += [newPQcount];
        
    return Spq, PQcounts;

################################################################################

def GetSplits(n,Spq):
###
# Assembles a list of splits by taking the number of leaves in the respective
# right subtrees which is equal to the number of scalar multiplications to 
# reach the root of the next sub-strategy.
# 
# Input:
# - The number n of leaves on the tree and
# - the list of splits into two sub-trees as above.
# 
# Output:
# - A list of length n describing the splits by giving the number of scalar
#   multiplications by \ell to the root of the next subtree.
###

    return [Spq[i][1] for i in range(0,n)];

################################################################################
def GenerateStrategiesAndSplits(nA, pA, qA, nB, pB, qB):

    SpqA, PQcountsA = GetStrategies(nA,pA,qA); 
    TopStrategyA = SpqA[nA-1]
    MultiplciationsBy4 = PQcountsA[nA-1][0]
    Isogeny4Evaluation = PQcountsA[nA-1][1]
    TotalCallsA = (PQcountsA[nA-1][0]*pA + PQcountsA[nA-1][1]*qA)/base
    SplitsA = GetSplits(nA,SpqA)
    DirectSplitsA, MaxNptsA = ConvertSplitsFormat(nA, SplitsA)
    
    SpqB, PQcountsB = GetStrategies(nB,pB,qB); 
    TopStrategyB = SpqB[nB-1]
    MultiplciationsBy3 = PQcountsB[nB-1][0]
    Isogeny3Evaluation = PQcountsB[nB-1][1]
    TotalCallsB = (PQcountsB[nB-1][0]*pB + PQcountsB[nB-1][1]*qB)/base
    SplitsB = GetSplits(nB,SpqB)
    DirectSplitsB, MaxNptsB = ConvertSplitsFormat(nB, SplitsB)
    
    print("");
    print("Top Strategy for A:" + str(TopStrategyA));
    print(str(MultiplciationsBy4) + " MUL-BY-4 and " + str(Isogeny4Evaluation) + " 4-ISO-EVAL == " + str(int(TotalCallsA)) + " total units");
    print("Splits for A:" + str(SplitsA));
    print("Splits for A:" + str(DirectSplitsA));
    print("Max row A:" + str(len(DirectSplitsA)+1))
    print("Max points A:" + str(MaxNptsA))
    print("");
    print("Top Strategy for B:" + str(TopStrategyB));
    print(str(MultiplciationsBy3) + " MUL-BY-3 and " +str(Isogeny3Evaluation) + " 3-ISO-EVAL == " + str(int(TotalCallsB)) + " total units");
    print("Splits for B:" + str(SplitsB));
    print("Splits for B:" + str(DirectSplitsB));
    print("Max row B:" + str(len(DirectSplitsB)+1))
    print("Max points B:" + str(MaxNptsB))
    print("");

################################################################################

####
# This part of the code was not obtained from optimalstrategies.mag
####
def ConvertSplitsFormat(n, splits):
    direct_splits = [0 for i in range(len(splits))]
    max_npts = 0
    pts_index = [0 for i in range(20)]
    npts = 0
    index = 0
    ii = 0
    for row in range(1,n):
        while (index < n-row):
            pts_index[npts] = index;
            npts += 1
            m = splits[n-index-row]
            direct_splits[ii] = m
            ii += 1
            index += m
            if(max_npts < npts):
                max_npts = npts
            
        index = pts_index[npts-1];
        npts -= 1;
    return direct_splits[:-1], max_npts

# For p16
nA = 4;            # Computing 4^nA-isogenies
pA = 2*392;        # Cost for 2 doublings
qA = 502;          # Cost for 4-isogeny evaluation
                    
nB = 5;            # Computing 3^nB-isogenies
pB = 756;          # Cost for tripling
qB = 375;          # Cost for 3-isogeny evaluation

# Multiply by the base in order to align it.
pA *= base         
qA *= base         
pB *= base         
qB *= base         

GenerateStrategiesAndSplits(nA, pA, qA, nB, pB, qB)

# For p434
nA = 108;          # Computing 4^nA-isogenies
pA = 2*392;        # Cost for 2 doublings
qA = 502;          # Cost for 4-isogeny evaluation
                    
nB = 137;          # Computing 3^nB-isogenies
pB = 756;          # Cost for tripling
qB = 375;          # Cost for 3-isogeny evaluation

# Multiply by the base in order to align it.
pA *= base         
qA *= base         
pB *= base         
qB *= base         

GenerateStrategiesAndSplits(nA, pA, qA, nB, pB, qB)

# For p503
nA = 125;          # Computing 4^nA-isogenies
pA = 2*392;        # Cost for 2 doublings
qA = 502;          # Cost for 4-isogeny evaluation
                    
nB = 159;          # Computing 3^nB-isogenies
pB = 756;          # Cost for tripling
qB = 375;          # Cost for 3-isogeny evaluation

# Multiply by the base in order to align it.
pA *= base         
qA *= base         
pB *= base         
qB *= base         

GenerateStrategiesAndSplits(nA, pA, qA, nB, pB, qB)

# For p751
nA = 186;          # Computing 4^nA-isogenies
pA = 2*536;        # Cost for 2 doublings
qA = 690;          # Cost for 4-isogeny evaluation
                    
nB = 239;          # Computing 3^nB-isogenies
pB = 1040;         # Cost for tripling
qB = 515;          # Cost for 3-isogeny evaluation

# Multiply by the base in order to align it.
pA *= base         
qA *= base         
pB *= base         
qB *= base         

GenerateStrategiesAndSplits(nA, pA, qA, nB, pB, qB)

# For p964
nA = 243;          # Computing 4^nA-isogenies
pA = 2*872;        # Cost for 2 doublings
qA = 1134;         # Cost for 4-isogeny evaluation
                    
nB = 301;          # Computing 3^nB-isogenies
pB = 1708;         # Cost for tripling
qB = 847;          # Cost for 3-isogeny evaluation

# Multiply by the base in order to align it.
pA *= base         
qA *= base         
pB *= base         
qB *= base         

GenerateStrategiesAndSplits(nA, pA, qA, nB, pB, qB)