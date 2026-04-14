module top_module(pm,clk,rndout);input [63:0] pm; 
input clk; 
output [63:0] rndout; 
reg [63:0] t;



always @(posedge clk) 
begin
 t <= pm; 
end 
assign rndout=t;

endmodule