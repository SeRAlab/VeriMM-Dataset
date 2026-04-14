module top_module(input [15 : 0] a,input [15 : 0] d,input clk,input we,output [15 : 0] spo);(* ram_init_file = "LC3MEM.mif " *)reg [15:0] block [65535:0]; 
  initial block[16'h002]=16'h700; 
  initial block[16'h180]=16'h200; 
  initial block[16'h200]=16'b0010000000000001; 
  initial block[16'h201]=16'b1100000000000000; 
  initial block[16'h202]=16'h203; 
  initial block[16'h203]=16'b1010001000000011; 
  initial block[16'h204]=16'b0110010001000000; 
  initial block[16'h205]=16'b0100000010000000; 
  initial block[16'h206]=16'b1111000000000010; 
  initial block[16'h207]=16'h208; 
  initial block[16'h208]=16'h209; 
  initial block[16'h209]=16'h20a; 
  initial block[16'h20a]=16'b1100000111000000; 
  initial block[16'h6fe]=16'b0100000000000000; 
  initial block[16'h6ff]=16'hfe00; 
  initial block[16'h700]=16'b0010011111111101; 
  initial block[16'h701]=16'b1011011111111101; 
  initial block[16'h702]=16'b1100000111000000; 
  always@(posedge clk) begin 
  if(we) 
  block[a]<=d; 
  end 
  assign spo=block[a]; 
 endmodule