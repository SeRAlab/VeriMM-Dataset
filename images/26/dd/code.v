module comb_logic (
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    output [7:0] Y
);
    assign Y = (A & B) | (~C);
endmodule