module top_module(out,in);input [31:0] in;
output [31:0] out;
wire [7:0] temp;
assign temp=(in[31]==1)?8'hFF:8'h00;
assign out={temp,in[31:8]};endmodule