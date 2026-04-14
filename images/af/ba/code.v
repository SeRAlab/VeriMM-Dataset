module top_module(
    input [15:0] A,
    input [3:0] B,
    output [15:0] shift_left,
    output [15:0] shift_right
);assign shift_left = A << B;
    assign shift_right = A >> B;

endmodule