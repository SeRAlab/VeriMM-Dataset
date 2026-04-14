module mux2to1 (
    input [4:0] A,
    input [4:0] B,
    input sel,
    output [4:0] Y
);
    assign Y = sel ? B : A;
endmodule