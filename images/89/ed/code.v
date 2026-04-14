module top_module(
  input   clock,
  input   reset,
  input   io_enable,
  input [39:0] load_val,
  output  io_done,
  output [39:0] count_out
);wire  reg$_clock;
  wire  reg$_reset;
  wire [39:0] reg$_io_in;
  wire [39:0] reg$_io_out;
  wire  reg$_io_enable;
  wire [40:0] count;
  wire [41:0] _T_12;
  wire [40:0] newval;
  wire  isMax;
  wire [40:0] next;
  wire  _T_14;

  // Implementing a simple flip-flop for FF_556
  reg [39:0] ff_out;
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      ff_out <= 40'h0;
    end else if (reg$_io_enable) begin
      ff_out <= reg$_io_in;
    end
  end

  assign reg$_io_out = ff_out; // Output from the flip-flop
  assign count = {1'h0, reg$_io_out};
  assign _T_12 = count + 41'h1;
  assign newval = _T_12[40:0];
  assign isMax = newval >= 41'h2cb417800;
  assign next = isMax ? count : newval;
  assign _T_14 = io_enable & isMax;
  assign io_done = _T_14;
  assign reg$_io_in = io_enable ? (load_val >= 41'h2cb417800 ? 40'h0 : load_val) : count[39:0];
  assign reg$_io_enable = io_enable;
  assign reg$_clock = clock;
  assign reg$_reset = reset;
  assign count_out = count[39:0];
endmodule