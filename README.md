# 🚀 Debris Track LEO

**Debris Track LEO** es un software en versión beta diseñado para rastrear y visualizar en tiempo real los desechos orbitales.  
El proyecto integra datasets de la **Oficina del Programa de Desechos Orbitales de la NASA (ODPO)**, la API de la **Estación Espacial Internacional (ISS)**, observaciones de **NEOSSAT** (CSA, Agencia Espacial Canadiense) y archivos históricos de **Landsat** (USGS).

Al validar los modelos orbitales con los parámetros dinámicos en tiempo real de la ISS, **Debris Track** asegura precisión en el rastreo y ofrece una base para operaciones sostenibles y comerciales en la órbita baja terrestre (LEO).

---

## 📌 Descripción del Proyecto

- **Problema**: LEO está cada vez más saturada de desechos orbitales, lo que representa un riesgo para satélites, la ISS y futuras actividades comerciales. Las herramientas actuales son demasiado técnicas o demasiado simples, y rara vez combinan datos reales con visualizaciones accesibles.  
- **Solución**: Un software beta que combina **datasets reales + modelado matemático** para crear una herramienta interactiva capaz de rastrear desechos, validar modelos orbitales y apoyar la toma de decisiones en la comercialización del LEO.  
- **Visión**: Escalar desde un prototipo de investigación hacia una herramienta global que permita a científicos, responsables políticos, industria y público gestionar el entorno orbital de manera sostenible.

---

## ⚙️ Cómo Funciona

**Entrada**  
- Datasets de NASA ODPO (*ARES Quarterly News*)  
- API de la ISS (posición, velocidad, altitud)  
- Archivos astronómicos FITS de NEOSSAT (CSA)  
- Datos Landsat del USGS (caso Landsat 4, explosión de propulsor)

**Procesamiento**  
- Modelos orbitales en **Python**  
- Motor de visualización en **Godot** (GDScript + integración con Python)  
- Validación con el rastreo de la órbita de la ISS

**Salida**  
- Visualización interactiva en tiempo real de desechos en LEO  
- Simulaciones educativas y de apoyo a la toma de decisiones

---

## 🌍 Beneficios

- **Científicos**: Modelos validados y confiables.  
- **Industria espacial**: Herramienta de soporte a la toma de decisiones para operadores satelitales.  
- **Responsables políticos**: Visualizaciones accesibles para políticas de sostenibilidad espacial.  
- **Educación y público**: Plataforma didáctica para concientizar sobre el problema de los desechos orbitales.

---

## 🛠️ Tecnologías Utilizadas

- **Lenguajes**: Python, GDScript  
- **Motor**: Godot  
- **Formatos de datos**: TLE, FITS, imágenes Landsat  
- **Herramientas**: SaoImage DS9, script propio (*NEOSSAT_Data.py*)

---

## 📊 Estado Actual (Beta)

✅ Rastreo en tiempo real de desechos orbitales  
✅ Integración con datasets de NASA, CSA y USGS  
✅ Validación con parámetros dinámicos de la ISS  

🚧 Próximos pasos:  
- Modelado predictivo de colisiones  
- Dashboards web para industria y políticas  
- Interfaz más accesible para usuarios no expertos

---

## 🔮 Visión a Futuro

**Debris Track LEO** busca evolucionar hacia una **plataforma de nivel comercial** para operaciones sostenibles en LEO.  

Próximas funcionalidades:  
- Analítica predictiva para evitar colisiones  
- Dashboards comerciales para operadores satelitales  
- Integración web y móvil  
- Colaboración con agencias espaciales y sector privado

---

## 🤝 Contribuciones

Este proyecto inició como parte del **NASA Space Apps Challenge 2025** y actualmente se encuentra en versión beta.  
Se reciben sugerencias y colaboraciones para expandir **Debris Track** hacia una plataforma operativa completa.

---

## 📜 Licencia

Este proyecto está licenciado bajo la **GNU General Public License v3.0 (GPL-3.0)**.  
Consulta el archivo [LICENSE](./LICENSE) para más detalles.
