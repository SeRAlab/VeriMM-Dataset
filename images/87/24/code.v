module mux_2to1(
    input a,
    input b,
    input sel,
    output y
);

    assign y = sel ? b : a; // Select between a and b based on sel

endmodule