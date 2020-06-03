% sintaxa:
% @ - variabila

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

    % nu este in input, luam default-ul
    get_dict(AtomKey, JSDataKB, InsideBranch),
    get_dict('_default', InsideBranch, DefaultValue) ->
        put_dict(AtomKey, InDictionary, DefaultValue, OutDictionary)
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

    % generam un dictionar
    dict_create(OutputDict, _, [])
.

unificareTermeni(
    [HProp|TProp],  % parcurgerea popozitiei
    [JSDataKBOriginal | JSDataKB],  % knowledge base-ul
    JSDataInput,    % json-ul citit la input
    OutDictionary    % dictionarul final cu rezultatele
) :- 
    % scoatem datele din dictionar
    atom_string(Atom, HProp), get_dict(Atom, JSDataKB, Termen), % scoatem termenii din dictionar
    
    % daca nu este sub-arbore, incepem din root
    string(Termen),
    !,

    % scoatem din root primul termen
    atom_string(RootAtom, Termen),
    get_dict(RootAtom, JSDataKBOriginal, RootBranch), % scoatem termenii din dictionar

    % reincepem parcurgerea din root
    unificareTermeni(TProp, [JSDataKBOriginal | RootBranch], JSDataInput, OutDictionary)
.

unificareTermeni(
    [HProp|TProp],  % parcurgerea popozitiei
    [JSDataKBOriginal | JSDataKB],  % knowledge base-ul
    JSDataInput,    % json-ul citit la input
    OutDictionary    % dictionarul final cu rezultatele
) :- 
    % scoatem datele din dictionar
    atom_string(Atom, HProp), get_dict(Atom, JSDataKB, Termen), % scoatem termenii din dictionar
    
    % mergem pe ramura aceasta
    unificareTermeni(TProp, [JSDataKBOriginal | Termen], JSDataInput, InDictionary),
   
    % verificam daca este variabila
    % incepe cu @[cuvant]
    completeDictionary(HProp, JSDataKB, JSDataInput, InDictionary, OutDictionary)
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

% entryPoint
entryPoint(OutputDict) :-
    readJson("./NLID/KernelModule/Input.txt", JSData), % citi
    readJson("./NLID/KernelModule/KBase.txt", JSDataKB),
    analyseData(JSData, JSDataKB, OutputDict) % obtinem actiunea
.