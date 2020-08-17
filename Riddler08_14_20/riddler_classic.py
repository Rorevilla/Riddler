import numpy as np
import pandas as pd

lengths = []
df = pd.DataFrame(columns = ["n1", "n2","n3","n4","n5"])

for i in range(500):

    print(i)
    cuts = np.random.uniform(low=0,high=12,size=3)
    cuts.sort()
    idx = (np.abs(cuts-6)).argmin()

    if cuts[idx] > 6:
        if idx == 0:
            length = cuts[idx]
        else:
            length = cuts[idx] - cuts[idx-1]
    else:
        if idx == len(cuts)-1:
            length = 12 - cuts[idx]
        else:
            length = cuts[idx+1] - cuts[idx]

    cuts = cuts.tolist()
    cuts.insert(0,0)
    cuts.insert(4,12)
    df.loc[len(df)] = cuts
    
    lengths.append(length)

df.to_csv("ruler_cuts.csv")
print(np.mean(lengths))
print(df)


