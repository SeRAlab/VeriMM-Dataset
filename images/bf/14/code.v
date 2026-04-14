module top_module( InputPin, FromPreviousBSCell, CaptureDR, ShiftDR, TCK, ToNextBSCell);input InputPin; 
 input FromPreviousBSCell; 
 input CaptureDR; 
 input ShiftDR; 
 input TCK; 
 reg Latch; 
 output ToNextBSCell; 
 reg ToNextBSCell; 
 wire SelectedInput = CaptureDR? InputPin : FromPreviousBSCell; 
 always @ (posedge TCK) 
 begin 
  if(CaptureDR | ShiftDR) 
  Latch<=SelectedInput; 
 end 
 always @ (negedge TCK) 
 begin 
  ToNextBSCell<=Latch; 
 end 
 endmodule