/*
accion(NombreDelJuego)
mmorpg(NombreDelJuego, CantidadDeUsuarios)
puzzle(NombreDelJuego, CantidadDeNiveles, Dificultad)
*/

juego(accion(callOfDuty), 5).
juego(accion(batmanAA), 10).
juego(mmorpg(wow, 5000000), 30).
juego(mmorpg(lineage2, 6000000), 15).
juego(puzzle(plantsVsZombies, 40, media), 10).
juego(puzzle(tetris, 10, facil), 0).

oferta(callOfDuty, 10).
oferta(plantsVsZombies, 50).
oferta(lineage2, 60).

usuario(nico, [batmanAA, plantsVsZombies, tetris], [compra(lineage2)]).
usuario(fede, [], [regalo(callOfDuty,nico),regalo(wow, pepe)]).
usuario(rasta, [lineage2], []).
usuario(agus, [], []).
usuario(felipe, [plantsVsZombies], [compra(tetris)]).
usuario(pepe, [], [regalo(callOfDuty,fede),regalo(wow, nico)]).

nombreDelJuego(accion(Nombre), Nombre):-
	juego(accion(Nombre),_).
nombreDelJuego(mmorpg(Nombre,X), Nombre):-
	juego(mmorpg(Nombre,X),_).
nombreDelJuego(puzzle(Nombre,X,Y), Nombre):-
	juego(puzzle(Nombre,X,Y),_).

% PUNTO UNO
cuantoSale(Juego, Precio):-
	juego(Juego,_),
	precioDe(Juego,Precio).
	
precioDe(Juego, Precio):-
	juego(Juego, PrecioU),
	nombreDelJuego(Juego, Nombre),
	oferta(Nombre, Porcentaje),
	Precio is PrecioU - (PrecioU * (Porcentaje / 100)).

precioDe(Juego, Precio):-
	juego(Juego,Precio),
	nombreDelJuego(Juego, Nombre),
	not(oferta(Nombre,_)).

% PUNTO DOS
juegoPopular(Juego):-
	juego(Juego,_),
	tipoDe(Juego).

tipoDe(accion(_)).
tipoDe(mmorpg(_, Usuarios)):-
	Usuarios > 1000000.
tipoDe(puzzle(_, 25, _)).
tipoDe(puzzle(_, _, facil)).

% PUNTO TRES
tieneUnBuenDescuento(Juego):-
	juego(Juego, _),
	nombreDelJuego(Juego, Nombre),
	oferta(Nombre, Porcentaje),
	Porcentaje > 50.
	

% PUNTO CUATRO
adictoALosDescuentos(Usuario):-
	usuario(Usuario, _, Lista),
	not(length(Lista,0)),
	forall(member(Adquisicion,Lista), (seAdquiere(Adquisicion,Juego), tieneUnBuenDescuento(Juego))).
	
seAdquiere(compra(Nombre),Juego):-
	nombreDelJuego(Juego,Nombre).

seAdquiere(regalo(Nombre,_),Juego):-
	nombreDelJuego(Juego,Nombre).


% PUNTO CINCO
	
nombreGenero(accion(_),accion).
nombreGenero(mmorpg(_,_),mmorpg).
nombreGenero(puzzle(_,_,_),puzzle).

obtenerNombreGenero(NombreJuego,NombreGenero):- 
	nombreDelJuego(Genero,NombreJuego),
	nombreGenero(Genero,NombreGenero).

fanaticoDe(Usuario, NombreGenero):-
	usuario(Usuario, Lista, _),
	member(UnJuego,Lista),
	member(OtroJuego,Lista),
	UnJuego \= OtroJuego,
	obtenerNombreGenero(UnJuego,NombreGenero),
	obtenerNombreGenero(OtroJuego,NombreGenero).

% PUNTO SEIS

monotematico(Usuario, Genero):-
	usuario(Usuario, Lista, _),
	obtenerNombreGenero(_,Genero),
	not(length(Lista,0)),
	forall(member(Juego,Lista),obtenerNombreGenero(Juego,Genero)).

%PUNTO SIETE
buenosAmigos(Usuario, OtroUsuario):-
	usuario(Usuario,_,Lista1),
	usuario(OtroUsuario,_,Lista2),
	regalosA(Usuario,Lista2),
	regalosA(OtroUsuario,Lista1).

regalosA(Usuario,Lista):-
	member(Elemento,Lista),
	juegoDe(Elemento,Usuario).

juegoDe(regalo(Nombre,Usuario),Usuario):-
	nombreDelJuego(Juego,Nombre),
	juegoPopular(Juego).

% PUNTO OCHO
cuantoGastara(Usuario, Dinero):-
	usuario(Usuario, _, Lista),
	findall(Gasto,(member(Elemento,Lista),seAdquiere(Elemento,Juego),cuantoSale(Juego,Gasto)),Gastos),
	sumlist(Gastos,Dinero).
