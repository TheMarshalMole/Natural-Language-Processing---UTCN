import os, re

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
        return "REFORMULARE [ALL]"
    elif sizeMissing >= 1:
        return "ASK_DEFAULT {}".format(missingTerms[0:1])
    
    # success
    return None

"""
    @detalii: verificam daca output-ul este bun in raport cu input-ul
"""
def validateAgInput(inputData, outputData):
    propozitie = inputData['parametrii']['propozitie']

    # parsam input-ul
    inputKeys = re.findall(r"@\[[A-Za-z0-9_]+\]", propozitie)

    # verificam daca contine erori
    for key in outputData.keys():
        if key.startswith('ERROR'):
            return "REFORMULARE [ALL]"

    # verificam daca input-ul este egal cu dictionarul din prolog
    for value in inputKeys:
        value = value[2:-1]
        if value not in outputData.keys():
            return "REFORMULATE [{}]".format(value)

    return True