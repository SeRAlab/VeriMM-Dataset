module top_module(output reg [7:0] count, input clk, reset);reg [3:0] state; 
  always @(posedge clk) begin 
  if (reset == 1) begin 
  state = 13; 
  end 
  case(state) 
  0: begin count <= 8'b00000010; state <= 1; end 
  1: begin count <= 8'b00000001; state <= 2; end 
  2: begin count <= 8'b00000100; state <= 3; end 
  3: begin count <= 8'b00000001; state <= 4; end 
  4: begin count <= 8'b00001000; state <= 5; end 
  5: begin count <= 8'b00000001; state <= 6; end 
  6: begin count <= 8'b00010000; state <= 7; end 
  7: begin count <= 8'b00000001; state <= 8; end 
  8: begin count <= 8'b00100000; state <= 9; end 
  9: begin count <= 8'b00000001; state <= 10;end 
  10:begin count <= 8'b01000000; state <= 11;end 
  11:begin count <= 8'b00000001; state <= 12;end 
  12:begin count <= 8'b10000000; state <= 13;end 
  13,14,15: 
  begin count <= 8'b00000001; state <= 0; end 
  endcase 
  end 
 endmodule