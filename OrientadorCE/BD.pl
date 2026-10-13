
% ==================================================
% OrientadorCE - Base de conocimientos
% ==================================================
%
% profesion(Nombre, Afinidades, Incompatibilidades).
%
% Afinidades: intereses positivos relacionados con
% la profesion.
%
% Incompatibilidades: intereses cuyo rechazo
% descarta la profesion.
% ==================================================

profesion(ingenieria_computadores,
    [matematicas, tecnologia, resolver_problemas],
    [matematicas, tecnologia]).

profesion(psicologia,
    [ayudar_personas, escuchar, comunicacion],
    [ayudar_personas, escuchar]).

profesion(medicina,
    [biologia, ciencias, ayudar_personas],
    [biologia, ayudar_personas]).

profesion(arquitectura,
    [diseno, creatividad, matematicas],
    [diseno, creatividad]).

profesion(derecho,
    [lectura, comunicacion, ayudar_personas],
    [lectura, comunicacion]).

profesion(administracion,
    [negocios, comunicacion, resolver_problemas],
    [negocios, comunicacion]).

profesion(educacion,
    [ensenar, comunicacion, ayudar_personas],
    [ensenar, ayudar_personas]).

profesion(diseno_grafico,
    [diseno, creatividad, tecnologia],
    [diseno, creatividad]).

profesion(ingenieria_civil,
    [matematicas, construccion, resolver_problemas],
    [matematicas, construccion]).

profesion(veterinaria,
    [animales, biologia, ayudar_personas],
    [animales, biologia]).
