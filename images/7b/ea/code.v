module top_module(in,out);input [13:0] in;
output reg [11:0] out;

always @(in)
begin

out[0] = in[3];
out[1] = in[3]^in[8];
out[2] = in[2]|in[1];
out[3] = in[2]^in[0];
out[4] = in[5];
out[5] = in[0]&in[9];
out[6] = in[4]^in[6];
out[7] = in[7]&in[8];
out[8] = in[1]^in[2];
out[9] = in[1]&in[3]&in[5];
out[10] = in[2];
out[11] = in[6]^in[9];

end


endmodule