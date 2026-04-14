module top_module(
    input wire a,
    input wire b,
    input wire ci,
    output wire s,
    output wire co
);assign {co, s} = a + b + ci; // Compute sum and carry-out
endmodule