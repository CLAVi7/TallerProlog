
% ==========================================
% OrientadorCE - Gramatica de preferencias
% ==========================================
% Reconoce frases afirmativas y negativas.
% Devuelve positiva(Interes) o negativa(Interes).
%
% Para probar:
% phrase(oracion(R), [me, gusta, la, tecnologia]).
% ==========================================

% ----- Estructuras de oraciones -----

oracion(positiva(Interes)) -->
    [me, gusta],
    interes(Interes).

oracion(positiva(Interes)) -->
    [me, gustan],
    interes(Interes).

oracion(positiva(Interes)) -->
    [me, interesa],
    interes(Interes).

oracion(positiva(Interes)) -->
    [disfruto],
    interes(Interes).

oracion(positiva(Interes)) -->
    [prefiero],
    interes(Interes).

% ----- Oraciones negativas -----

oracion(negativa(Interes)) -->
    [no, me, gusta],
    interes(Interes).

oracion(negativa(Interes)) -->
    [no, me, gustan],
    interes(Interes).

oracion(negativa(Interes)) -->
    [no, me, interesa],
    interes(Interes).

oracion(negativa(Interes)) -->
    [no, disfruto],
    interes(Interes).

oracion(negativa(Interes)) -->
    [no, prefiero],
    interes(Interes).

% ----- Vocabulario de intereses -----

interes(tecnologia) -->
    [la, tecnologia].

interes(tecnologia) -->
    [trabajar, con, tecnologia].

interes(matematicas) -->
    [las, matematicas].

interes(resolver_problemas) -->
    [resolver, problemas].

interes(ayudar_personas) -->
    [ayudar, a, las, personas].

interes(escuchar) -->
    [escuchar, a, los, demas].

interes(biologia) -->
    [la, biologia].

interes(ciencias) -->
    [las, ciencias].

interes(diseno) -->
    [el, diseno].

interes(creatividad) -->
    [la, creatividad].

interes(lectura) -->
    [la, lectura].

interes(comunicacion) -->
    [la, comunicacion].

interes(negocios) -->
    [los, negocios].

interes(ensenar) -->
    [ensenar].

interes(construccion) -->
    [la, construccion].

interes(animales) -->
    [los, animales].
% Convierte una frase de texto en una preferencia.
interpretar(Texto, Resultado) :-
    string_lower(Texto, Minusculas),
    split_string(Minusculas, " ", ".,!? ", Palabras),
    maplist(atom_string, Tokens, Palabras),
    phrase(oracion(Resultado), Tokens).


:- encoding(utf8).

% Validacion adicional de concordancia y normalizacion.
interpretar_validado(Texto, Resultado) :-
    string(Texto),
    string_lower(Texto, Minusculas),
    string_chars(Minusculas, Caracteres),
    maplist(normalizar_bnf, Caracteres, Normalizados),
    string_chars(Normalizada, Normalizados),
    split_string(Normalizada, " \t\r\n", " \t\r\n.,!?¡¿", Palabras),
    maplist(atom_string, Tokens, Palabras),
    once(phrase(oracion_validada(Resultado), Tokens)).

oracion_validada(positiva(Interes)) -->
    afirmacion_validada(Interes).

oracion_validada(negativa(Interes)) -->
    [no],
    afirmacion_validada(Interes).

afirmacion_validada(Interes) -->
    [me, gusta], interes_singular(Interes).

afirmacion_validada(Interes) -->
    [me, gustan], interes_plural(Interes).

afirmacion_validada(Interes) -->
    [me, interesa], interes_singular(Interes).

afirmacion_validada(Interes) -->
    [me, interesan], interes_plural(Interes).

afirmacion_validada(Interes) -->
    [disfruto], interes(Interes).

afirmacion_validada(Interes) -->
    [prefiero], interes(Interes).

% Reutiliza el vocabulario original sin modificarlo.
interes_singular(Interes) -->
    interes(Interes),
    { \+ interes_es_plural(Interes) }.

interes_plural(Interes) -->
    interes(Interes),
    { interes_es_plural(Interes) }.

interes_es_plural(matematicas).
interes_es_plural(ciencias).
interes_es_plural(negocios).
interes_es_plural(animales).

normalizar_bnf('á', a) :- !.
normalizar_bnf('é', e) :- !.
normalizar_bnf('í', i) :- !.
normalizar_bnf('ó', o) :- !.
normalizar_bnf('ú', u) :- !.
normalizar_bnf('ü', u) :- !.
normalizar_bnf('ñ', n) :- !.
normalizar_bnf(Caracter, Caracter).