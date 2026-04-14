module multiplier_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] result
);
    assign result = A * B;
endmodule