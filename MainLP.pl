% am ajuns la final
unificareTermeni(
    _,  % dictionarul unde completam parametrii
    _,  % parcurgerea popozitiei
    [_ | JSDataKB]   % knowledge base-ul
) :- 
    % check if is final exists
    get_dict('_isFinal', JSDataKB, _)
.

% cand trebuie mers pe primul dictionar
unificareTermeni(
    JSParamInput,   % dictionarul unde completam parametrii
    [HProp|TProp],  % parcurgerea popozitiei
    [JSDataKBOriginal | JSDataKB]   % knowledge base-ul
) :- 
    % transformare string in atom
    string(HProp), atom_string(Atom, HProp), 
    unificareTermeni(JParamInput, TProp, [JSDataKBOriginal | JSDataKBOriginal])
.

unificareTermeni(
    JSParamInput,   % dictionarul unde completam parametrii
    [HProp|TProp],  % parcurgerea popozitiei
    [JSDataKBOriginal | JSDataKB]  % knowledge base-ul
) :- 
    % scoatem datele din dictionar
    atom_string(Atom, HProp), get_dict(Atom, JSDataKB, Termen), % scoatem termenii din dictionar

    % apelare recursiva
    unificareTermeni(JParamInput, TProp, [JSDataKBOriginal | Termen])
.

% analizam json-ul primit
analyseData(JSData, JSDataKB) :-
    get_dict(actiune, JSData, Actiune), % obtinem actiunea
    get_dict(parametrii, JSData, Parametrii), % obtinem parametrii

    % obtinem datele din parametrii
    get_dict(propozitie, Parametrii, Propozitie), % obtinem propozitie

    % compunem argumentele pentru parsare
    split_string(Propozitie, " ", " ", SplitPropozitie), % impartim propozitia in termeni
    append([Actiune], SplitPropozitie, CompletPropozitie), % adaugam si actiunea la cautare

    % incepem unificarea termenilor
    unificareTermeni(Params, CompletPropozitie, [JSDataKB | JSDataKB]) % parcurgem propozitia si completam dictionarul
.

% read json data
readJson(InputFile, JSData) :-
    use_module(library(http/json)),
    open(InputFile, read, Stream), 
    json_read_dict(Stream, JSData)
.

% entryPoint
entryPoint(_) :-
    readJson("./Input.txt", JSData), % citi
    readJson("./KBase.txt", JSDataKB),
    analyseData(JSData, JSDataKB) % obtinem actiunea
.