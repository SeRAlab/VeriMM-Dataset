module top_module(entrada, saida);input[15:0] entrada;
output[31:0] saida;

assign saida[15:0] = entrada[15:0];
assign saida[31:16] = 16'd0;

endmodule