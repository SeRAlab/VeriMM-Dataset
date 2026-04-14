module top_module(entrada, saida);input wire [31:0] entrada;
    output reg [31:0] saida;
	
	always @ (entrada)
	
	saida <= entrada << 2;

endmodule