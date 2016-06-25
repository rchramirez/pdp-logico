vende(laGondoriana,trancosin,35).
vende(laGondoriana,sanaSam,35).
incluye(trancosin,athelas).
incluye(trancosin,cenizaBoromireana).
efecto(athelas,cura(desazon)).
efecto(athelas,cura(heridaDeOrco)).
efecto(cenizaBoromireana,cura(gripeA)).
efecto(cenizaBoromireana,potencia(deseoDePoder)).
estaEnfermo(eomer,heridaDeOrco).    % eomer es varon
estaEnfermo(eomer,deseoDePoder).
estaEnfermo(eomer,desazon).
estaEnfermo(eomund,desazon).
estaEnfermo(eowyn,heridaDeOrco).    % eowyn es mujer
padre(eomund,eomer).
actividad(eomer,fecha(15,6,3014),compro(trancosin,laGondoriana)).
actividad(eomer,fecha(15,8,3014),preguntoPor(sanaSam,laGondoriana)).
actividad(eowyn,fecha(14,9,3014),preguntoPor(sanaSam,laGondoriana)).

%ADD HECHOS
esMedicamento(trancosin).

% PUNTO 1
medicamentoUtil(Pers,Medic):-
	estaEnfermo(Pers,Enf),
	sirveParaCurar(Medic,Enf),
	not(sirveParaPotenciar(Medic,Enf)).

sirveParaCurar(Medic,Enf):-
	sirvePara(cura(Enf),Medic).

sirveParaPotenciar(Medic,Enf):-
	sirvePara(potencia(Enf),Medic).

sirvePara(Efecto,Medic):-
	incluye(Medic,Droga),
	efecto(Droga,Efecto).

% PUNTO 2
medicamentoMilagroso(Pers,Medic):-
	estaEnfermo(Pers,Enf),
	esMedicamento(Medic),
	forall(estaEnfermo(Pers,Enf),sirveParaCurar(Medic,OtraEnf)),
	not(sirveParaPotenciar(Medic,Enf)).
	forall(estaEnfermo(Pers,_),medicamentoUtil(Pers,Medic)).

% PUNTO 3

% PUNTO 4

% PUNTO 5

% PUNTO 6

% PUNTO 7

% PUNTO 8
