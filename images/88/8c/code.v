module top_module(clk,rstn,Load,data_in,data_out);input clk,rstn,Load;
input [33:0] data_in;
output [33:0] data_out;
reg [33:0] d;
always @(posedge clk) begin
if(rstn==1'b0) d<=34'b1001100101000000001000100100010111;
else if(Load==1'b1) d<=data_in;
else d<=data_out;
end
assign data_out=d;
endmodule