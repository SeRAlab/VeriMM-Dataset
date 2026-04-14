module top_module(
  input         clock,
  input         reset,
  input  [10:0] io_in,
  input  [10:0] io_init,
  output [10:0] io_out,
  input         io_enable
);wire [10:0] d;
  reg [10:0] ff;
  reg [31:0] _GEN_0;
  wire  _T_13;
  wire [10:0] _GEN_1;
  assign io_out = ff;
  assign d = _GEN_1;
  assign _T_13 = io_enable == 1'h0;
  assign _GEN_1 = _T_13 ? ff : io_in;
  
  `ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
    `ifdef RANDOMIZE_REG_INIT
      _GEN_0 = {1{$random}};
      ff = _GEN_0[10:0];
    `else
      ff = io_init;
    `endif
  end
  `endif
  
  always @(posedge clock) begin
    if (reset) begin
      ff <= io_init;
    end else begin
      ff <= d;
    end
  end
endmodule