module top_module(data ,q,clk ,reset);input data, clk, reset ; 
 output q; 
 reg q; 
 always @ ( posedge clk or posedge reset) 
 if (reset) begin 
  q <= 1'b0; 
 end else begin 
  q <= data; 
 end 
 endmodule