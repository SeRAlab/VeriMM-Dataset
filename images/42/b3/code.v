module top_module(
    input [3:0] B,
    output [3:0] G
);wire [3:0] shift_B;
    assign shift_B = {B[2:0], 1'b0};

    assign G[0] = B[0] ^ shift_B[0];
    assign G[1] = B[1] ^ shift_B[1];
    assign G[2] = B[2] ^ shift_B[2];
    assign G[3] = B[3] ^ shift_B[3];

endmodule