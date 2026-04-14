module top_module(Clock, IncrementData, LoadData, Reset, AddOne, WriteOrRead);input Clock, IncrementData, LoadData, Reset; 
  output reg AddOne, WriteOrRead; 
  parameter InitialState = 2'b00; 
  parameter LoadState = 2'b01; 
  parameter ReadState = 2'b10; 
  parameter IncrementState = 2'b11; 
  reg [2:0] State; 
  reg [2:0] NextState; 
  initial State = InitialState; 
  initial NextState = InitialState; 
  always @ (State) 
  case (State) 
  InitialState: begin AddOne <= 0; WriteOrRead <= 0; end 
  LoadState: begin AddOne <= 0; WriteOrRead <= 1; end 
  ReadState: begin AddOne <= 0; WriteOrRead <= 0; end 
  IncrementState: begin AddOne <= 1; WriteOrRead <= 1; end 
  endcase 
  always @ (posedge Clock or posedge Reset) 
  if (Reset == 1) State <= InitialState; 
  else State <= NextState; 
  always @ (State or IncrementData or LoadData) 
  if (IncrementData == 1) NextState <= IncrementState; 
  else if (LoadData == 1) NextState <= LoadState; 
  else NextState <= ReadState; 
 endmodule