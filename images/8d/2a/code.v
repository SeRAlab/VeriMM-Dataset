module top_module( OutputControl, FromPreviousBSCell, CaptureDR, ShiftDR, UpdateDR, extest, TCK, ToNextBSCell, ToOutputEnable);input OutputControl; 
 input FromPreviousBSCell; 
 input CaptureDR; 
 input ShiftDR; 
 input UpdateDR; 
 input extest; 
 input TCK; 
 reg Latch; 
 output ToNextBSCell; 
 output ToOutputEnable; 
 reg ToNextBSCell; 
 reg ShiftedControl; 
 wire SelectedInput = CaptureDR? OutputControl : FromPreviousBSCell; 
 always @ (posedge TCK) 
 begin 
  if(CaptureDR | ShiftDR) 
  Latch<=SelectedInput; 
 end 
 always @ (negedge TCK) 
 begin 
  ToNextBSCell<=Latch; 
 end 
 always @ (negedge TCK) 
 begin 
  if(UpdateDR) 
  ShiftedControl<=ToNextBSCell; 
 end 
 assign ToOutputEnable = extest? ShiftedControl : OutputControl; 
 endmodule