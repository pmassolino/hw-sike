splits_Alice = [ 
0, 1, 1, 2, 2, 2, 3, 4, 4, 4, 4, 5, 5, 6, 7, 8, 8, 9, 8, 8, 9, 9, 9, 9, 10, 11, 
12, 12, 13, 14, 15, 16, 16, 16, 17, 17, 17, 17, 18, 17, 17, 18, 18, 17, 20, 20, 
20, 21, 21, 22, 22, 23, 22, 23, 27, 25, 27, 27, 27, 28, 30, 30, 31, 32, 32, 33, 
32, 33, 33, 33, 33, 33, 33, 35, 33, 34, 35, 34, 35, 35, 34, 35, 38, 37, 38, 38, 
38, 38, 38, 40, 38, 38, 41, 44, 40, 41, 42, 40, 41, 42, 43, 44, 45, 46, 47, 48, 
49, 49, 51, 51, 53, 51, 54, 51, 54, 57, 54, 57, 57, 57, 58, 58, 59, 60, 61, 63, 
63, 64, 64, 64, 65, 64, 64, 64, 64, 65, 65, 66, 65, 65, 66, 69, 66, 65, 66, 65, 
68, 69, 67, 68, 69, 70, 68, 69, 70, 71, 71, 71, 71, 71, 74, 74, 72, 71, 71, 76, 
76, 71, 75, 76, 77, 75, 71, 71, 82, 82, 71, 75, 77, 77, 75, 79, 77, 80, 79, 82, 
81, 82, 83, 84, 85, 86, 87, 88, 89, 87, 88, 88, 89, 88, 89, 89, 87, 89, 90, 93, 
94, 95, 90, 94, 93, 94, 95, 101, 102, 98, 99, 102, 98, 100, 101, 102, 102, 103, 
105, 106, 106, 106, 106, 108, 107, 106, 106, 107, 109, 109, 110, 111, 112, 114, 
114, 115, 116 ]

splits_Bob = [ 
0, 1, 1, 2, 2, 2, 3, 4, 4, 4, 4, 5, 5, 6, 7, 8, 8, 8, 8, 8, 9, 9, 9, 9, 10, 11, 
12, 12, 13, 14, 15, 16, 16, 17, 17, 16, 16, 17, 17, 17, 17, 20, 17, 17, 18, 19, 
20, 21, 21, 21, 21, 22, 23, 26, 26, 26, 27, 27, 28, 28, 29, 30, 31, 32, 32, 33, 
32, 32, 32, 33, 33, 33, 33, 33, 33, 33, 34, 33, 34, 35, 34, 34, 36, 36, 38, 38, 
38, 38, 38, 38, 39, 38, 39, 42, 39, 42, 41, 42, 45, 45, 45, 46, 47, 48, 47, 48, 
49, 48, 49, 49, 48, 49, 52, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 61, 62, 
63, 64, 64, 64, 64, 64, 65, 64, 64, 65, 65, 65, 65, 65, 65, 65, 67, 67, 65, 67, 
67, 65, 67, 67, 70, 67, 70, 70, 70, 70, 71, 72, 71, 72, 72, 71, 72, 73, 71, 71, 
72, 73, 74, 75, 72, 73, 78, 75, 72, 72, 78, 75, 75, 76, 78, 78, 79, 80, 81, 82, 
83, 84, 85, 86, 85, 86, 86, 87, 87, 88, 87, 92, 87, 89, 87, 86, 92, 89, 89, 87, 
92, 92, 92, 95, 103, 91, 92, 95, 103, 95, 98, 103, 98, 99, 102, 103, 104, 103, 
106, 105, 106, 106, 106, 106, 106, 109, 110, 107, 109, 110, 111, 112, 116, 119, 
115, 116, 116, 118, 119, 119, 121, 121, 121, 122, 123, 124, 125, 126, 127, 128, 
128, 128, 128, 128, 128, 129, 129, 128, 129, 130, 131, 129, 130, 131, 134, 129, 
129, 130, 129, 130, 131, 134, 130, 131, 134, 130, 131, 134, 130, 131, 133, 134, 
133, 134, 134, 136, 136, 136, 136, 137, 136, 136, 137, 136, 137 ]

MAX_Alice = 243
MAX_Bob = 301


direct_splits_Alice = [0 for i in range(len(splits_Alice))]
max_npts_Alice = 0
pts_index = [0 for i in range(20)]
npts = 0
index = 0
ii = 0
for row in range(1,MAX_Alice):
    while (index < MAX_Alice-row):
        pts_index[npts] = index;
        npts += 1
        m = splits_Alice[MAX_Alice-index-row]
        direct_splits_Alice[ii] = m
        ii += 1
        index += m
        if(max_npts_Alice < npts):
            max_npts_Alice = npts
        
    index = pts_index[npts-1];
    npts -= 1;

direct_splits_Bob = [0 for i in range(len(splits_Bob))]
max_npts_Bob = 0
pts_index = [0 for i in range(20)]
npts = 0
index = 0
ii = 0
for row in range(1,MAX_Bob):
    while (index < MAX_Bob-row):
        pts_index[npts] = index;
        npts += 1
        m = splits_Bob[MAX_Bob-index-row]
        direct_splits_Bob[ii] = m
        ii += 1
        index += m
        if(max_npts_Bob < npts):
            max_npts_Bob = npts
        
    index = pts_index[npts-1];
    npts -= 1;

print(direct_splits_Alice)
print(max_npts_Alice+1)
print('')
print(direct_splits_Bob)
print(max_npts_Bob+1)
    
