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
	interes(Persona,Interes),
	disfraz(Disfraz,Categorias),
	member(Interes,Categorias).

tematica(Fiesta,Categoria):-
    fiesta(Fiesta,_),
    disfraz(_,Categorias),
    member(Categoria,Categorias),
    forall(eligioDisfraz(_,Disfraz,Fiesta), (disfraz(Disfraz,CategoriasDisfraz), member(Categoria,CategoriasDisfraz))).

cantidadDisfrazados(Fiesta,Disfraz,Cantidad):-
    disfraz(Disfraz,_),
    eligioDisfraz(_,_,Fiesta),
	findall(Persona, eligioDisfraz(Persona,Disfraz,Fiesta), Personas),
    length(Personas,Cantidad).

disfraces(Fiesta,Disfraces):-
    eligioDisfraz(_,_,Fiesta),
	findall(Disfraz, eligioDisfraz(_,Disfraz,Fiesta), Disfraces).

estaQuemado(Disfraz):-
    disfraz(Disfraz,_),
    forall(eligioDisfraz(_,_,Fiesta), (disfraces(Fiesta,Disfraces) ,member(Disfraz,Disfraces)));
    
    disfraz(Disfraz,_),
    eligioDisfraz(_,_,Fiesta),
    cantidadDisfrazados(Fiesta,Disfraz,Cantidad),
    Cantidad > 1.

apropiadoSegunFiesta(Disfraz,cumpleanios(_,Edad)):-
    disfraz(Disfraz,_),
    Edad>=18,
    Edad=<50;
    
    disfraz(Disfraz,Categorias),
    Edad<18,
	not(member(sexy,Categorias));
    
    disfraz(Disfraz,Categorias),
    Edad>50,
	not(member(sexy,Categorias)).

apropiadoSegunFiesta(Disfraz,halloween(_,_)):-
    disfraz(Disfraz,Categorias),
    member(terror,Categorias);
    
    disfraz(Disfraz,Categorias),
    member(sexy,Categorias).
    
noOpaca(Disfraz,OtroDisfraz):-
    disfraz(Disfraz,_),
    disfraz(OtroDisfraz,_),
    Disfraz \= OtroDisfraz.

anfitrion(halloween(Persona,_),Persona).
anfitrion(cumpleanios(Persona,_),Persona).

disfrazApropiado(Disfraz,Fiesta):-
    disfraz(Disfraz,_),
    fiesta(Fiesta,_),
    anfitrion(Fiesta,Anfitrion),
    eligioDisfraz(Anfitrion,DisfrazAnfitrion,Fiesta),
    noOpaca(Disfraz,DisfrazAnfitrion),
    apropiadoSegunFiesta(Disfraz,Fiesta).

cantidadGustaron(Fiesta,Disfraz,Cantidad):-
    disfraz(Disfraz,_),
    fiesta(Fiesta,_),
    findall(Persona, (eligioDisfraz(Persona,_,Fiesta),leGusta(Persona,Disfraz)), Personas),
    length(Personas,Cantidad).

asistio(Persona,Fiesta):-
    eligioDisfraz(Persona,_,Fiesta).

masGustado(Fiesta,Disfraz):-
    disfraz(Disfraz,_),
    fiesta(Fiesta,_),
    forall(eligioDisfraz(_,OtroDisfraz,Fiesta),(cantidadGustaron(Fiesta,Disfraz,Cantidad), cantidadGustaron(Fiesta,OtroDisfraz,OtraCantidad), Cantidad >= OtraCantidad)).

mejorDisfraz(Fiesta,Disfraz,Ganador):-
    disfraz(Disfraz,_),
    fiesta(Fiesta,_),
    not(estaQuemado(Disfraz)),
    disfrazApropiado(Disfraz,Fiesta),
    masGustado(Fiesta,Disfraz),
    eligioDisfraz(Ganador,Disfraz,Fiesta).