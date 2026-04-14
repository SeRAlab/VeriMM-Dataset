module fulladder(in1, in2, carryin, out);
input [4:0] in1, in2;
input carryin;
output [4:0] out;
wire carry0, carry1, carry2, carry3;
assign carry0 = ((in1[0] ^ in2[0])&carryin) | (in1[0]&in2[0]);
assign carry1 = ((in1[1] ^ in2[1])&carry0) | (in1[1]&in2[1]);
assign carry2 = ((in1[2] ^ in2[2])&carry1) | (in1[2]&in2[2]);
assign carry3 = ((in1[3] ^ in2[3])&carry2) | (in1[3]&in2[3]);
assign out[0] = in1[0] ^ in2[0] ^ carryin;
assign out[1] = in1[1] ^ in2[1] ^ carry0;
assign out[2] = in1[2] ^ in2[2] ^ carry1;
assign out[3] = in1[3] ^ in2[3] ^ carry2;
assign out[4] = in1[4] ^ in2[4] ^ carry3;
endmodule