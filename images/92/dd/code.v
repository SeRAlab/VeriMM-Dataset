module top_module(output reg [3:0]ten,output reg [3:0]one,output isFinished,input clk,input rst_n);reg [3:0] next_ten, next_one; 
  always @(posedge clk or negedge rst_n) begin 
  if (!rst_n) begin 
  ten <= 4'd3; 
  one <= 4'd0; 
  end else begin 
  ten <= next_ten; 
  one <= next_one; 
  end 
  end 
  always @(*) begin 
  if (ten == 4'd0 && one == 4'd0) begin 
  next_ten = 4'd0; 
  next_one = 4'd0; 
  end else begin 
  if (one == 4'd0) begin 
  next_ten = ten - 4'd1; 
  next_one = 4'd9; 
  end else begin 
  next_ten = ten; 
  next_one = one - 4'd1; 
  end 
  end 
  end 
  assign isFinished = (ten == 4'd0 && one == 4'd0)?1:0; 
 endmodule