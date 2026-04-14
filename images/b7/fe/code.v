module top_module(
    input A0,
    input A1,
    input B0,
    input B1,
    output S0,
    output S1,
    output S2
    );assign S0 = A0 ^ B0;
    assign S1 = (A0 & B0) ^ (A1 ^ B1);
    assign S2 = (A1 & B1) | ((A1 ^ B1) & (A0 & B0));
    
endmodule