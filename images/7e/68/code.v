module top_module(input rst_n,input clk,input clken,input j,input se0,output sync);reg[6:0] data; 
 assign sync = (data == 7'b0101010 && !j && !se0); 
 always @(posedge clk or negedge rst_n) begin 
  if (!rst_n) begin 
  data <= 1'd0; 
  end else if (clken) begin 
  data <= { data[5:0], j || se0 }; 
  end 
 end 
 endmodule