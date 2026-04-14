module top_module(clock,reset,strobe_in,enable,rate,strobe_out,count);parameter INITIAL_VAL = 24'd0; 
 parameter INCREMENT_VAL = 24'h1; 
  input wire clock, reset, enable, strobe_in; 
  input wire [23: 0] rate; 
  output wire strobe_out; 
  output reg [23:0] count; 
  assign strobe_out = count == rate; 
  always @(posedge clock) 
  if(reset | ~enable | strobe_out) 
  count <= #1 INITIAL_VAL; 
  else if( strobe_in) 
  count <= #1 count + INCREMENT_VAL; 
 endmodule