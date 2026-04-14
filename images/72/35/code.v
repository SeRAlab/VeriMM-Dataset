module top_module(
    input A,
    input B,
    input C_N,
    output X
);// Instantiate a 3-input OR gate with the correct model name
    // Replace 'sky130_fd_sc_ls__or3b' with a valid gate if it's not found
    wire or_output;

    assign or_output = A | B | ~C_N; // A OR B OR NOT C_N
    assign X = or_output;

endmodule