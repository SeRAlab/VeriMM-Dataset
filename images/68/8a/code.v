module top_module(input clk,input rst,output reg [7:0] trainingpattern);always @ (posedge clk) begin 
  if(rst) begin 
  trainingpattern <= 8'h00; 
  end else begin 
  if(trainingpattern == 8'hf4) 
  trainingpattern <= 8'hc2; 
  else 
  trainingpattern <= 8'hf4; 
  end 
  end 
 endmodule