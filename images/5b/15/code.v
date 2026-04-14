module top_module(clk, d, set, reset, clr, q, qn);input clk, d, set, reset, clr;
  output reg q, qn;
  
  always @(posedge clk) begin
    if (clr == 0) begin
      q <= 0;
    end else if (reset == 1) begin
      q <= 0;
    end else if (set == 1) begin
      q <= 1;
    end else begin
      q <= d;
    end
  end
  
  assign qn = ~q;
  
endmodule