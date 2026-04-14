module mux2_to_1(
    input [7:0] a,
    input [7:0] b,
    input sel,
    output [7:0] y
);

assign y = sel ? b : a;

endmodule