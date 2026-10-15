taller prolog: Orientador CE
Miembros: Sebastian Alvarado, Javier Barraza, Jose Umaña, Pablo Rivera

1. Instrucciones para ejecutar y utilizar el programa.
- Responsable: Javier.

Requiere SWI-Prolog 8.4 o superior. Desde la carpeta OrientadorCE: `swipl Logic.pl` y luego `?- iniciar.` (Logic.pl carga BD.pl y BNF.pl). Cada pregunta se responde con una frase completa, por ejemplo "Me gustan las matemáticas" o "No me gusta la tecnología"; si no se reconoce, el programa pide reformularla. Pruebas: `swipl PruebasBNF.pl` y luego `?- run_tests.`

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

Se agregó interpretar_validado/2 para validar concordancia y normalizar
tildes. Ejemplos: “Me gusta la tecnología” y “No me gusta la tecnología”.
Gramática formal: [BNF.md](BNF.md). Pruebas: PruebasBNF.pl.

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
  Con matemáticas y resolver problemas, cambiar “Me gusta la tecnología” por “No me gusta la tecnología” cambió la recomendación de Computadores
  a Civil. Esperado y obtenido coinciden: pasó.

- Javier: caso 4 (respuesta no reconocida).

  Con "La ventana está abierta." como primera respuesta, el programa pidió reformular sin registrar nada; luego "Me gustan las matemáticas.", "Me gusta la tecnología.", "Me gusta resolver problemas.", "No me interesa ayudar a las personas." y "No me gusta escuchar a los demás." dieron Ingeniería en Computadores. Esperado y obtenido coinciden: pasó (tests caso4 en PruebasBNF.pl).

- José: caso 5 (perfil sin coincidencias).

  Caso 5 (perfil sin coincidencias):
  - Entradas, en el orden de las 5 preguntas: "Me gusta la tecnologia", "Me gusta la tecnologia", "No me gustan las matematicas", "No me gusta el diseno", "No me gusta escuchar a los demas".
  - Resultado esperado: informa que no tiene una recomendación compatible, sin fallar.
  - Resultado obtenido: "No tengo una recomendacion compatible con tus preferencias."
  - Estado: pasó.
  - Justificación: en BD.pl la tecnología es afinidad solo de ingenieria_computadores y diseno_grafico. La primera se descarta porque matematicas está en sus incompatibilidades y fue rechazada. La segunda se descarta porque diseno está en sus incompatibilidades y también fue rechazado. Las demás profesiones no tienen coincidencias y la regla compatible/3 exige al menos una.

6. Limitaciones conocidas.
- Responsable: Javier.

Vocabulario cerrado (16 intereses y 6 estructuras), una preferencia por frase (sin "y" ni "pero"), la respuesta no se relaciona con la pregunta hecha, siempre son las mismas 5 preguntas y todas las afinidades pesan igual. Los nombres de profesión se muestran sin tildes.
