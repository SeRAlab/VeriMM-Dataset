module top_module(
    input A,
    input B,
    input CI,
    output SUM,
    output COUT
);assign SUM = A ^ B ^ CI;  // XOR for sum
    assign COUT = (A & B) | (CI & (A ^ B));  // Carry out logic
endmodule