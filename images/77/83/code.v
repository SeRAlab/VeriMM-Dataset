module top_module(Clock, Resetn, w, z);input Clock, Resetn, w; 
  output z; 
  reg [1:0] y, Y; 
  parameter [1:0] A = 2'b00, B = 2'b01, C = 2'b10; 

  
  always @(w or y) 
    case (y) 
      A:  if (w)    Y = B; 
        else    Y = A; 
      B:  if (w)    Y = C; 
        else    Y = A; 
      C:  if (w)    Y = C; 
        else    Y = A; 
      default:      Y = 2'b00; 
    endcase 

  
  always @(posedge Clock) 
    if (Resetn == 1'b0) y <= A; 
    else y <= Y; 

  
  assign z = (y == C); 

endmodule