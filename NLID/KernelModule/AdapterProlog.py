#!/usr/bin/env python3
from pyswip import Prolog # pentru a putea folosi python si prolog
import os
class AdapterProlog():
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
        _ = self.__prologModule.query('entryPoint(_)')