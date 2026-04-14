module top_module(out0,in0);input in0; 
 output [5:0] out0; 
 parameter [5:0] ident0 = 0; 
 parameter [5:0] ident1 = 5'h11; 
 reg [5:0] out0; 
 always @ (in0) 
  begin 
  if(in0) 
  out0 = ident0; 
  else 
  out0 = ident1; 
  end 
 endmodule