module top_module(input wire clk_in, output wire clk_out);reg [1:0] divcounter = 0;


always @(posedge clk_in)
  if (divcounter == 2)
    divcounter <= 0;
  else
    divcounter <= divcounter + 1;


assign clk_out = divcounter[1];

endmodule