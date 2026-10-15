:- encoding(utf8).
:- consult('Logic.pl').
:- use_module(library(plunit)).

:- begin_tests(gramatica).

test(afirmativa) :-
    interpretar_validado(
        "Me gusta la tecnología.",
        positiva(tecnologia)
    ).

test(negativa) :-
    interpretar_validado(
        "No me gusta la tecnología.",
        negativa(tecnologia)
    ).

test(plural) :-
    interpretar_validado(
        "Me gustan las matemáticas.",
        positiva(matematicas)
    ).

test(interesan) :-
    interpretar_validado(
        "Me interesan las ciencias.",
        positiva(ciencias)
    ).

test(actividad) :-
    interpretar_validado(
        "Disfruto trabajar con tecnología.",
        positiva(tecnologia)
    ).

test(preferencia) :-
    interpretar_validado(
        "Prefiero escuchar a los demás.",
        positiva(escuchar)
    ).

test(negacion_actividad) :-
    interpretar_validado(
        "No disfruto enseñar.",
        negativa(ensenar)
    ).

test(negacion_plural) :-
    interpretar_validado(
        "No me interesan los negocios.",
        negativa(negocios)
    ).

test(mayusculas_espacios) :-
    interpretar_validado(
        "  ¡ME\tGUSTA   LA TECNOLOGÍA!  ",
        positiva(tecnologia)
    ).

test(diseno_con_enie) :-
    interpretar_validado(
        "Me gusta el diseño.",
        positiva(diseno)
    ).

test(sin_tildes) :-
    interpretar_validado(
        "Me gusta la tecnologia",
        positiva(tecnologia)
    ).

test(gustan_con_singular, [fail]) :-
    interpretar_validado("Me gustan la tecnología", _).

test(gusta_con_plural, [fail]) :-
    interpretar_validado("Me gusta las matemáticas", _).

test(interesa_con_plural, [fail]) :-
    interpretar_validado("Me interesa los negocios", _).

test(gustan_con_actividad, [fail]) :-
    interpretar_validado("Me gustan resolver problemas", _).

test(disfruto_con_sustantivo) :-
    interpretar_validado(
        "Disfruto la tecnología",
        positiva(tecnologia)
    ).

test(frase_ajena, [fail]) :-
    interpretar_validado("La ventana está abierta", _).

test(solo_si, [fail]) :-
    interpretar_validado("sí", _).

test(solo_no, [fail]) :-
    interpretar_validado("no", _).

test(vacia, [fail]) :-
    interpretar_validado("", _).

test(doble_negacion, [fail]) :-
    interpretar_validado("No no me gusta la tecnología", _).

test(palabras_sobrantes, [fail]) :-
    interpretar_validado(
        "Me gusta la tecnología pero no las matemáticas",
        _
    ).

:- end_tests(gramatica).

% Las dos sesiones solo cambian su segunda respuesta.
perfil_caso3(FraseTecnologia, Perfil) :-
    Frases = [
        "Me gustan las matemáticas.",
        FraseTecnologia,
        "Me gusta resolver problemas.",
        "No me interesa ayudar a las personas.",
        "No me gusta escuchar a los demás."
    ],
    registrar_frases(Frases, [], Perfil).

registrar_frases([], Perfil, Perfil).

registrar_frases([Frase|Resto], Anterior, Perfil) :-
    interpretar_validado(Frase, Preferencia),
    registrar(Preferencia, Anterior, Nuevo),
    registrar_frases(Resto, Nuevo, Perfil).

:- begin_tests(caso3).

test(tecnologia_afirmada) :-
    perfil_caso3("Me gusta la tecnología.", Perfil),
    assertion(memberchk(positiva(tecnologia), Perfil)),
    assertion(\+ memberchk(negativa(tecnologia), Perfil)),
    once(compatible(ingenieria_computadores, Perfil, 3)),
    with_output_to(string(Salida), recomendar(Perfil)),
    assertion(
        Salida ==
        "OrientadorCE: Segun tus preferencias, te recomiendo ingenieria computadores.\n"
    ).

test(tecnologia_negada) :-
    perfil_caso3("No me gusta la tecnología.", Perfil),
    assertion(memberchk(negativa(tecnologia), Perfil)),
    assertion(\+ memberchk(positiva(tecnologia), Perfil)),
    once(descartada(ingenieria_computadores, Perfil)),
    assertion(\+ compatible(ingenieria_computadores, Perfil, _)),
    once(compatible(ingenieria_civil, Perfil, 2)),
    with_output_to(string(Salida), recomendar(Perfil)),
    assertion(
        Salida ==
        "OrientadorCE: Segun tus preferencias, te recomiendo ingenieria civil.\n"
    ).

:- end_tests(caso3).

% Caso 4: respuesta no reconocida 

% Ejecuta Meta leyendo las respuestas de la lista Respuestas (una por linea) en lugar del teclado, 
% y devuelve en Salida todo lo que el programa escribio en consola.
con_entrada(Respuestas, Meta, Salida) :-
    atomic_list_concat(Respuestas, '\n', Unidas),
    string_concat(Unidas, "\n", Texto),
    once(stream_property(Teclado, alias(user_input))),
    open_string(Texto, Entrada),
    setup_call_cleanup(
        set_stream(Entrada, alias(user_input)),
        with_output_to(string(Salida), Meta),
        ( set_stream(Teclado, alias(user_input)),
          close(Entrada) )).

veces(Texto, Subtexto, Total) :-
    aggregate_all(count, sub_string(Texto, _, _, _, Subtexto), Total).

:- begin_tests(caso4).

% La frase ajena no se registra: solo queda la preferencia valida.
test(no_registra_frase_ajena) :-
    con_entrada(
        ["La ventana está abierta.",
         "Me gustan las matemáticas."],
        preguntar(['Que te gusta?'], [], Preferencias),
        Salida),
    assertion(Preferencias == [positiva(matematicas)]),
    assertion(veces(Salida, "No entendi tu respuesta", 1)),
    assertion(veces(Salida, "Que te gusta?", 2)).

% Conversacion completa: pide reformular una vez y luego recomienda.
test(conversacion_completa) :-
    con_entrada(
        ["La ventana está abierta.",
         "Me gustan las matemáticas.",
         "Me gusta la tecnología.",
         "Me gusta resolver problemas.",
         "No me interesa ayudar a las personas.",
         "No me gusta escuchar a los demás."],
        iniciar,
        Salida),
    assertion(veces(Salida, "No entendi tu respuesta", 1)),
    assertion(veces(Salida,
        "te recomiendo ingenieria computadores.", 1)).

:- end_tests(caso4).