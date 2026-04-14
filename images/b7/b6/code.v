module top_module(A1, A2, O);input [3:0] A1;
input [3:0] A2;
output [3:0] O;

wire [3:0] xor1;
wire [3:0] xor2;
wire [3:0] xor3;
wire [3:0] xor4;

assign xor1 = A1 ^ A2;
assign xor2 = A1[2:0] ^ A2[2:0];
assign xor3 = A1[1:0] ^ A2[1:0];
assign xor4 = A1[0] ^ A2[0];

assign O = {xor1[3], xor2[2:0], xor3[1:0], xor4};

endmodule