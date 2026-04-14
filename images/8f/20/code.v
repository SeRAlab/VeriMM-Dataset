module top_module (
    input [7:0] a,
    input [7:0] b,
    input sel,
    output [7:0] y
);

    assign y = sel ? b : a; // Select between inputs a and b

endmodule