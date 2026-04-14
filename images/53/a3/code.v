module top_module(
    input A,
    input B,
    input C,
    input sel1,
    input sel2,
    output Y
);wire n_sel1, n_sel2, n_sel1_sel2, n_sel1_A, n_sel2_B, n_sel1_sel2_C;

assign n_sel1 = ~sel1;
assign n_sel2 = ~sel2;
assign n_sel1_sel2 = n_sel1 & n_sel2;
assign n_sel1_A = n_sel1 & A;
assign n_sel2_B = n_sel2 & B;
assign n_sel1_sel2_C = n_sel1_sel2 & C;

assign Y = ~(n_sel1_A | n_sel2_B | n_sel1_sel2_C);

endmodule