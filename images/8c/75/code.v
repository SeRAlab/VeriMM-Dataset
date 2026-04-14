module top_module(
  input [(CH_CNT*CH_DW)-1:0] data,
  output [CH_DW-1:0] split_data_0,
  output [CH_DW-1:0] split_data_1,
  output [CH_DW-1:0] split_data_2,
  output [CH_DW-1:0] split_data_3,
  output [CH_DW-1:0] split_data_4,
  output [CH_DW-1:0] split_data_5,
  output [CH_DW-1:0] split_data_6,
  output [CH_DW-1:0] split_data_7
);// parameters
  parameter CH_DW = 1;
  parameter CH_CNT = 8;
  localparam CH_MCNT = 9;

  // internal signals
  wire [(CH_MCNT*CH_DW)-1:0] data_s;

  // extend and split
  assign data_s[(CH_MCNT*CH_DW)-1:(CH_CNT*CH_DW)] = 'd0;
  assign data_s[(CH_CNT*CH_DW)-1:0] = data;

  assign split_data_0 = data_s[(CH_DW*1)-1:CH_DW*0];
  assign split_data_1 = data_s[(CH_DW*2)-1:CH_DW*1];
  assign split_data_2 = data_s[(CH_DW*3)-1:CH_DW*2];
  assign split_data_3 = data_s[(CH_DW*4)-1:CH_DW*3];
  assign split_data_4 = data_s[(CH_DW*5)-1:CH_DW*4];
  assign split_data_5 = data_s[(CH_DW*6)-1:CH_DW*5];
  assign split_data_6 = data_s[(CH_DW*7)-1:CH_DW*6];
  assign split_data_7 = data_s[(CH_DW*8)-1:CH_DW*7];

endmodule