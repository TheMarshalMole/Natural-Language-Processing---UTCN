% sintaxa:
% @ - variabila

% ERROR CODES
% ERROR_001 - Premature ending

% functii generice generate
% @arguments: Find is atom
getFirstLetter(Value, Find) :- 
    atom_chars(Value, X),
    X = [L|_],
    L = Find
.

% completam dictionarul cu default sau cu termenul din input
% cand incepe cu @
completeDictionary(
    Key,       % cheia din KB / Input (termenul ptr. care vrem completam valorile)
    JSDataKB,   % valoarea actuala din Knowledge base
    JSInput,    % dictionarul primit la input
    InDictionary,  % dictionarul la care adaugam date
    OutDictionary 
) :-
    % verificam daca incepem cu @
    \+ getFirstLetter(Key, '@') 
        -> OutDictionary = InDictionary
    ; % continuam cu restul conditiilor

    % obtinem atomul pentru cuvant
    atom_string(AtomKey, Key), 

    % incercam sa luam datele din input
    get_dict(AtomKey, JSInput, Termen) 
        -> put_dict(AtomKey, InDictionary, Termen, OutDictionary);

    % incercam sa luam datele din input
    atom_string(AtomKey, Key), 

    % nu este in input, luam default-ul
    get_dict(AtomKey, JSDataKB, InsideBranch),

    get_dict('_default', InsideBranch, DefaultValue) ->
        put_dict(AtomKey, InDictionary, DefaultValue, OutDictionary)
.

unificareTermeni(
    [HProp|TProp],  % parcurgerea popozitiei
    [JSDataKBOriginal | JSDataKB],  % knowledge base-ul
    JSDataInput,  % json-ul citit la input
    OutDictionary  % dictionarul final cu rezultatele
) :- 
    % verificam sa fie dictionar
    \+ string(JSDataKB),

    % scoatem datele din dictionar
    atom_string(Atom, HProp), get_dict(Atom, JSDataKB, Termen), % scoatem termenii din dictionar
    
    % daca nu este sub-arbore, incepem din root
    string(Termen),

    % scoatem din root primul termen
    atom_string(RootAtom, Termen),
    get_dict(RootAtom, JSDataKBOriginal, RootBranch), % scoatem termenii din dictionar

    % reincepem parcurgerea din root
    unificareTermeni(TProp, [JSDataKBOriginal | RootBranch], JSDataInput, InDictionary),

    % adaugam date in dictionar
    completeDictionary(HProp, JSDataKB, JSDataInput, InDictionary, OutDictionary)
.

unificareTermeni(
    [HProp|TProp],  % parcurgerea popozitiei
    [JSDataKBOriginal | JSDataKB],  % knowledge base-ul
    JSDataInput,    % json-ul citit la input
    OutDictionary    % dictionarul final cu rezultatele
) :- 
    % verificam sa fie dictionar
    \+ string(JSDataKB),

    % scoatem datele din dictionar
    atom_string(Atom, HProp), get_dict(Atom, JSDataKB, Termen), % scoatem termenii din dictionar

    % mergem pe ramura aceasta
    unificareTermeni(TProp, [JSDataKBOriginal | Termen], JSDataInput, InDictionary),

    % verificam daca este variabila
    % incepe cu @[cuvant]
    completeDictionary(HProp, JSDataKB, JSDataInput, InDictionary, OutDictionary),
    ! % oprim recursivitatea
.

% am ajuns la final
unificareTermeni(
    _,  % parcurgerea popozitiei
    [_ | JSDataKB],   % knowledge base-ul
    _,    % json-ul citit la input
    OutputDict     % dictionarul final cu rezultatele
) :- 
    % check if it is final
    \+ string(JSDataKB),
    get_dict('_isFinal', JSDataKB, _),
    !, % oprim recursivitatea

    % generam dictionarul cu rezultatele
    dict_create(OutputDict, _, [])
.

% s-a terminat prematur propozitia
unificareTermeni(
    [],  % parcurgerea popozitiei
    [_ | JSDataKB],   % knowledge base-ul
    _,   % json-ul citit la input
    OutputDict     % dictionarul final cu rezultatele
) :- 
    % check if it ended prematurely
    \+ string(JSDataKB),
    \+ get_dict('_isFinal', JSDataKB, _),
    print(JSDataKB),
    !, % oprim recursivitatea
    dict_create(Temp, _, []),
    put_dict('@[ERROR_001]', Temp, "PrematureEnding", OutputDict),

    print("Propozitie")
.

% termenul lipseste din KBase
% verificam toti termenii sa vedem daca este prezent _canAbsent
unificareTermeni(
    ListTerms,  % propozitie completa
    [JSDataKBOriginal | JSDataKB],  % knowledge base-ul
    JSDataInput,    % json-ul citit la input
    OutDictionary   % dictionarul final cu rezultatele
) :- 
    % verificam sa fie dictionar
    \+ string(JSDataKB),

    get_dict(Key, JSDataKB, UnKBranch), % scoatem termenii din dictionar
    \+ getFirstLetter(Key, '_'), % sa ignoram flag-urile

    % are flag-ul de _canAbsent
    get_dict('_canAbsent', UnKBranch, _),
    unificareTermeni(ListTerms, [JSDataKBOriginal | UnKBranch], JSDataInput, OutDictionary)
.

% analizam json-ul primit
analyseData(
    JSData, 
    JSDataKB,
    OutputDict % valorile din output
) :-
    get_dict(actiune, JSData, Actiune), % obtinem actiunea
    get_dict(parametrii, JSData, Parametrii), % obtinem parametrii

    % obtinem datele din parametrii
    get_dict(propozitie, Parametrii, Propozitie), % obtinem propozitie

    % compunem argumentele pentru parsare
    split_string(Propozitie, " ", " ", SplitPropozitie), % impartim propozitia in termeni
    append([Actiune], SplitPropozitie, CompletPropozitie), % adaugam si actiunea la cautare

    % incepem unificarea termenilor
    unificareTermeni(CompletPropozitie, [JSDataKB | JSDataKB], Parametrii, OutputDict) % parcurgem propozitia si completam dictionarul
.

% read json data
readJson(InputFile, JSData) :-
    use_module(library(http/json)),
    open(InputFile, read, Stream), 
    json_read_dict(Stream, JSData)
.

% ./NLID/KernelModule/
% entryPoint
entryPoint(OutputDict) :-
    readJson("./NLID/KernelModule/Input.txt", JSData), % citi
    readJson("./NLID/KernelModule/KBase.txt", JSDataKB),
    analyseData(JSData, JSDataKB, OutputDict) % obtinem actiunea
.