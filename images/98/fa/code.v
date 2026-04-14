module top_module(clk, reset, cont,add);input		clk;
input		reset;
input [63:0] add;
output	[63:0]	cont;


reg	[63:0]	cont;
always @ (posedge clk)
begin
  if (reset)
    cont <= 16'h0;
  else if (add)
    cont <= cont + add; 
  else 
    cont <= cont + 1'b1;
end
endmodule