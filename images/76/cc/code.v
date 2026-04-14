module mux2to1(
    input [7:0] a,
    input [7:0] b,
    input sel,
    output [7:0] y
);

    assign y = sel ? b : a;  // Select between a and b based on sel

endmodule