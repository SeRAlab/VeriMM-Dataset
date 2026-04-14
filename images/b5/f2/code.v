module top_module(
    input A,
    input B,
    input C,
    input D,
    output out
);wire X;

// Replace with a known AND gate implementation if sky130_fd_sc_hd__and4bb_4 is unavailable
assign X = A & B & C & D;

assign out = X;

endmodule