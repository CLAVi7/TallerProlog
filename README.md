taller prolog: Orientador CE
Miembros: Sebastian Alvarado, Javier Barraza, Jose Umaña, Pablo Rivera

1. Instrucciones para ejecutar y utilizar el programa.
- Responsable: Javier.
2. Descripción breve de los hechos, las reglas y las listas utilizadas.
  
El archivo BD.pl es conformado por los conocimientos que formar al OrientadorCE, estos estan representados mediante hechos y listas de prolog. Utilizamos el predicado profesion/3, donde se almacenan los nombres de cada profesion y sis afinidades e incompatibilidades asignadas.

se inccluyen 10 profeseciones, contando con 3 afinidades y 2 incompatibilidades cada una, afinidades son los intereses relacionados con la profesion y las incompatibilidades son intereses cuyo rechaxo puede descartar dicha profesion. permite que las recomendaciones construidas con las reglas de Logic.pl determinen las profesiones compatibles con el usuario.

- Responsable: José (reglas de recomendación de Logic.pl).

Las preferencias que interpreta la gramática se guardan en una lista de términos positiva(Interes) y negativa(Interes), por ejemplo [positiva(tecnologia), negativa(diseno)]. Si el usuario dice lo contrario de algo ya registrado, la última frase reemplaza a la anterior.

Reglas principales de Logic.pl:
- descartada/2: una profesión queda descartada si alguna de sus incompatibilidades aparece como negativa en la lista de preferencias.
- coincidencias/3: cuenta cuántas afinidades de la profesión aparecen como positiva.
- compatible/3: una profesión es compatible si no está descartada y tiene al menos una coincidencia.
- recomendar/1: reúne las profesiones compatibles y muestra las que tienen más coincidencias, o avisa que no hay ninguna.

Las preguntas son hechos pregunta/1 y la conversación (preguntar, pedir que reformulen y mostrar el resultado) se controla con iniciar/0.

3. Gramática BNF y ejemplos de frases admitidas.
- Responsable: Sebastián.

Se agregó interpretar_validado/2 sin modificar las reglas originales.
Reutiliza el vocabulario de interes//1, valida singular y plural,
normaliza tildes y devuelve positiva(Interes) o negativa(Interes).

```bnf
<oracion> ::= <afirmacion> | "no" <afirmacion>
<afirmacion> ::= "me gusta" <singular>
              | "me gustan" <plural>
              | "me interesa" <singular>
              | "me interesan" <plural>
              | "disfruto" <interes>
              | "prefiero" <interes>
<interes> ::= <singular> | <plural>
<singular> ::= "la tecnologia" | "la biologia" | "el diseno"
            | "la creatividad" | "la lectura" | "la comunicacion"
            | "la construccion" | "trabajar con tecnologia"
            | "resolver problemas" | "ayudar a las personas"
            | "escuchar a los demas" | "ensenar"
<plural> ::= "las matematicas" | "las ciencias"
           | "los negocios" | "los animales"
```

Ejemplos:
- "Me gusta la tecnología" → positiva(tecnologia).
- "No me gusta la tecnología" → negativa(tecnologia).
- "Me interesan las ciencias" → positiva(ciencias).

Se rechazan errores de concordancia, vocabulario desconocido y
respuestas aisladas como "sí" o "no".

Pruebas: cargar PruebasBNF.pl y ejecutar run_tests.
Resultado: 24 pruebas aprobadas.

4. Explicación del procedimiento utilizado para generar recomendaciones.
- Responsable: José.

El programa hace una pregunta a la vez y guarda cada frase reconocida como positiva o negativa. Una frase que la gramática no reconoce no se registra y se pide de nuevo. Cuando terminan las preguntas, se aplica este criterio a cada profesión de BD.pl:

1. Se descarta si el usuario rechazó (negativa) alguna de sus incompatibilidades.
2. Entre las que quedan, se cuentan las afinidades que el usuario marcó como positiva. Se necesita al menos una coincidencia.
3. Se recomienda la profesión con más coincidencias. Si hay empate, se muestran todas las empatadas.
4. Si ninguna profesión cumple lo anterior, el programa informa que no tiene una recomendación compatible.
5. Los cinco casos de prueba, con resultados esperados y obtenidos.
- Pablo: casos 1 y 2 (perfil tecnológico y social).
- Sebastián: caso 3 (negación de una afinidad).
  Entradas:
    1. Me gustan las matemáticas.
    2. Me gusta la tecnología.
    3. Me gusta resolver problemas.
    4. No me interesa ayudar a las personas.
    5. No me gusta escuchar a los demás.
  Se repite cambiando únicamente la segunda frase por
  "No me gusta la tecnología".
  Esperado y obtenido en las pruebas automatizadas:
  - Afirmativa: ingenieria_computadores, con 3 coincidencias.
  - Negativa: ingenieria_civil, con 2 coincidencias.
  Estado: pasó. La negación se registra como negativa(tecnologia)
  y descarta Computadores mediante descartada/2.
  Las pruebas usan interpretar_validado/2 y las reglas actuales
  de Logic.pl.

- Javier: caso 4 (respuesta no reconocida).
- José: caso 5 (perfil sin coincidencias).

  Caso 5 (perfil sin coincidencias):
  - Entradas, en el orden de las 5 preguntas: "Me gusta la tecnologia", "Me gusta la tecnologia", "No me gustan las matematicas", "No me gusta el diseno", "No me gusta escuchar a los demas".
  - Resultado esperado: informa que no tiene una recomendación compatible, sin fallar.
  - Resultado obtenido: "No tengo una recomendacion compatible con tus preferencias."
  - Estado: pasó.
  - Justificación: en BD.pl la tecnología es afinidad solo de ingenieria_computadores y diseno_grafico. La primera se descarta porque matematicas está en sus incompatibilidades y fue rechazada. La segunda se descarta porque diseno está en sus incompatibilidades y también fue rechazado. Las demás profesiones no tienen coincidencias y la regla compatible/3 exige al menos una.
