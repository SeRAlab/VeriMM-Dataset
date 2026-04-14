module logic_gate (
    input A1,
    input A2,
    input B1,
    input B2,
    input C1,
    output reg X
);

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    always @(*) begin
        X = (A1 & A2 & (B1 | B2) & ~C1);
    end

endmodule