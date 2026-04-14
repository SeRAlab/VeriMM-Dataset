module top_module(
    input A0, A1, A2, A3,
    input [1:0] S,
    output X
);// Declare intermediate wires
    wire and0_out, and1_out, and2_out, and3_out;
    wire or0_out, or1_out;

    // Implement AND gates using standard Verilog operators
    assign and0_out = A0 & ~S[1] & ~S[0];
    assign and1_out = A1 & ~S[1] & S[0];
    assign and2_out = A2 & S[1] & ~S[0];
    assign and3_out = A3 & S[1] & S[0];

    // Implement OR gate using standard Verilog operators
    assign or0_out = and0_out | and1_out;
    assign or1_out = and2_out | and3_out;

    // Assign output
    assign X = or0_out | or1_out;

endmodule