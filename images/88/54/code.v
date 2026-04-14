module top_module(
  input wire [4:0] entrada1,
  input wire [4:0] entrada2,
  input wire seletor,
  output reg [4:0] saida
);always @(*) saida <= (seletor) ? entrada1 : entrada2;
endmodule