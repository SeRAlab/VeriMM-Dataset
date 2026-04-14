module top_module(
    input A,
    input B,
    input C,
    input D,
    output X
);wire AB;
wire CD;

// Replace unknown module with standard AND gate
assign AB = A & B; // Use a simple AND gate
assign CD = C & D; // Use a simple AND gate
assign X = AB & CD; // Combine the results for final output

endmodule