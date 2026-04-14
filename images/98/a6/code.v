module top_module(reset,ngreset,clock, strobeData, X0, Y0, A0, XN, YN, AN, aRom);parameter RSHIFT = 0; 
  parameter MODE = 0; 
  parameter BIT_WIDTH = 12; 
  input reset, ngreset, clock, strobeData; 
  input signed [BIT_WIDTH-1:0] X0, Y0, A0; 
  input signed [BIT_WIDTH-1:0] aRom; 
  output signed [BIT_WIDTH-1:0] XN, YN, AN; 
  wire d; 
  reg signed [BIT_WIDTH-1:0] XN, YN, AN; 
  assign d = (MODE==0)? A0[BIT_WIDTH-1] : ~Y0[BIT_WIDTH-1]; 
  always @ (posedge clock or negedge ngreset) begin 
  if(!ngreset) begin 
  AN <= 0; 
  XN <= 0; 
  YN <= 0; 
  end 
  else 
  if(reset) begin 
  AN <= 0; 
  XN <= 0; 
  YN <= 0; 
  end 
  else 
  if (d & strobeData) begin 
  AN <= A0 + aRom; 
  XN <= X0 + (Y0>>>RSHIFT); 
  YN <= Y0 - (X0>>>RSHIFT); 
  end 
  else if (strobeData) begin 
  AN <= A0 - aRom; 
  XN <= X0 - (Y0>>>RSHIFT); 
  YN <= Y0 + (X0>>>RSHIFT); 
  end 
  end 
 endmodule