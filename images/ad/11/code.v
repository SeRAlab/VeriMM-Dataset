module top_module(entrada1,entrada2,salida);input[8:0]entrada1,entrada2;
output wire[8:0]salida;
assign salida=entrada1-entrada2;
endmodule