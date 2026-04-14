module top_module(
  data_i,
  data_o,
);input   [15:0]  data_i;
output  [31:0]  data_o;

assign data_o[31:16] = 1'b0;
assign data_o[15:0] = data_i[15:0];

endmodule