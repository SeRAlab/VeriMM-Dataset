module top_module(out,in);input [31:0] in;
output [31:0] out;
wire [15:0] temp;
assign temp=(in[31]==1)?16'hFFFF:16'h0000;
assign out={temp,in[31:16]};endmodule