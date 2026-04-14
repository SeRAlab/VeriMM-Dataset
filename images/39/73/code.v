module brent_kung_adder #(parameter N = 4) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] sum,
    output wire         carry_out
);
    wire [N:0] P; // Propagate
    wire [N:0] G; // Generate
    wire [N:0] C; // Carry

    // Generate and propagate signals
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : generate_pg
            assign P[i] = a[i] ^ b[i];
            assign G[i] = a[i] & b[i];
        end
    endgenerate

    assign C[0] = 0; // Initial carry
    // Carry generation
    generate
        for (i = 0; i < N; i = i + 1) begin : carry_generation
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum calculation
    assign sum = P ^ C[N-1:0];
    assign carry_out = C[N];

endmodule