module top_module(
    input A,
    input B,
    input C,
    output X
);wire and0_out;
    wire and1_out;

    // Replace the unknown sky130_fd_sc_hd__and2 instances with basic gate implementations
    // First AND gate
    assign and0_out = A & B;

    // Second AND gate
    assign and1_out = and0_out & C;

    // Output of and3 is the output of the second AND gate
    assign X = and1_out;

endmodule