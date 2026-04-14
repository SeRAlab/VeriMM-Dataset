module top_module(
  input clk_in,
  output reg clk_out
);parameter n = 2; // division factor
  
  reg [31:0] count;
  
  always @(posedge clk_in) begin
    if (count == n-1) begin
      clk_out <= ~clk_out;
      count <= 0;
    end else begin
      count <= count + 1;
    end
  end
  
endmodule