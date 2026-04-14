module top_module(clock, indata, indata180, outdata);input clock; 
 input [31:0] indata; 
 input [31:0] indata180; 
 output [31:0] outdata; 
 reg [31:0] dly_indata, next_dly_indata; 
 reg [31:0] dly_indata180, next_dly_indata180; 
 reg [31:0] outdata, next_outdata; 
 always @(posedge clock) 
 begin 
  outdata = next_outdata; 
  dly_indata = next_dly_indata; 
  dly_indata180 = next_dly_indata180; 
 end 
 always @* 
 begin 
  #1; 
  next_outdata = (outdata | dly_indata | indata) & dly_indata180; 
  next_dly_indata = indata; 
  next_dly_indata180 = indata180; 
 end 
 endmodule