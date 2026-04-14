module top_module(
  input         clock,
  input         reset,
  input  [31:0] io_max,
  output [31:0] io_out,
  input         io_enable,
  output        io_done
);wire [3:0] count;
  wire [4:0] _T_12;
  wire [32:0] newval;
  wire [32:0] _GEN_1;
  wire  isMax;
  wire [3:0] next;
  wire  _T_14;

  /* You need to define FF_32 as a flip-flop with the following interface */
  reg [31:0] reg_io_out;
  
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      reg_io_out <= 32'h0;
    end else if (io_enable) begin
      reg_io_out <= next[3:0];
    end
  end

  assign count = {4'h0, reg_io_out};
  assign _T_12 = count + 5'h1;
  assign newval = _T_12[4:0];
  assign _GEN_1 = 5'h6;
  assign isMax = newval >= _GEN_1;
  assign next = isMax ? 4'h0 : newval;
  assign _T_14 = io_enable & isMax;

  assign io_out = count[3:0];
  assign io_done = _T_14;

endmodule