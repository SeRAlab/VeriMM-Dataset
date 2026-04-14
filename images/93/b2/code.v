module top_module(out0, out1,clk, wr0a, wr0b, wr1a, wr1b, inData);input clk; 
  input wr0a; 
  input wr0b; 
  input wr1a; 
  input wr1b; 
  input [15:0] inData; 
  output [15:0] out0; 
  output [15:0] out1; 
  reg [15:0] mem [1:0]; 
  reg [15:0] memtemp2 [1:0]; 
  reg [15:0] memtemp3 [1:0]; 
  assign out0 = {mem[0] ^ memtemp2[0]}; 
  assign out1 = {mem[1] ^ memtemp3[1]}; 
  always @(posedge clk) begin 
  if (wr0a) begin 
  memtemp2[0] <= inData; 
  mem[0] <= inData; 
  end 
  if (wr0b) begin 
  memtemp3[0] <= inData; 
  mem[0] <= ~inData; 
  end 
  if (wr1a) begin 
  memtemp3[1] <= inData; 
  mem[1] <= inData; 
  end 
  if (wr1b) begin 
  memtemp2[1] <= inData; 
  mem[1] <= ~inData; 
  end 
  end 
 endmodule