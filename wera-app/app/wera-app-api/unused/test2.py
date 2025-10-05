holder=[]
holder.append(("Test", "None", "A"))
holder.append(("Test2", "None", "None"))
holder.append(("Test3", "None", "None"))
holder.append(("Test3", "None", "None"))
holder.append(("Test4", "None", "None"))
holder.append(("Test", "None", "B"))

print(holder)
#indices=[i for i, v in enumerate(holder) if str(v[4]) == "None"]
holder=[holder for holder in holder if holder[2] != "None"]
#print(indices)
#for i in indices:
#    holder.pop(i)
#del holder[indices]
print(holder)