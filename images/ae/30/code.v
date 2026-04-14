module top_module(input wire D,input wire Clock,input wire Reset ,output reg Q);always @ ( posedge Clock or posedge Reset ) 
  begin 
  if (Reset) 
  begin 
  Q <= 1'b0; 
  end 
  else 
  begin 
  if (D) 
  Q <= ! Q; 
  end 
  end 
  endmodule