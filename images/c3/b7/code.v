module half_adder (
    input A,
    input B,
    output SUM,
    output CARRY_OUT
);

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // XOR gate for SUM
    assign SUM = A ^ B;

    // AND gate for CARRY_OUT
    assign CARRY_OUT = A & B;

endmodule