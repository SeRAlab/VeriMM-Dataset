module top_module(

  clk,

  
  control,
  status,

  
  src_dac_enable,
  src_dac_data,
  src_dac_valid,

  dst_dac_enable,
  dst_dac_data,
  dst_dac_valid
);localparam  RP_ID       = 8'hA0;
  parameter   CHANNEL_ID  = 0;

  input             clk;

  input   [31:0]    control;
  output  [31:0]    status;

  output            src_dac_enable;
  input   [15:0]    src_dac_data;
  output            src_dac_valid;

  input             dst_dac_enable;
  output  [15:0]    dst_dac_data;
  input             dst_dac_valid;

  reg               src_dac_enable;
  reg               src_dac_valid;
  reg     [15:0]    dst_dac_data;

  assign status = {24'h0, RP_ID};

  always @(posedge clk) begin
    src_dac_enable  <= dst_dac_enable;
    dst_dac_data    <= src_dac_data;
    src_dac_valid   <= dst_dac_valid;
  end
endmodule