module top_module(clk, setA, setB, y);input clk, setA, setB; 
 output y; 
 reg mem [1:0]; 
 always @(posedge clk) begin 
  if (setA) mem[0] <= 0; 
  if (setB) mem[0] <= 1; 
 end 
 assign y = mem[0]; 
 endmodule