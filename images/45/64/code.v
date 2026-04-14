module top_module(dato,clk,q);input dato, clk; 
output reg q;

always @ ( posedge clk)
begin
  q <= dato;
end
endmodule