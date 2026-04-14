module top_module(
  
  rst_n,
  
  clk, rst_async
  );input clk;
  input rst_async; 
  output rst_n;    
  
  
  
  
  
  

  reg                   rst_async_m; 
  reg                   rst_async_r; 
  
  always @(negedge clk or negedge rst_async) begin
    if(rst_async == 1'b0) begin
      
      
      rst_async_m <= 1'h0;
      rst_async_r <= 1'h0;
      
    end
    else begin
      rst_async_m <= 1'b1; 
      rst_async_r <= rst_async_m;
    end
  end
  
  
  assign rst_n = rst_async_r;


  
  
endmodule