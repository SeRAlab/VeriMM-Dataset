module top_module(

  input clk,

  // control ports
  input [31:0] control,
  output reg [31:0] status,

  // FIFO interface
  output reg src_dac_enable,
  input [15:0] src_dac_data,
  output reg src_dac_valid,

  input dst_dac_enable,
  output reg [15:0] dst_dac_data,
  input dst_dac_valid
);localparam  RP_ID       = 8'hA0;
  parameter   CHANNEL_ID  = 0;

  assign status = {24'h0, RP_ID};

  always @(posedge clk) begin
    src_dac_enable  <= dst_dac_enable;
    dst_dac_data    <= src_dac_data;
    src_dac_valid   <= dst_dac_valid;
  end
endmodule