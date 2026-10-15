
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