module top_module(input CLK,input PB,output reg PB_state,output reg PB_down);reg aux_pb; 
  reg [15:0] counter; 
 always@(*) 
 begin 
  PB_state = 1'b1; 
  if(CLK) 
  begin 
  if(aux_pb) 
  PB_state = 1'b0; 
  end 
  else if(!CLK) 
  begin 
  if(aux_pb) 
  PB_state = 1'b0; 
  end 
 end 
 always@(posedge CLK) 
 begin 
  if(PB) 
  begin 
  aux_pb <= 1'b0; 
  counter <= 16'd0; 
  PB_down <= 1'b0; 
  end 
  else 
  begin 
  if(counter >= 400) 
  begin 
  aux_pb <= 1'b1; 
  PB_down <= 1'b1; 
  end 
  else 
  counter <= counter + 16'd1; 
  end 
 end 
 endmodule