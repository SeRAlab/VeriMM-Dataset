module top_module(
input wire [7:0]seleccion,
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
			default: salida_mux_deco = 8'h00;
      endcase
		
	
endmodule