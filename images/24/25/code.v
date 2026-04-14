module mux2to1 (
    input [7:0] A,
    input [7:0] B,
    input S,
    output [7:0] Y
);
    assign Y = (S == 1'b0) ? A : B;
endmodule