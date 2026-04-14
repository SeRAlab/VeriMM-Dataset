module top_module(

  clk,

  
  control,
  status,

  
  src_dac_en,
  src_dac_ddata,
  src_dac_dunf,
  src_dac_dvalid,

  dst_dac_en,
  dst_dac_ddata,
  dst_dac_dunf,
  dst_dac_dvalid
);localparam  RP_ID       = 8'hA0;
  parameter   CHANNEL_ID  = 0;

  input             clk;

  input   [31:0]    control;
  output  [31:0]    status;

  output            src_dac_en;
  input   [31:0]    src_dac_ddata;
  input             src_dac_dunf;
  input             src_dac_dvalid;

  input             dst_dac_en;
  output  [31:0]    dst_dac_ddata;
  output            dst_dac_dunf;
  output            dst_dac_dvalid;

  reg               src_dac_en;
  reg     [31:0]    dst_dac_ddata;
  reg               dst_dac_dunf;
  reg               dst_dac_dvalid;

  assign status = {24'h0, RP_ID};

  always @(posedge clk) begin
    src_dac_en     <= dst_dac_en;
    dst_dac_ddata  <= src_dac_ddata;
    dst_dac_dunf   <= src_dac_dunf;
    dst_dac_dvalid <= src_dac_dvalid;
  end
endmodule