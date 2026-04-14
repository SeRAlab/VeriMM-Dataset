module top_module(input i, clk, input [1:0] l1, l2, output [1:0] q);reg head = 1'b0; 
 reg [3:0] shift1 = 4'b0000; 
 reg [3:0] shift2 = 4'b0000; 
 always @(posedge clk) begin 
  head <= i; 
  shift1 <= {shift1[2:0], head}; 
  shift2 <= {shift2[2:0], head}; 
 end 
 assign q = {shift2[l2], shift1[l1]}; 
 endmodule