module top_module(
dado_reg,
dado_contexto,
controle,
saida
);input [4:0] dado_reg, dado_contexto;
input controle;

output reg [4:0] saida;

always @(dado_reg or dado_contexto or controle) begin
	if(controle)
		saida = dado_contexto;
	else
		saida = dado_reg;
end

endmodule