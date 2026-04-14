module top_module(input KEY_CLEAR,input KEY_ADD,input KEY_SUB,input CMD_DONE,output reg CMD_CLEAR,output reg CMD_COMPUTE,output reg CMD_OPERATION,input CLK,input RESET);reg [3:0] State; 
  localparam [3:0] 
  S0 = 4'b0001, 
  S1 = 4'b0010, 
  S2 = 4'b0100, 
  S3 = 4'b1000; 
  reg [1:0] key_reg; 
  always @(posedge CLK, posedge RESET) 
  begin 
  if (RESET) 
  begin 
  key_reg <= 2'h0; 
  CMD_CLEAR <= 1'b0; 
  CMD_COMPUTE <= 1'b0; 
  CMD_OPERATION <= 1'b0; 
  State <= S0; 
  end 
  else 
  begin 
  case (State) 
  S0 : 
  begin 
  key_reg <= { KEY_SUB, KEY_ADD }; 
  if (KEY_CLEAR) 
  State <= S2; 
  else if (KEY_ADD | KEY_SUB) 
  State <= S1; 
  end 
  S1 : 
  begin 
  case (key_reg) 
  2'b01 : CMD_OPERATION <= 1'b0; 
  2'b10 : CMD_OPERATION <= 1'b1; 
  default : CMD_OPERATION <= 1'b0; 
  endcase 
  if (^key_reg) 
  CMD_COMPUTE <= 1'b1; 
  if (^key_reg) 
  State <= S3; 
  else 
  State <= S0; 
  end 
  S2 : 
  begin 
  CMD_CLEAR <= 1'b1; 
  State <= S3; 
  end 
  S3 : 
  begin 
  CMD_CLEAR <= 1'b0; 
  CMD_COMPUTE <= 1'b0; 
  if (CMD_DONE) 
  State <= S0; 
  end 
  endcase 
  end 
  end 
 endmodule