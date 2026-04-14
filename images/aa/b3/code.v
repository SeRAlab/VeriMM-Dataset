module top_module(
    input A,
    input B,
    input C,
    output X
);wire AB, AC, BC;

    // Majority function implementation
    assign AB = (A & B); // A and B
    assign AC = (A & C); // A and C
    assign BC = (B & C); // B and C

    assign X = AB | AC | BC; // Majority vote

endmodule