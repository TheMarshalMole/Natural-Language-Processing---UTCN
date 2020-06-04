from .KernelModule.PrologWrapper import PrologWrapper
from .IntentProcessing.CheckValues import checkValues

def start():
    adProlog = PrologWrapper()
    result = adProlog.interact()

    isValid = checkValues(result)
    # restragem rezultatele
    print("Primite: ", str(result))
    print("Posibila intrebare: ", str(isValid))