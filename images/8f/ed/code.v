module top_module(
    input A,
    input B,
    input C_N,
    input D_N,
    output X
);// Change the module instance to a known OR4 gate,
// Since the original module 'sky130_fd_sc_hdll__or4bb_2' is not recognized,
// I will use a simple 4-input OR gate implementation.
wire or_out;
wire c, d;

assign c = ~C_N;  // Invert C_N to get the original signal
assign d = ~D_N;  // Invert D_N to get the original signal

assign or_out = A | B | c | d; // 4-input OR operation

assign X = or_out;

endmodule