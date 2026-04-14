module xnor_4input (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire y
);
    wire ab_xnor, cd_xnor;

    // Compute XNOR for first two inputs
    assign ab_xnor = ~(a ^ b);
    // Compute XNOR for last two inputs
    assign cd_xnor = ~(c ^ d);
    // Final XNOR for the two intermediate XNOR outputs
    assign y = ab_xnor & cd_xnor;
endmodule