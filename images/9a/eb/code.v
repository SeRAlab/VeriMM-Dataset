module top_module(
  input   clock,
  input   reset,
  input   io_in,
  input   io_init,
  output  io_out,
  input   io_enable
);reg  ff;
  reg [31:0] _GEN_0;
  wire  d;
  wire  _T_13;
  wire  _GEN_1;
  
  assign io_out = ff;
  assign d = _GEN_1;
  assign _T_13 = io_enable == 1'h0;
  assign _GEN_1 = _T_13 ? ff : io_in;
  
  always @(posedge clock or negedge reset) begin
    if (!reset) begin
      ff <= io_init;
    end else if (io_enable) begin
      ff <= d;
    end
  end
endmodule