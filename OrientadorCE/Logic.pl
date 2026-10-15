:- consult('BD.pl').
:- consult('BNF.pl').


% ==========================================
% OrientadorCE - Reglas de recomendacion
% ==========================================
% Para iniciar: cargar Logic.pl y consultar
%   ?- iniciar.
% ==========================================


% ----- Preguntas -----

pregunta('Que te gusta?').
pregunta('Te gusta la tecnologia?').
pregunta('Te gusta resolver problemas?').
pregunta('Te interesa ayudar a las personas?').
pregunta('Te gusta escuchar a los demas?').


% ----- Conversacion -----

iniciar :-
    nl,
    write('OrientadorCE: Hola. Estoy aqui para ayudarte a explorar opciones profesionales.'), nl,
    findall(P, pregunta(P), Preguntas),
    preguntar(Preguntas, [], Preferencias),
    recomendar(Preferencias).

preguntar([], Preferencias, Preferencias).
preguntar([Pregunta|Resto], Acumuladas, Finales) :-
    obtener_respuesta(Pregunta, Preferencia),
    registrar(Preferencia, Acumuladas, Nuevas),
    preguntar(Resto, Nuevas, Finales).

obtener_respuesta(Pregunta, Preferencia) :-
    write('OrientadorCE: '), write(Pregunta), nl,
    write('Usuario: '),
    read_line_to_string(user_input, Texto),
    revisar_respuesta(Texto, Pregunta, Preferencia).

revisar_respuesta(end_of_file, _, _) :-
    !,
    nl,
    write('OrientadorCE: Se cerro la entrada, no puedo continuar.'), nl,
    fail.
revisar_respuesta(Texto, _, Preferencia) :-
    interpretar(Texto, Preferencia),
    !.
revisar_respuesta(_, Pregunta, Preferencia) :-
    write('OrientadorCE: No entendi tu respuesta, puedes decirlo de otra forma?'), nl,
    obtener_respuesta(Pregunta, Preferencia).


% ----- Registro de preferencias -----

contraria(positiva(Interes), negativa(Interes)).
contraria(negativa(Interes), positiva(Interes)).

registrar(Preferencia, Acumuladas, [Preferencia|Resto]) :-
    contraria(Preferencia, Contraria),
    delete(Acumuladas, Contraria, SinContraria),
    delete(SinContraria, Preferencia, Resto).


% ----- Reglas de recomendacion -----

descartada(Profesion, Preferencias) :-
    profesion(Profesion, _, Incompatibles),
    member(Interes, Incompatibles),
    member(negativa(Interes), Preferencias).

coincidencias(Profesion, Preferencias, Total) :-
    profesion(Profesion, Afinidades, _),
    findall(Interes,
            ( member(Interes, Afinidades),
              member(positiva(Interes), Preferencias) ),
            Comunes),
    length(Comunes, Total).

compatible(Profesion, Preferencias, Total) :-
    coincidencias(Profesion, Preferencias, Total),
    Total > 0,
    \+ descartada(Profesion, Preferencias).

recomendar(Preferencias) :-
    findall(Total-Profesion,
            compatible(Profesion, Preferencias, Total),
            Pares),
    Pares \= [],
    !,
    pairs_keys(Pares, Totales),
    max_list(Totales, Maximo),
    findall(Profesion, member(Maximo-Profesion, Pares), Mejores),
    mostrar_recomendacion(Mejores).
recomendar(_) :-
    write('OrientadorCE: No tengo una recomendacion compatible con tus preferencias.'), nl.


% ----- Mostrar resultado -----

mostrar_recomendacion([Profesion]) :-
    nombre_legible(Profesion, Nombre),
    write('OrientadorCE: Segun tus preferencias, te recomiendo '),
    write(Nombre), write('.'), nl.
mostrar_recomendacion(Profesiones) :-
    Profesiones = [_, _|_],
    write('OrientadorCE: Segun tus preferencias, te recomiendo alguna de estas opciones:'), nl,
    mostrar_lista(Profesiones).

mostrar_lista([]).
mostrar_lista([Profesion|Resto]) :-
    nombre_legible(Profesion, Nombre),
    write('  - '), write(Nombre), nl,
    mostrar_lista(Resto).

nombre_legible(Profesion, Nombre) :-
    atomic_list_concat(Palabras, '_', Profesion),
    atomic_list_concat(Palabras, ' ', Nombre).
