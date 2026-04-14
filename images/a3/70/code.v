module top_module(clk, we, add, wr, rd);parameter width = 'd16; 
  parameter depth = 'd8192; 
  parameter add_width = 'd13; 
  input wire clk ; 
  input wire we ; 
  input wire [add_width-1:0] add ; 
  input wire [width-1:0] wr ; 
  output reg [width-1:0] rd ; 
  reg [width-1:0] mem_arr [0:depth-1] ; 
  always@(posedge clk) begin 
  rd [width-1:0] <= mem_arr[add] [width-1:0]; 
  end 
  always@(posedge clk) begin 
  if(we) mem_arr[add] [width-1:0] <= wr [width-1:0]; 
  end 
 endmodule