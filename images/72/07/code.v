module top_module(clock, indata, indata180, outdata);input clock; 
 input [15:0] indata; 
 input [15:0] indata180; 
 output [31:0] outdata; 
 reg [15:0] dly_indata180, next_dly_indata180; 
 assign outdata = {dly_indata180,indata}; 
 always @(posedge clock) 
 begin 
  dly_indata180 = next_dly_indata180; 
 end 
 always @* 
 begin 
  #1; 
  next_dly_indata180 = indata180; 
 end 
 endmodule