vende(laGondoriana,trancosin,35).
vende(laGondoriana,sanaSam,35).
vende(farm2,trancosin,40).
vende(farm2,sanaSam,40).
incluye(trancosin,athelas).
incluye(trancosin,cenizaBoromireana).
efecto(athelas,cura(desazon)).
efecto(athelas,cura(heridaDeOrco)).
efecto(cenizaBoromireana,cura(gripeA)).
efecto(cenizaBoromireana,potencia(deseoDePoder)).
estaEnfermo(eomer,heridaDeOrco). % eomer es varon
estaEnfermo(eomer,deseoDePoder).
estaEnfermo(eomund,desazon).
estaEnfermo(eowyn,heridaDeOrco). % eowyn es mujer
padre(eomund,eomer).
actividad(eomer,fecha(15,6,3014),compro(trancosin,laGondoriana)).
actividad(eomer,fecha(15,8,3014),preguntoPor(trancosin,farm2)).
actividad(eomer,fecha(15,8,3014),preguntoPor(sanaSam,laGondoriana)).
actividad(eowyn,fecha(14,9,3014),preguntoPor(sanaSam,laGondoriana)).



% PUNTO 1
% medicamentoUtil(Pers,Medic), se verica si Medic sirve para curar (o sea, tiene una droga que cura) 
% alguna enfermedad de la que Pers esta enfermo, y ademas no sirve para potenciar 
% (o sea, ninguna de sus drogas potencia) una enfermedad de la que Pers esta enfermo.
% En el extracto de ejemplo, el trancosin sirve para curar tanto la desazon y la herida de orco 
% (porque incluye athelas) como la gripe A (porque incluye cenizaBoromireana),
% y tambien sirve para potenciar el deseo de poder (tambien por la cenizaBoromireana).
medicamentoUtil(Pers,Medic):-
	estaEnfermo(Pers,Enf),
	medicamentoCura(Medic,Enf).

sirveParaCurar(Medic,Enf):-
	sirvePara(cura(Enf),Medic).

sirveParaPotenciar(Medic,Enf):-
	sirvePara(potencia(Enf),Medic).

sirvePara(Efecto,Medic):-
	incluye(Medic,Droga),
	efecto(Droga,Efecto).

% PUNTO 2
% medicamentoMilagroso(Pers,Medic), se verica si Medic sirve para curar (o sea, tiene una droga que cura)
% todas las enfermedades de las que Pers esta enfermo, y ademas no sirve para potenciar (o sea,
% ninguna de sus drogas potencia) una enfermedad de la que Pers esta enfermo.
medicamentoMilagroso(Pers,Medic):-
	estaEnfermo(Pers,_),
	incluye(Medic,_),
	forall(estaEnfermo(Pers,Enf),medicamentoCura(Medic,Enf)).

medicamentoCura(Medic,Enf):-
	sirveParaCurar(Medic,Enf),
	not(sirveParaPotenciar(Medic,Enf)).

% PUNTO 3
% drogaSimpatica(Droga), se verica para una droga si cumple al menos una de estas condiciones
%	*cura al menos 4 enfermedades y no potencia ninguna.
%	*cura al menos una enfermedad de la que Eomer esta enfermo y otra distinta
%	de la que Eowyn esta enferma.
%	*se incluye al menos en un medicamento, ese medicamento se vende al menos
%	en una farmacia, y ninguna farmacia lo vende a mas de 10 pesos.
% Este predicado debe ser inversible.
/*drogaSimpatica(Droga):-
	.*/
	
% PUNTO 4
% tipoSuicida(Pers), se verica para una persona si compro al menos un producto que no sirve para
% curar ninguna enfermedad de la que esta enfermo y que si sirve para potenciar una enfermedad de la que esta enfermo.
tipoSuicida(Pers):-
	actividad(Pers,_,compro(Medic,_)),
	%forall(estaEnfermo(Pers,Enf),not(medicamentoCura(Medic,Enf))).
	not(medicamentoMilagroso(Pers,Medic)).

% PUNTO 5
% tipoAhorrativo(Pers), se verica para una persona si para cada medicamento
% que compro, pregunto por el mismo medicamento en una farmacia que lo cobra
% mas caro que aquella en la que lo compro. Este predicado debe ser inversible.
tipoAhorrativo(Pers):-
	actividad(Pers,_,compro(_,_)), % sin unificar solo da true-false, y ademas unifico las personas que COMPRARON nada mas
	forall(compraMedicamento(Pers,Medic,PreCom),consultaPor(Pers,Medic,PreCom)).

compraMedicamento(Pers,Medic,PreCom):-
	actividad(Pers,_,compro(Medic,Farm)),
	vende(Farm,Medic,PreCom).

consultaPor(Pers,Medic,PreCom):-
	actividad(Pers,_,preguntoPor(Medic,Farm)),
	vende(Farm,Medic,PreVen),
	PreVen > PreCom.

% PUNTO 6
% a. tipoActivoEn(Pers,Mes,Anio) se verica si la persona hizo alguna actividad
% (compra y/o pregunta) en ese mes/a~no.
% En el ejemplo Eomer es activo tanto en junio de 3014 (porque hizo una
% compra) como en agosto de 3014 (porque hizo una averiguacion).
% b. diaProductivo(Fecha), se verifica para una fecha (functor fecha(Dia,Mes,Anio))
% si todas las actividades que se hicieron en ese dia fueron compras o preguntas
% de un medicamento util para la persona que hizo la actividad.
tipoActivoEn(Pers,Mes,Anio):-
	actividad(Pers,fecha(_,Mes,Anio),preguntoPor(_,_));
	actividad(Pers,fecha(_,Mes,Anio),compro(_,_)).

/*diaProductivo(Fecha):-
	forall().*/

% PUNTO 7
% gastoTotal(Pers,Plata) relaciona cada persona con el total que gasto en medicamentos
% que compro, segun el precio de cada medicamento comprado en la farmacia en la que hizo la compra.
gastoTotal(Pers,Plata):-
	findall(Pre,compraMedicamento(Pers,_,Pre),Precios),
	sumlist(Precios,Plata).

% PUNTO 8
% zafoDe(Pers,Enfer), se verifica si Pers no esta enfermo de Enfer, pero algun
% ancestro de Pers (padre, abuelo, bisabuelo, etc.) si lo esta.
/*zafoDe(Pers,Enfer):-
	.*/
