module top_module(clk, reset, d, q);input clk, reset;
  input [3:0] d;
  output reg [3:0] q;
  
  always @(posedge clk) begin
    if (reset) begin
      q <= 4'b0;
    end else begin
      q <= d;
    end
  end
endmodule