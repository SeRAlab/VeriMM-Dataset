module top_module(clk, rst, we1, we2, add1, add2, wr1, wr2, mem_fault, rd1, rd2);parameter width = 'd16; 
  parameter depth = 'd8; 
  parameter add_width = 'd3; 
  input wire clk , rst ; 
  input wire we1 , we2 ; 
  input wire [add_width-1:0] add1 , add2 ; 
  input [width-1:0] wr1 , wr2 ; 
  output reg mem_fault ; 
  output reg [width-1:0] rd1 , rd2 ; 
  reg [width-1:0] mem_arr [0:depth-1] ; 
  always@(posedge clk) begin 
  if(rst) mem_fault <= 1'b0; 
  else if((we1 && we2) && (add1 && add2)) mem_fault <= 1'b1; 
  end 
  always@(posedge clk) begin 
  rd1 [width-1:0] <= mem_arr[add1] [width-1:0]; 
  rd2 [width-1:0] <= mem_arr[add2] [width-1:0]; 
  end 
  always@(posedge clk) begin 
  if(we1) mem_arr[add1] [width-1:0] <= wr1 [width-1:0]; 
  if(we2) mem_arr[add2] [width-1:0] <= wr2 [width-1:0]; 
  end 
 endmodule