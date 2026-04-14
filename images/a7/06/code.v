module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [1:0] sel,
    input en,
    output reg [3:0] out
);wire [3:0] w1, w2, w3, w4, w5, w6, w7;

// generate NOT gates for enable and select inputs
assign n_en = ~en;
assign n_sel0 = ~sel[0];
assign n_sel1 = ~sel[1];

// generate AND gates for enable and select inputs
assign a_en_sel0 = en & n_sel0;
assign a_en_sel1 = en & sel[0];
assign a_nen_sel0 = n_en & n_sel0;
assign a_nen_sel1 = n_en & sel[0];

// generate AND gates for input and select inputs
assign a_in0_sel1_sel0 = in0 & sel[1] & sel[0];
assign a_in1_nsel1_sel0 = in1 & n_sel1 & sel[0];
assign a_in2_sel1_nsel0 = in2 & sel[1] & n_sel0;
assign a_in3_nsel1_nsel0 = in3 & n_sel1 & n_sel0;

// generate OR gates for input and select inputs
assign o_w1 = a_in0_sel1_sel0 | a_in1_nsel1_sel0;
assign o_w2 = a_in2_sel1_nsel0 | a_in3_nsel1_nsel0;

// generate AND gates for enable and OR gates
assign a_w3 = a_en_sel1 & o_w1;
assign a_w4 = a_nen_sel1 & o_w1;
assign a_w5 = a_en_sel0 & o_w2;
assign a_w6 = a_nen_sel0 & o_w2;

// generate OR gates for AND gates
assign o_w7 = a_w3 | a_w4 | a_w5 | a_w6;

// assign output
always @(*) begin
  if (en == 1'b1) begin
    out = o_w7;
  end
  else begin
    out = 4'b0;
  end
end

endmodule