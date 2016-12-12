disfraz(gatubela,[comic,batman,cine,sexy]).
disfraz(batman,[comic,batman,cine]).
disfraz(mujerMaravilla,[comic,cine]).
disfraz(zombie,[comic,cine,terror]).
disfraz(elefanteRosado,[bizarro]).
disfraz(cajaVengadora,[bizarro]).
disfraz(odalisca,[baile,sexy]).
disfraz(payasoIT,[terror,cine]).
disfraz(jason,[terror,cine]).
disfraz(bruja,[terror]).

fiesta(cumpleanios(lucia,10),fecha(20,10,2015)).
fiesta(halloween(ana,2011),fecha(31,10,2011)).
fiesta(halloween(ana,2014),fecha(31,10,2014)).
fiesta(cumpleanios(andrea,25),fecha(10,12,2013)).

eligioDisfraz(luis,payasoIT,halloween(ana,2014)).
eligioDisfraz(ana,gatubela,halloween(ana,2014)).
eligioDisfraz(lucia,zombie,halloween(ana,2014)).
eligioDisfraz(luis,jason,halloween(ana,2011)).
eligioDisfraz(ana,bruja,halloween(ana,2011)).
eligioDisfraz(lucia,bruja,halloween(ana,2011)).
eligioDisfraz(andrea,gatubela,halloween(ana,2011)).

eligioDisfraz(andrea,mujerMaravilla,cumpleanios(andrea,25)).
eligioDisfraz(lucia,odalisca,cumpleanios(lucia,10)).

interes(lucia,baile).
interes(andrea,sexy).
interes(andrea,baile).
interes(andrea,cine).
interes(ana,terror).
interes(ana,cine).
interes(luis,comic).
interes(luis,terror).
interes(luis,bizarro).

leGusta(Persona,Disfraz):-
	interes(Persona,_),
	disfraz(Disfraz,_),
	categoria(Persona,Disfraz).
categoria(Persona,Disfraz):-
	interes(Persona,Categoria),
	disfraz(Disfraz,Lista),
	member(Categoria,Lista).