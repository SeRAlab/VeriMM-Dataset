module mux_2to1 (
    input [15:0] A,
    input [15:0] B,
    input S,
    output [15:0] Y
);
    assign Y = (S == 1'b0) ? A : B;
endmodule