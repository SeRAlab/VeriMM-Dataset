module top_module (
    input wire a,
    input wire b,
    output wire y,
    output wire z
);

    assign y = a | b;
    assign z = ~y;

endmodule