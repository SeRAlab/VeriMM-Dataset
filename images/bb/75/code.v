module top_module(
    input A,
    input B,
    input CI,
    output SUM,
    output COUT_N,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);wire a_xor_b = A ^ B;
wire sum = a_xor_b ^ CI;
wire carry_out = (A & B) | (a_xor_b & CI);

assign SUM = sum;
assign COUT_N = ~carry_out;

endmodule