module top_module(
    input A,
    input B,
    input CI,
    output SUM,
    output COUT
);assign SUM = A ^ B ^ CI;
    assign COUT = (A & B) | (CI & (A ^ B));
endmodule