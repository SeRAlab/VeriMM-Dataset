module top_module(
    // inputs
    input A,
    input B,
    input VPWR,
    input VGND,
    // outputs
    output Y,
    output VPB,
    output VNB
);assign Y = A ^ B;
    assign VPB = VPWR & Y;   // Using bitwise AND for correct logic
    assign VNB = VGND & (~Y); // Using bitwise AND and NOT for correct logic

endmodule