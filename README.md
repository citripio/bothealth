# TODOs

- [x] Invitar a usuarios inexistentes a registrarse dentro de un organization usando su email
- [x] Invitar a usuarios inexistentes a registrarse dentro de un organization usando facebook
- [x] Invitar a usuarios registrados a unirse a un organization
- [x] Registro con facebook sin traer lista de páginas
- [x] Hacer funcionar datepicker
- [x] Slugs para organizations
- [x] Arreglar colores de charts
- [ ] Agregar short URL para compartir un reporte incluyendo el date range y los items on/off del chart
- [ ] Agregar % indicators para blocked (vs. prev day, vs. prev period, etc, copiar UI de FB)
- [ ] Indicar (predecir) en cuántos días la página se quedaría sin users dado el total actual y los in/out diarios
- [ ] Arreglar chart. No respeta los nros que se le pasa en el array, usar como ejemplo biblical reflection y comparar los ranges 01-mar-2019/today contra 01-apr-2019/today

## ideas

```
Esto siempre pasó, con las apps, con los pushes y ahora con los bots.
Hay un % de usuarios que se van sobre el total de usuarios, si el % es 1 cuando tenes 1000 usuarios se te van 100 si tenemos 1.000.000 se van a ir 10.000.
Por eso te decia que agregues % en tu reporte y pongas el % en el dashboard para comparar rapidamente como esta ese inidice comparado con otras apps.
Tambien ahora que pienso, podes agregar ese indice en una grafica evolutiva por dia, asi si hacemos un cambio podemos ver si ese indice meyoró o no. (edited)
ese dato va a estar bueno comparar esta semana con la anterior y contra el mes anterior y contra el total historico, si el total te da 30% pero ayer estas en 15%, significa que estas un 50% mejor que en el total historico. tendrias que poder sacar ese calculo por cualquier periodo
por experiencia, comparar dia a dia para este tipo de apps masivas no te dice mucho
```

```
puedo hacer que el organization dashboard tenga unos tabs donde seleccionar el tipo de vista global:

churn | blocks | etc

- churn: mostraría una alerta roja en las apps que están perdiendo más users que lo que ganan, indicando el nro de días remaining para quedarse sin users. Verde y con flecha para arriba en las páginas que crecen
- blocks: puedo mostrar ya sea una alerta en los que tienen block rate superior a 3%, o en los que subieron 1.nX el block rate de un día/una semana a la otra
```