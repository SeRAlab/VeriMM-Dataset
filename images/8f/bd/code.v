module top_module(q,clk,d,reset,en);input clk,d,reset,en;
output reg q;

always@(posedge clk, posedge reset )
begin

if (reset == 1)

q <= 1'b0;

else if (en == 0)
  q<=q;

else
 q <= d;
 
end
endmodule