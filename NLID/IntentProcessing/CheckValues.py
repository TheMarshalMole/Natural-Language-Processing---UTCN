"""
    @detalii: o sa vedem daca datele sunt bune
"""
def checkValues(dictInput):
    missingTerms = []
    for keys in dictInput.keys():
        values = dictInput[keys]
        # este valoare default
        if values.startswith('_d'):
            # valorile sunt cheilor care au primit valori default
            missingTerms.append(keys)
    
    # daca mai mult de 2 cuvinte lipsa, se returneaza False
    sizeMissing = len(missingTerms)
    if sizeMissing >= 2:
        return "REPETA_PROP"
    elif sizeMissing >= 1:
        return "ASK_DEFAULT {}".format(missingTerms[0:1])
    
    # success
    return None
