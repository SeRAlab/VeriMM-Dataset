module top_module (
    input wire [1:0] a,
    input wire [1:0] b,
    input wire sel,
    output wire [1:0] y
);

    assign y = sel ? b : a;

endmodule