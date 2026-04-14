module BitwiseAndWithControl (
    input [31:0] A,
    input [31:0] B,
    input control,
    output [31:0] C
);
    assign C = control ? 32'b0 : (A & B);
endmodule