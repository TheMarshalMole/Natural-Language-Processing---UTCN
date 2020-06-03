from .KernelModule.PrologWrapper import PrologWrapper
from .IntentProcessing.CheckValues import checkValues

def start():
    adProlog = PrologWrapper()
    result = adProlog.interact()

    isValid = checkValues(result)
    # restragem rezultatele
    print(isValid)