module top_module(CLOCK,RESET,A,B,COUNT_ENABLE,DIRECTION,SPEED);input CLOCK, RESET, A, B; 
  output COUNT_ENABLE; 
  output DIRECTION; 
  output [3:0] SPEED; 
  reg [2:0] A_delayed; 
  reg [2:0] B_delayed; 
  always @(posedge CLOCK or posedge RESET) begin 
  if (RESET) begin 
  A_delayed <= 0; 
  end else begin 
  A_delayed <= {A_delayed[1:0], A}; 
  end 
  end 
  always @(posedge CLOCK or posedge RESET) begin 
  if (RESET) begin 
  B_delayed <= 0; 
  end else begin 
  B_delayed <= {B_delayed[1:0], B}; 
  end 
  end 
  assign COUNT_ENABLE = A_delayed[1] ^ A_delayed[2] ^ B_delayed[1] ^ B_delayed[2]; 
  assign DIRECTION = A_delayed[1] ^ B_delayed[2]; 
  assign SPEED = 4'd0; 
 endmodule