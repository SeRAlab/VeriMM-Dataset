module top_module (
    input wire x,
    input wire z,
    output wire w
);

    assign w = x ^ z;

endmodule