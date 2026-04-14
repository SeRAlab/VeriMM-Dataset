module top_module(output reg [31:0] contador, input wire enb,input wire signal);initial 
  begin 
  contador=32'b0; 
  end 
 always @(signal) 
 begin 
  if(enb==1) 
  contador=contador+1; 
 end 
 endmodule