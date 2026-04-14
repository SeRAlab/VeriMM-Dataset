module top_module(mux_in0, mux_in1, mux_sel, mux_out);parameter MuxLen = 63; 
  output [MuxLen:0] mux_out; 
  input [MuxLen:0] mux_in0; 
  input [MuxLen:0] mux_in1; 
  input mux_sel; 
  reg [MuxLen:0] mux_out; 
  always @(mux_in0 or mux_in1 or mux_sel) 
  begin 
  if (mux_sel == 1'b1) 
  mux_out = mux_in1; 
  else 
  mux_out = mux_in0; 
  end 
 endmodule