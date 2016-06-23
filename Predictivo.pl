% mensaje(ListaDePalabras, Receptor).
%	Los receptores posibles son:
%	Persona: un simple átomo con el nombre de la persona; 
%	Grupo: una lista de al menos 2 nombres de personas que pertenecen al grupo.
mensaje(['hola', ',', 'qu�', 'onda', '?'], nico).
mensaje(['todo', 'bien', 'dsp', 'hablamos'], nico).
mensaje(['q', 'parcial', 'vamos', 'a', 'tomar', '?'], [nico, lucas, maiu]).
mensaje(['a','b'], [nico, lucas, maiu, mama]).
mensaje(['todo', 'bn', 'dsp', 'hablamos'], [nico, lucas, maiu]).
mensaje(['todo', 'bien', 'despu�s', 'hablamos'], mama).
mensaje(['�','y','q', 'onda', 'el','parcial', '?'], nico).
mensaje(['�','y','qu�', 'onda', 'el','parcial', '?'], lucas).

% abreviatura(Abreviatura, PalabraCompleta) relaciona una abreviatura con su significado.
abreviatura('dsp', 'despu�s').
abreviatura('q', 'que').
abreviatura('q', 'qu�').
abreviatura('q','qu�').
abreviatura('bn', 'bien').

% signo(UnaPalabra) indica si una palabra es un signo.
signo('�').
signo('?').
signo('.').
signo(',').

% filtro(Contacto, Filtro) define un criterio a aplicar para las predicciones para un contacto
filtro(nico, masDe(0.5)).
filtro(nico, ignorar(['interestelar'])).
filtro(lucas, masDe(0.7)).
filtro(lucas, soloFormal).
filtro(mama, ignorar(['dsp','paja'])).

% recibioMensaje/2: relaciona una persona con un mensaje si recibió dicho mensaje del usuario 
% ya sea de forma individual o grupal. Deberían ser posibles respuestas nico, lucas, maiu y mama, y no [nico, lucas, maiu].
recibioMensaje(Mensaje,Persona):-
	findall(X,mensaje(Mensaje,X),Personas),
	flatten(Personas,UnaSolaLista),
	member(Persona,UnaSolaLista).
	
recibidos(Persona,Mensaje):-
	mensaje(Mensaje,Personas),
	member(Persona,Personas).
recibidos(Persona,Mensaje):-
	mensaje(Mensaje,Persona).

% demasidoFormal/1: se consideran demasiado formales los mensajes con más de 20 palabras
% que incluyen signos y los que comienzan con ‘¿’. A menos que tengan abreviaturas, en cuyo caso la formalidad se pierde.
demasiadoFormal(Mensaje):-	
	incluyeSignos(Mensaje),
	comienzaFormal(Mensaje),
	length(Mensaje,N),
	N > 20,
	not(contieneAbreviatura(Mensaje)).
incluyeSignos(Mensaje):-
	member(S,Mensaje),
	signo(S).
comienzaFormal(['¿'|_]).
contieneAbreviatura(Mensaje):-
	abreviatura(P,_),
	member(P,Mensaje).
% esAceptable/2: saber si una palabra dada es aceptable para una persona. O sea, si pasa todos los filtros configurados para dicho usuario:
% Actualmente existen 3 tipos de filtros, con posibilidad de agregarse más en un futuro cercano:
%	masDe(N): La palabra es aceptada si su tasa de uso con esa persona es mayor a N. La tasa de uso de una palabra se calcula como 
% 	la cantidad de apariciones de esa palabra en mensajes enviados a esa persona dividido por la cantidad de apariciones de esa palabra
%	en mensajes enviados a cualquier persona o grupo.
%	ignorar(ListaDePalabras): Las palabras de la lista no son aceptadas.
%	soloFormal: Solamente es aceptable si la palabra se encuentra en algún mensaje demasiado  formal.
%	No se espera que sea inversible.
esAceptable(Persona,Palabra):-
	forall(filtro(Persona,Filtro),cumpleFiltro(Palabra,Persona,Filtro)).

cumpleFiltro(Palabra,_,ignorar(X)):-
	not(member(Palabra,X)).

