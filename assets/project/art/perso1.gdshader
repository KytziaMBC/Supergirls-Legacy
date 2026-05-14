shader_type canvas_item;

// Variables que aparecerán en el Inspector (sección Shader Parameters)
uniform float suavidad_bordes : hint_range(0.0, 1.0) = 0.2; // Qué tanto se difuminan arriba y abajo
uniform float transparencia_total : hint_range(0.0, 1.0) = 1.0; // Un control extra de transparencia

void fragment() {
	// 1. Obtenemos el color rosa base del 'Default Color'
	vec4 color_base = COLOR;
	
	// --- LÓGICA HORIZONTAL (La que ya tenías: Desvanecimiento al final) ---
	float fade_horizontal = (1.0 - UV.x);
	
	// --- LÓGICA VERTICAL (NUEVA: Suavizar bordes arriba y abajo) ---
	// 'UV.y' va de 0.0 (arriba) a 1.0 (abajo).
	// Queremos opacidad en 0.5 (centro) y transparencia en 0.0 y 1.0.
	
	// Calculamos la distancia desde el centro (0.5)
	// Si UV.y es 0.5, la distancia es 0.0. Si es 0.0 o 1.0, la distancia es 0.5.
	float distancia_centro = abs(UV.y - 0.5);
	
	// Usamos 'smoothstep' para crear una curva de desvanecimiento suave en los bordes.
	// Definimos el inicio del desvanecimiento basado en la variable 'suavidad_bordes'.
	float inicio_fade = 0.5 - (suavidad_bordes * 0.5);
	
	// Calculamos el difuminado vertical. 1.0 es centro, 0.0 es borde.
	float fade_vertical = smoothstep(0.5, inicio_fade, distancia_centro);
	
	// --- COMBINACIÓN FINAL ---
	// Multiplicamos la transparencia base por la horizontal y la vertical
	color_base.a *= fade_horizontal * fade_vertical * transparencia_total;
	
	// Asignamos el resultado final
	COLOR = color_base;
}