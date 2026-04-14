module top_module(
    input clk,
    input reset,
    input d,
    output reg q
    );always @(posedge clk)
      if (reset) begin
         q <= 1'b0;
      end 
      else begin
         q <= d;
      end
                            
                            
    
    
endmodule