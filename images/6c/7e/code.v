module mux_2to1 (
    input [1:0] a,
    input [1:0] b,
    input sel,
    output [1:0] out
);

    assign out = sel ? b : a;

endmodule