cumpleFiltro(Palabra,_,soloFormal):-
	mensaje(Mensaje,_),
	demasiadoFormal(Mensaje),
	member(Palabra,Mensaje).

cumpleFiltro(Palabra,Persona,masDe(X)):-
    cantidadEnviados(Persona,Enviados),
	cantidadApariciones(Palabra,Apariciones),
	Tasa is Enviados / Apariciones,
    Tasa > X.
	
/*aparacionDe([],Palabra,0).
aparacionDe(Lista,Palabra,N):-
	.*/
cantidadEnviados(Persona,Cantidad):-
		findall(Mensaje,recibioMensaje(Mensaje,Persona),Mensajes),
		length(Mensajes,Cantidad).
		
count([],X,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([_|T],X,Z):- count(T,X,Z).		
	
cantidadApariciones(Palabra,Cantidad):-
	findall(X,(mensaje(Mensaje,_),count(Mensaje,Palabra,X)),Cantidades),
	sumlist(Cantidades,Cantidad).

esLoMismo(Palabra1,Palabra2):-
		abreviatura(Palabra1,Palabra2);
		abreviatura(Palabra2,Palabra1).
esLoMismo(Palabra1,Palabra1).
	
% dicenLoMismo/2: dos mensajes dicen lo mismo cuando todas las palabras de ambos se encuentran en el mismo orden
% y son equivalentes (las abreviaturas son equivalentes a sus correspondientes palabras). 
% Por ejemplo el último mensaje enviado a lucas dice lo mismo que el último enviado a nico.
dicenLoMismo(MensajeUno,MensajeDos):-
	forall(member(Palabra1,MensajeUno),	(nth0(Posicion,MensajeUno,Palabra1),nth0(Posicion,MensajeDos,Palabra2),esLoMismo(Palabra1,Palabra2))).
	
	
dicenLoMismo2([_],[_]).
dicenLoMismo2([X|Xs],[Y|Ys]):-
	esLoMismo(X,Y),
	dicenLoMismo2(Xs,Ys).
	
	
% fraseCelebre/1: un mensaje es frase célebre cuando se usó con todos los contactos del usuario. 
% Los contactos son simplemente las personas que recibieron algún mensaje del usuario.
% Debería ser cierto incluso si no fue escrito siempre de la misma forma, lo importante es que diga lo mismo.
% Para nuestra base de conocimientos fraseCelebre/1 sería cierto para cualquiera de las versiones usadas de “todo bien después hablamos”, 
% pero no para el de “¿y qué onda el parcial?”.
fraseCelebre(Mensaje):-
	forall(recibioMensaje(_,Usuario),recibioParecido(Mensaje,Usuario)).
	
recibioParecido(Mensaje,Persona):-
	recibidos(Persona,OtroMensaje),
	dicenLoMismo(Mensaje,OtroMensaje).
	
% prediccion/3: relaciona un mensaje a ser enviado, quién lo recibirá (persona o grupo) y una predicción. Una predicción es una posible palabra
% para continuar el mensaje.
% Toda palabra que haya sido escrita en algún mensaje después de la última palabra del texto a enviar (o alguna equivalencia de la misma) 
% es considerada una predicción potencial.
% Para que la potencial predicción sea una respuesta, deberá ser aceptable para el/los receptor/es (si es un grupo debería ser aceptable 
% para todos los que lo conforman).
% Sin embargo, si el mensaje a enviar es alguna frase célebre, no se debe proveer una predicción porque se considera que el mensaje ya está completo.
prediccion(Mensaje,Receptor,Prediccion):-
	ultimaPalabra(Mensaje,Ultima),
	siguientePalabra(Ultima,Prediccion),
	esAceptable(Receptor,Prediccion),
	not(fraseCelebre(Mensaje)).
	
siguientePalabra(Palabra,Siguiente):-
	mensaje(Mensaje,_),
	nth0(Posicion,Mensaje,Palabra),
	PosicionSiguiente is Posicion+1,
	nth0(PosicionSiguiente,Mensaje,Siguiente).

ultimaPalabra(Mensaje,Ultima):-
	length(Mensaje,Largo),
	nth1(Largo,Mensaje,Ultima).

% Nota: Sólo se espera que sea inversible respecto a la predicción. El mensaje y el receptor son datos provistos por el usuario.
