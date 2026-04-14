module top_module(entradas_i,salidas_o);input [2:0] entradas_i; 
  output [2:0] salidas_o; 
  assign salidas_o[2] = entradas_i[2]; 
  xor xorB(salidas_o[1], entradas_i[2], entradas_i[1]); 
  xor xorC(salidas_o[0], salidas_o[1], entradas_i[0]); 
 endmodule