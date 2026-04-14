module top_module(
    input wire A,
    input wire B,
    input wire CIN,
    output wire CO,
    output wire S
);assign S = A ^ B ^ CIN;    // Sum
    assign CO = (A & B) | (CIN & (A ^ B)); // Carry out
endmodule