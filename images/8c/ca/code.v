module top_module(D,clk,Q);input [2:0] D; 
input clk; 
output reg [2:0] Q; 
always @(posedge clk) 
begin
 Q <= D; 
end 
endmodule