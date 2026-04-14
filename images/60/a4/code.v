module top_module(dado, clock, habilita_escrita, saida);input [7:0] dado;
	input clock;
	input habilita_escrita;
	output reg [7:0] saida;
	
	always@(posedge clock)
		if(habilita_escrita)
			saida <= dado;
		else
			saida <= 0;

endmodule