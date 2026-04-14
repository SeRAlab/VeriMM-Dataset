module top_module(
    input [3:0] B,
    output [3:0] G
);reg [3:0] G_reg1, G_reg2, G_reg3;

assign G = G_reg3;

// Pipeline stage 1
assign G_reg1[0] = B[0];
assign G_reg1[1] = B[0] ^ B[1];
assign G_reg1[2] = B[1] ^ B[2];
assign G_reg1[3] = B[2] ^ B[3];

// Pipeline stage 2
assign G_reg2[0] = G_reg1[0];
assign G_reg2[1] = G_reg1[1] ^ G_reg1[0];
assign G_reg2[2] = G_reg1[2] ^ G_reg1[1];
assign G_reg2[3] = G_reg1[3] ^ G_reg1[2];

// Pipeline stage 3
assign G_reg3[0] = G_reg2[0];
assign G_reg3[1] = G_reg2[1] ^ G_reg2[0];
assign G_reg3[2] = G_reg2[2] ^ G_reg2[1];
assign G_reg3[3] = G_reg2[3] ^ G_reg2[2];

endmodule