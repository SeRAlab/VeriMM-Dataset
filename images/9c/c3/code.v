module top_module(
input wire [7:0]seleccion,
input wire [7:0]tecla,
input wire [7:0] tecla2,
input wire [7:0] tecla3,
input wire [7:0]RG1,
input wire [7:0]RG2,
input wire [7:0]RG3,
input wire listo,
input wire listo_lee,
input wire listo_escribe,
output reg [7:0]salida_mux_deco
    );always @(seleccion, listo, listo_lee,listo_escribe)
      case (seleccion)
         8'b00000000: salida_mux_deco = 8'h00;
         8'b00000001: salida_mux_deco = {7'b0000000,listo};
         8'b00000010: salida_mux_deco = {7'b0000000,listo_escribe};
         8'b00000011: salida_mux_deco = {7'b0000000,listo_lee};
         8'b00000100: salida_mux_deco = 8'h02;
         8'b00000101: salida_mux_deco = 8'h10;
         8'b00000110: salida_mux_deco = 8'h00;
         8'b00000111: salida_mux_deco = 8'hd2;
			8'b00001000: salida_mux_deco = 8'h01;
         8'b00001001: salida_mux_deco = 8'hf1;
         8'b00001010: salida_mux_deco = 8'h21;
			8'b00001011: salida_mux_deco = 8'h22;
         8'b00001100: salida_mux_deco = 8'h23;
         8'b00001101: salida_mux_deco = 8'h24;
         8'b00001110: salida_mux_deco = 8'h25;
			8'b00001111: salida_mux_deco = 8'h26;
         8'b00010000: salida_mux_deco = 8'h41;
         8'b00010001: salida_mux_deco = 8'h42;
			8'b00010010: salida_mux_deco = 8'h43;
		   8'b00010011: salida_mux_deco = 8'h03;
			8'b00010100: salida_mux_deco = 8'h04;
         8'b00010101: salida_mux_deco = 8'h05;
         8'b00010110: salida_mux_deco = 8'h06;
         8'b00010111: salida_mux_deco = 8'h07;
			8'b00011000: salida_mux_deco = 8'h08;
         8'b00011001: salida_mux_deco = tecla; 
         8'b00011010: salida_mux_deco = RG1; 
			8'b00011011: salida_mux_deco = RG2; 
			8'b00011100: salida_mux_deco = RG3; 
			8'b00011101: salida_mux_deco = tecla2;
         8'b00011110: salida_mux_deco = tecla3;
         8'b00011111: salida_mux_deco = 8'hf0;
         8'b00100000: salida_mux_deco = 8'hf2;
			
			
			default: salida_mux_deco = 8'h00;
      endcase
		
	
endmodule