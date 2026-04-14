module top_module(CCLK,rst,instr,IF);input CCLK,rst; 
  input [31:0] instr; 
  output reg [7:0] IF; 
  always @(posedge CCLK or posedge rst) 
  begin 
  if (rst) 
  IF=8'd0; 
  else 
  case(instr[31:26]) 
  6'b000000: 
  begin 
  case(instr[5:0]) 
  6'b100000: 
  begin 
  IF=(|instr[15:11])?8'd1:8'd0; 
  end 
  6'b100010:IF=8'd2; 
  6'b100100:IF=8'd3; 
  6'b100101:IF=8'd4; 
  6'b000000:IF=8'd5; 
  6'b000010:IF=8'd6; 
  6'b000011:IF=8'd7; 
  endcase 
  end 
  6'b001000:IF=8'd8; 
  6'b001100:IF=8'd9; 
  6'b001101:IF=8'd10; 
  6'b100011:IF=8'd11; 
  6'b101011:IF=8'd12; 
  6'b000100:IF=8'd13; 
  6'b000101:IF=8'd14; 
  6'b000010:IF=8'd15; 
  default:IF=8'd0; 
  endcase 
  end 
 endmodule