module top_module(inv, clk,out, in);input [31:0] in;
output [31:0] out;
input inv, clk;
wire clk2;
reg [31:0] out;
assign clk2 = clk &  inv;
always  @(posedge clk2) begin
   out <= in;
end
endmodule