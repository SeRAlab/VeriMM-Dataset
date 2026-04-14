module mux_2to1 (
    input [4:0] A,
    input [4:0] B,
    input S,
    output [4:0] Y
);
    assign Y = (S == 1'b0) ? A : B;
endmodule