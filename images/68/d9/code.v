module top_module(
  input wire [11:0] in,
  output wire [2:0] out
);wire [3:0] nand1_out;
wire [3:0] nand2_out;
wire [3:0] nand3_out;

assign nand1_out = ~(in[0] & in[1] & in[2] & in[3]);
assign nand2_out = ~(in[4] & in[5] & in[6] & in[7]);
assign nand3_out = ~(in[8] & in[9] & in[10] & in[11]);

assign out[0] = nand1_out[0] & nand2_out[0] & nand3_out[0];
assign out[1] = nand1_out[1] & nand2_out[1] & nand3_out[1];
assign out[2] = nand1_out[2] & nand2_out[2] & nand3_out[2];

endmodule