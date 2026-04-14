module top_module(
  input         clock,
  input         reset,
  input  [31:0] io_in,
  input  [31:0] io_init,
  output [31:0] io_out,
  input         io_enable
);wire [31:0] d;
  reg [31:0] ff;
  wire [31:0] _GEN_1;
  wire  _T_13;
  assign io_out = ff;
  assign d = _GEN_1;
  assign _T_13 = io_enable == 1'h0;
  assign _GEN_1 = _T_13 ? ff : io_in;

  always @(posedge clock) begin
    if (reset) begin
      ff <= io_init;
    end else begin
      ff <= d;
    end
  end
endmodule