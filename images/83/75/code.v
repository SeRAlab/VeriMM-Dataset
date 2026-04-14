module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);wire X;
    // If sky130_fd_sc_lp__and4b_lp is not available, define your own AND gate
    assign X = A & B & C & D; // Using a simple AND operation for demonstration

    assign Y = ~X;

endmodule