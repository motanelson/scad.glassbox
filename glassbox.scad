// ARMAÇÃO DE ÓCULOS COM LENTES REDONDAS
// Configurações personalizáveis

diametro_lente = 50;           // Diâmetro das lentes
distancia_entre_lentes = 70;   // Distância entre os centros das lentes
largura_estrutura = 6;         // Largura da estrutura que segura as lentes
comprimento_aste = 130;        // Comprimento das hastes
espessura_armacao = 5;         // Espessura do material da armação
angulo_aste = 15;              // Ângulo das hastes (graus)
// Dimensões do telemóvel (com folga de 0.5mm)
comprimento_tele = 75;    // Comprimento do telemóvel
altura_tele = 150;        // Altura do telemóvel  
profundidade_tele = 10;   // Profundidade/espessura do telemóvel
profundidade_caixa = 100;
folga = 0.5;              // Folga para encaixe

// Parâmetros da tampa
espessura_fundo = 1.5;    // Espessura do fundo
altura_borda = 3;         // Altura das bordas laterais
espessura_borda = 2;      // Espessura das bordas

// Buraco da câmera
percentual_camera = 0.15; // 15% das dimensões

// Trinco de encaixe
largura_trinco = 5;       // Largura do trinco
altura_trinco = 2;        // Altura do trinco
profundidade_trinco = 2;  // Profundidade do trinco

// ========== CÁLCULOS AUTOMÁTICOS ==========
comprimento_com_folga = comprimento_tele + 2*folga;
altura_com_folga = altura_tele + 2*folga;
profundidade_com_folga = profundidade_tele + folga;

// Dimensões do buraco da câmera
largura_camera = comprimento_tele * percentual_camera;
altura_camera = altura_tele * percentual_camera;


// ========== CÁLCULOS DERIVADOS ==========
raio_lente = diametro_lente / 2;
raio_externo = raio_lente + largura_estrutura;

// ========== MÓDULOS PRINCIPAIS ==========

// Aro para lente
module aro_lente(centro_x) {
    color("Yellow")
    translate([centro_x, 0, 0]) {
        difference() {
            // Aro externo
            cylinder(h = espessura_armacao, r = raio_externo, center = true, $fn = 100);
            
            // Corte interno para lente
            cylinder(h = espessura_armacao + 1, r = raio_lente, center = true, $fn = 100);
        }
        color("Yellow")
        // Ponte de conexão entre aros
        if (centro_x < 0) {
            translate([raio_externo, -raio_externo, 0])
            cube([distancia_entre_lentes , 
                  largura_estrutura, espessura_armacao], center = true);
        }
    }
}

// Ponte nasal
module ponte_nasal() {
    largura_ponte = distancia_entre_lentes - diametro_lente - largura_estrutura;
    color("Yellow")
    translate([0, -raio_externo/2 + largura_estrutura/2, 0])
    cube([largura_ponte, largura_estrutura, espessura_armacao], center = true);
}

// Haste dos óculos
module haste(lado) {
    // lado: -1 para esquerda, 1 para direita
    
    x_inicio = -(distancia_entre_lentes/2 + raio_externo);
    
    angulo = 180;
color("Yellow")
    translate([x_inicio, -largura_estrutura/2, 0])
    rotate([0, 0, 0])
        
    cube([ espessura_armacao,largura_estrutura, comprimento_aste], center = false);
}
module haste2(lado) {
    // lado: -1 para esquerda, 1 para direita
    
    x_inicio = -(-distancia_entre_lentes+espessura_armacao+(largura_estrutura/2) );
    
    angulo = 180;
color("Yellow")
    translate([x_inicio, -largura_estrutura/2, 0])
    rotate([0, 0, 0])
    
    
    cube([ espessura_armacao,largura_estrutura, comprimento_aste], center = false);
}

// Sistema de dobradiça (opcional)
module dobradica(lado) {
    x_pos = lado * (distancia_entre_lentes/2 + raio_externo);
    color("Yellow")
    translate([x_pos, 0, 0])
    rotate([0, 90, 0])
    cylinder(h = largura_estrutura * 2, r = 2, center = true, $fn = 30);
}
// Fundo da tampa
module fundo() {
    color("Yellow")
    translate([-largura_estrutura+largura_estrutura*0.9, diametro_lente*0.38, -profundidade_caixa])
    cube([distancia_entre_lentes+diametro_lente+(largura_estrutura*2),diametro_lente*0.35,  espessura_fundo],center=true);
}
module bordas() {
    color("Yellow")
    // Borda 1
    translate([-(distancia_entre_lentes+diametro_lente+(largura_estrutura))/2, -diametro_lente/2, -(profundidade_caixa)])
    cube([espessura_fundo, diametro_lente, profundidade_caixa]);

   color("Yellow")
    // Borda 2
    translate([(distancia_entre_lentes+diametro_lente+largura_estrutura)/2, -diametro_lente/2, -(profundidade_caixa)])
     
    cube([espessura_fundo, diametro_lente, profundidade_caixa]);
   color("Yellow")
    // Borda fundo
    translate([(distancia_entre_lentes+diametro_lente+largura_estrutura)/2, -diametro_lente/2, -(profundidade_caixa)])
    cube([espessura_fundo, diametro_lente, profundidade_caixa]);
    color("Yellow")
    // Borda top
    translate([-(distancia_entre_lentes+diametro_lente+(largura_estrutura))/2, -diametro_lente/2, -(profundidade_caixa)+profundidade_tele])
    cube([distancia_entre_lentes+diametro_lente+(largura_estrutura),espessura_fundo , profundidade_caixa-profundidade_tele]);

    color("Yellow")
    // Borda down
    translate([-(distancia_entre_lentes+diametro_lente+(largura_estrutura))/2, diametro_lente/2, -(profundidade_caixa)])
    cube([distancia_entre_lentes+diametro_lente+(largura_estrutura),espessura_fundo , profundidade_caixa]);
}
// ========== MONTAGEM FINAL ==========
union() {
    // Aro esquerdo
    aro_lente(-distancia_entre_lentes/2);
    
    // Aro direito
    aro_lente(distancia_entre_lentes/2);
    
    // Ponte nasal
    ponte_nasal();
    
    // Hastes
    haste(-1); // Haste esquerda
    haste2(1);  // Haste direita
    
    // Dobradiças
    dobradica(-1);
    dobradica(1);
    // Fundo da tampa
    
}
fundo();
bordas();
// ========== VISUALIZAÇÃO DAS LENTES ==========
// Lente esquerda (visualização)
/*
translate([-distancia_entre_lentes/2, 0, 0])
color("Yellow", 0.3)
cylinder(h = 1, r = raio_lente, center = true, $fn = 100);
*/
// Lente direita (visualização)
/*
translate([distancia_entre_lentes/2, 0, 0])
color("Yellow", 0.3)
cylinder(h = 1, r = raio_lente, center = true, $fn = 100);
*/
// ========== INFORMAÇÕES TÉCNICAS ==========
