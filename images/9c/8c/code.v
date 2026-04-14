module top_module(input wire iClock,input wire iReset,output wire oOut64,output wire oOut128,output wire oOut256);reg [16:0] rOscCounter; 
  always @ (posedge iClock) begin 
  if (iReset) begin 
  rOscCounter <= 0; 
  end 
  else begin 
  rOscCounter <= rOscCounter+1; 
  end 
  end 
  assign oOut64 = rOscCounter[15]; 
  assign oOut128 = rOscCounter[14]; 
  assign oOut256 = rOscCounter[13]; 
 endmodule