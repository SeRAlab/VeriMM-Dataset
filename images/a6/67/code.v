module top_module (
    input wire p,
    input wire q,
    input wire r,
    input wire s,
    output wire t
);

    assign t = p & q & r & s;

endmodule