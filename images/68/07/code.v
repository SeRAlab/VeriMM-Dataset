module top_module(out,in);input [31:0] in;
output [31:0] out;
wire [1:0] temp;
assign temp=(in[31]==1)?2'b11:2'b00;
assign out={temp,in[31:2]};endmodule