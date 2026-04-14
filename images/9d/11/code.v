module top_module(
    input A,
    input B,
    input C,
    input D,
    output X
);wire or1_out;

    // Replace the unknown module with a behavioral implementation using assign
    assign or1_out = A | B | C | D;

    assign X = or1_out;

endmodule