module hazard_detection (
    input A,
    input B,
    input C,
    output Z
);
    assign Z = ~(A & B) | (B & C) | (A & C); // Hazard detection logic
endmodule