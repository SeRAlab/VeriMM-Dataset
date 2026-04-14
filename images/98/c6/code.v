module majority (
    input wire a,
    input wire b,
    input wire c,
    output wire m
);

    assign m = (a & b) | (a & c) | (b & c);

endmodule