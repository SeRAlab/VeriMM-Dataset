module mux_4bit_2to1(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire sel,
    output wire [3:0] y
);

    assign y = sel ? b : a;

endmodule