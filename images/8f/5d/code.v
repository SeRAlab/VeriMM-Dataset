module top_module(
    input in0,
    input in1,
    input sel0,
    input sel1,
    output out
);wire w1, w2, w3;

assign w1 = sel0 & sel1;
assign w2 = sel0 & (~sel1);
assign w3 = (~sel0) & sel1;

assign out = (in0 & (~w1) & (~w2)) | (in1 & (~w1) & (~w3)) | (in0 & w1) | (in1 & w1);

endmodule