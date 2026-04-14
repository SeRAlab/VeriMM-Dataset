module top_module(
  input        clock,
  input        reset,
  input  [9:0] io_strideInc,
  input  [9:0] io_strideDec,
  input        io_inc,
  input        io_dec,
  output [9:0] io_out,
  output [9:0] io_nextInc,
  output [9:0] io_nextDec
);reg [9:0] reg_io_out; // Declare a register for output storage
  wire  _T_16;
  wire [9:0] incval;
  wire [9:0] decval;
  wire [10:0] _T_20;
  wire [10:0] _T_21;
  wire [9:0] incr;
  wire [10:0] _T_22;
  wire [9:0] newval;
  wire [10:0] _T_27;
  wire [9:0] _T_28;
  wire [10:0] _T_29;
  wire [10:0] _T_30;
  wire [9:0] _T_31;

  assign _T_16 = io_inc | io_dec;
  assign incval = io_inc ? io_strideInc : 10'h0;
  assign decval = io_dec ? io_strideDec : 10'h0;
  assign _T_20 = incval - decval;
  assign _T_21 = $unsigned(_T_20);
  assign incr = _T_21[9:0];
  assign _T_22 = reg_io_out + incr;
  assign newval = _T_22[9:0];
  assign _T_27 = reg_io_out + io_strideInc;
  assign _T_28 = _T_27[9:0];
  assign _T_29 = reg_io_out - io_strideDec;
  assign _T_30 = $unsigned(_T_29);
  assign _T_31 = _T_30[9:0];

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      reg_io_out <= 10'b0;  // Reset output value
    end else if (_T_16) begin
      reg_io_out <= newval; // Update output with new value
    end
  end

  assign io_out = reg_io_out;
  assign io_nextInc = _T_28;
  assign io_nextDec = _T_31;
endmodule