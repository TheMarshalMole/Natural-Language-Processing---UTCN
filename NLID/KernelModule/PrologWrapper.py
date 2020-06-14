#!/usr/bin/env python3
from pyswip import Prolog # pentru a putea folosi python si prolog
from .ErrorCodes import ERROR_CODES

import os, re

class PrologWrapper():
    def __init__(self, fileName = "MainLP.pl"):
        self.__fileName = fileName

        pathFile = "{}/NLID/KernelModule/{}".format(os.getcwd(), fileName)
        self.__prologModule = Prolog()
        self.__prologModule.consult(pathFile)
    
    """
        @detalii: interact will execute the entryPoint in prolog
        script
        @parameters: None
        @returns: results(dict) - result of the prolog
    """
    def interact(self):
        result = self.__prologModule.query("entryPoint(OutputDict)")
        result = list(result)[0]['OutputDict']

        dictResult = {}
        values = re.findall(r"\'[^\']*\'", result)
        keys = re.findall(r"\[([A-Za-z0-9_]+)\]", result)
    
        for i in range(len(keys)):
            # add error value
            if keys[i].startswith("ERROR_"):
                dictResult[keys[i]] = "{}/{}".format(ERROR_CODES[keys[i]], values[i][1:])
            dictResult[keys[i]] = values[i][1:-1]

        return dictResult
    
    def rawInteract(self):
        result = self.__prologModule.query("entryPoint(OutputDict)")
        result = list(result)[0]['OutputDict']

        return result