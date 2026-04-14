module top_module(in, s, out);input wire[3: 0] in; 
  input wire[1: 0] s; 
  output wire out; 
  reg _out; 
  always @(in or s) 
  if(s == 2'b00) 
  _out = in[0]; 
  else if(s == 2'b01) 
  _out = in[1]; 
  else if(s == 2'b10) 
  _out = in[2]; 
  else if(s == 2'b11) 
  _out = in[3]; 
  else 
  _out = 1'b0; 
  assign out = _out; 
 endmodule