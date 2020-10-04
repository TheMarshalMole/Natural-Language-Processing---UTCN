# This project is CLOSED.

# Natural Language Intent Detection

Def: NLID este o soluție care să asocieze propoziția primită la intrare cu toate posibilitățile din setul cunoscut 
(adnotăm elementele cunoscute cu etichete).
Permite un număr arbitrar de entități absente (momentan 1).

Avantajele acestei metode:
1. Ușurință: Permite efectuarea operațiilor CRUD asupra elementelor din setul cunoscut fără modificări de cod.
  eg: adaugă eveniment între ora X și Y / adaugă evenimen la ora X sau Y
2. Scalabilitate: Se pot adăuga un număr arbitrar de etichete. 
3. Personalizare: Se pot specifica propietăți pentru etichete.
4. Simplitatea înterținerii: Adăugarea de noi propoziții se face la nivel de bază de cunoștiințe, fără ajustarea
  codului
5. Soluție completă: Determină toate soluțiile.
6. Eficiență echilibrată: Mai puțină memorie decât un ROM, mai puțin timp decât bruteforce.
7. Procesare bazată pe LCA: Propozițiile cu prefix comun sunt specificate o singură dată.
