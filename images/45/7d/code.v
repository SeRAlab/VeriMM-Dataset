module top_module(input IN, output reg OUT);parameter DELAY_STEPS = 1; 
  parameter GLITCH_FILTER = 0; 
  initial OUT = 0; 
  generate 
  if(GLITCH_FILTER) begin 
  initial begin 
  $display("ERROR: GP_DELAY glitch filter mode not implemented"); 
  $finish; 
  end 
  end 
  always @(*) begin 
  case(DELAY_STEPS) 
  1: #166 OUT = IN; 
  2: #318 OUT = IN; 
  2: #471 OUT = IN; 
  3: #622 OUT = IN; 
  default: begin 
  $display("ERROR: GP_DELAY must have DELAY_STEPS in range [1,4]"); 
  $finish; 
  end 
  endcase 
  end 
  endgenerate 
 endmodule