# pdp-logico

PDEP-KEY

Sabemos lo que pensás
Se nos ha encargado la tarea de codificar un nuevo motor de predicciones para usuarios que envían mensajes de texto. El objetivo es que el usuario tenga que escribir la menor cantidad de palabras posibles; para lograrlo, el motor generará predicciones precisas sobre posibles próximas palabras según el texto que se esté escribiendo en el momento.
Luego de mucho debate, se decidió implementarlo en Prolog.

% mensaje(ListaDePalabras, Receptor).
%	Los receptores posibles son:
%	Persona: un simple átomo con el nombre de la persona; ó
%	Grupo: una lista de al menos 2 nombres de personas que pertenecen al grupo.
mensaje(['hola', ',', 'qué', 'onda', '?'], nico).
mensaje(['todo', 'bien', 'dsp', 'hablamos'], nico).
mensaje(['q', 'parcial', 'vamos', 'a', 'tomar', '?'], [nico, lucas, maiu]).
mensaje(['todo', 'bn', 'dsp', 'hablamos'], [nico, lucas, maiu]).
mensaje(['todo', 'bien', 'después', 'hablamos'], mama).
mensaje(['¿','y','q', 'onda', 'el','parcial', '?'], nico).
mensaje(['¿','y','qué', 'onda', 'el','parcial', '?'], lucas).

% abreviatura(Abreviatura, PalabraCompleta) relaciona una abreviatura con su significado.
abreviatura('dsp', 'después').
abreviatura('q', 'que').
abreviatura('q', 'qué').
abreviatura('bn', 'bien').

% signo(UnaPalabra) indica si una palabra es un signo.
signo('¿').    signo('?').   signo('.').   signo(','). 

% filtro(Contacto, Filtro) define un criterio a aplicar para las predicciones para un contacto
filtro(nico, masDe(0.5)).
filtro(nico, ignorar(['interestelar'])).
filtro(lucas, masDe(0.7)).
filtro(lucas, soloFormal).
filtro(mama, ignorar(['dsp','paja'])).

Se pide desarrollar los siguientes predicados de modo que sean totalmente inversibles (a menos que se explicite lo contrario):
1)	recibioMensaje/2: relaciona una persona con un mensaje si recibió dicho mensaje del usuario ya sea de forma individual o grupal. Deberían ser posibles respuestas nico, lucas, maiu y mama, y no [nico, lucas, maiu].

2)	demasidoFormal/1: se consideran demasiado formales los mensajes con más de 20 palabras que incluyen signos y los que comienzan con ‘¿’. A menos que tengan abreviaturas, en cuyo caso la formalidad se pierde.

3)	esAceptable/2: saber si una palabra dada es aceptable para una persona. O sea, si pasa todos los filtros configurados para dicho usuario:
Actualmente existen 3 tipos de filtros, con posibilidad de agregarse más en un futuro cercano:
	masDe(N): La palabra es aceptada si su tasa de uso con esa persona es mayor a N. La tasa de uso de una palabra se calcula como la cantidad de apariciones de esa palabra en mensajes enviados a esa persona dividido por la cantidad de apariciones de esa palabra en mensajes enviados a cualquier persona o grupo.
	ignorar(ListaDePalabras): Las palabras de la lista no son aceptadas.
	soloFormal: Solamente es aceptable si la palabra se encuentra en algún mensaje demasiado  formal.
	No se espera que sea inversible.

4)	dicenLoMismo/2: dos mensajes dicen lo mismo cuando todas las palabras de ambos se encuentran en el mismo orden y son equivalentes (las abreviaturas son equivalentes a sus correspondientes palabras). Por ejemplo el último mensaje enviado a lucas dice lo mismo que el último enviado a nico.

5)	fraseCelebre/1: un mensaje es frase célebre cuando se usó con todos los contactos del usuario. Los contactos son simplemente las personas que recibieron algún mensaje del usuario. Debería ser cierto incluso si no fue escrito siempre de la misma forma, lo importante es que diga lo mismo. Para nuestra base de conocimientos fraseCelebre/1 sería cierto para cualquiera de las versiones usadas de “todo bien después hablamos”, pero no para el de “¿y qué onda el parcial?”.

6)	prediccion/3: relaciona un mensaje a ser enviado, quién lo recibirá (persona o grupo) y una predicción. Una predicción es una posible palabra para continuar el mensaje.
Toda palabra que haya sido escrita en algún mensaje después de la última palabra del texto a enviar (o alguna equivalencia de la misma) es considerada una predicción potencial.
Para que la potencial predicción sea una respuesta, deberá ser aceptable para el/los receptor/es (si es un grupo debería ser aceptable para todos los que lo conforman).
Sin embargo, si el mensaje a enviar es alguna frase célebre, no se debe proveer una predicción porque se considera que el mensaje ya está completo.
Nota: Sólo se espera que sea inversible respecto a la predicción. El mensaje y el receptor son datos provistos por el usuario.

[Archivo adjunto] (https://docs.google.com/document/d/1BiW5xkaOFTveAsG4x8xaVrbu4svqDqgDgdEQ5892Fpg/edit#heading=h.lft6comxshu3)
