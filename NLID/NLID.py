from shutil import copyfile
from datetime import datetime
import os, json

from .KernelModule.PrologWrapper import PrologWrapper
from .IntentProcessing.CheckValues import checkValues, validateAgInput
from .InteractData.EventAuth import EventAuth
from .InteractData import EventFormat

INPUT_PATH = './NLID/KernelModule/Input.txt'

def start():
    # adaugam date to google API
    gAPI = EventAuth()
    serviceAPI = gAPI.getService()

    while(True):
        # copiem fisierul de input pentru kernel
        if os.path.exists('./Input.txt'):
            copyfile('./Input.txt', INPUT_PATH)
        else:
            print('No input detected!')
            return

        # citim datele initiale
        fContent = open(INPUT_PATH).read()
        fDir = json.loads(fContent)

        # prolog processing
        adProlog = PrologWrapper()
        result = adProlog.interact()

        # obtinem match-ul de la prolog
        isValid = checkValues(result)

        checkResult = validateAgInput(fDir, result)
        
        print("Primite: ", str(result))
        if checkResult is not True:
            # se cere reformularea propozitiei de la cuvantul malformat incolo
            print("Posibila intrebare: ", str(checkResult))
        else:
            # restragem rezultatele
            print("Posibila intrebare: ", str(isValid))

            # asteptam dupa input
            input()

            if fDir["actiune"] == "adaugaEvent":
                timeStart = timeEnd = None
                if 'ora_inceput' in result.keys():
                    timeStart = result['ora_inceput']
                if 'ora_final' in result.keys():
                    timeEnd = result['ora_final']

                print(result['data'], timeStart, timeEnd)
                event = EventFormat.getEventFormat(
                    name = result['event'],
                    data = result['data'],
                    timeStart = timeStart, 
                    timeEnd = timeEnd
                )
                results = serviceAPI.events().insert(calendarId='primary', body=event).execute()
                print(results)

        # trecem la urmatoarea procesare
        input()
