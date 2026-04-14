module top_module(
    input A,
    input B,
    input CIN,
    output SUM,
    output COUT
);wire w1, w2, w3;

// Calculate SUM
assign w1 = A ^ B;
assign SUM = w1 ^ CIN;

// Calculate COUT
assign w2 = A & B;
assign w3 = CIN & w1;
assign COUT = w2 | w3;

endmodule