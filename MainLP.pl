unificareTermeni(JSParamInput, Propozitie, JSDataKB, NRTermeniLipsea) :- 
    
.

% analizam json-ul primit
analyseData(JSDataInput, JSDataKB) :-
    get_dict(actiune, JSData, Actiune), % obtinem actiunea
    get_dict(parametrii, JSData, Parametrii), % obtinem parametrii
    get_dict(propozitie, JSData, Propozitie), % obtinem propozitie
.

% read json data
readJson(InputFile, JSData) :-
    use_module(library(http/json)),
    open(InputFile, read, Stream), 
    json_read_dict(Stream, JSData)
.

% entryPoint
entryPoint(H) :-
    readJson("./Input.txt", _), % citi
    readJson("./KBase.txt", JSDataKB),
    analyseData(JSData, JSDataKB)
.