module top_module(
    Y,
    A1,
    A2,
    B1
);output Y;
    input A1;
    input A2;
    input B1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Output Y should be high if A1 is high and A2 is low
    assign Y = (A1 && !A2) ? 1'b1 :
               // Output Y should be high if A2 is high and A1 is low
               (!A1 && A2) ? 1'b1 :
               // Output Y should be low if B1 is low
               (B1 == 1'b0) ? 1'b0 :
               // Output Y should be high if B1 is high and either A1 or A2 is high
               ((B1 == 1'b1) && (A1 || A2)) ? 1'b1 :
               // Output Y should be low if B1 is high and both A1 and A2 are low
               1'b0;

endmodule