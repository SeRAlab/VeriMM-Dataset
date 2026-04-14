module mux_2to1 (
    input [7:0] A,
    input [7:0] B,
    input sel,
    output [7:0] Y
);

    assign Y = sel ? B : A;

endmodule