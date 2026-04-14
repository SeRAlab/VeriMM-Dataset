module top_module( FromCore, ToCore, FromPreviousBSCell, CaptureDR, ShiftDR, UpdateDR, extest, TCK, ToNextBSCell, FromOutputEnable, BiDirPin);input FromCore; 
 input FromPreviousBSCell; 
 input CaptureDR; 
 input ShiftDR; 
 input UpdateDR; 
 input extest; 
 input TCK; 
 input FromOutputEnable; 
 reg Latch; 
 output ToNextBSCell; 
 reg ToNextBSCell; 
 output BiDirPin; 
 output ToCore; 
 reg ShiftedControl; 
 wire SelectedInput = CaptureDR? BiDirPin : FromPreviousBSCell; 
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
 wire MuxedSignal = extest? ShiftedControl : FromCore; 
 assign BiDirPin = FromOutputEnable? MuxedSignal : 1'bz; 
 assign ToCore = BiDirPin; 
 endmodule