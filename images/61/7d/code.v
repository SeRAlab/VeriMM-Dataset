module top_module(clk, rst_n, branch, branchInit, forwardStall, cacheStall, flush, stall, globalStall);input clk, rst_n, branch, branchInit, forwardStall, cacheStall;

  output flush;
  output reg stall, globalStall;

  assign flush = branchInit ? branch: 1'b0;

  always @(negedge clk or negedge rst_n) begin
    if(!rst_n) begin
      stall <= 1'b0;
      globalStall <= 1'b0;
    end 
    else begin
      globalStall <= cacheStall;

      if(branchInit) begin
        stall <= forwardStall;        
      end
      else  begin
        stall <= 1'b0;
      end
    end
  end

endmodule