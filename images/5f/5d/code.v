module top_module(
    output X,
    input A1,
    input A2,
    input B1,
    input B2,
    input C1
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    wire and_out;

    // Implement the AND gate
    // Replace the unknown module with a simple implementation
    assign and_out = A1 & A2;

    // Implement the additional behavior
    assign X = (B1 == 1) ? (B2 == 1 ? !and_out : and_out & C1) : 0;

endmodule