module top_module(input rst_n,input clk,input clken,input d,output strobe);reg[6:0] data; 
 assign strobe = clken && (data != 7'b0111111); 
 always @(posedge clk or negedge rst_n) begin 
  if (!rst_n) begin 
  data <= 7'b0000000; 
  end else if (clken) begin 
  data <= { data[5:0], d }; 
  end 
 end 
 endmodule