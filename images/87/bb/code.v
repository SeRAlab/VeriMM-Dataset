module top_module( FromCore, FromPreviousBSCell, CaptureDR, ShiftDR, UpdateDR, extest, TCK, ToNextBSCell, FromOutputEnable, TristatedPin);input  FromCore;
input  FromPreviousBSCell;
input  CaptureDR;
input  ShiftDR;
input  UpdateDR;
input  extest;
input  TCK;
input  FromOutputEnable;

reg Latch;

output ToNextBSCell;
reg    ToNextBSCell;

output TristatedPin;

reg  ShiftedControl;

wire SelectedInput = CaptureDR? FromCore : FromPreviousBSCell;

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
assign TristatedPin = FromOutputEnable? MuxedSignal : 1'bz;

endmodule