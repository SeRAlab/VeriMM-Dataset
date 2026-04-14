module top_module(
  input clk,
  output reg clk_div
);parameter n = 2; // division factor

reg [31:0] count;

always @(posedge clk) begin
  if (count == n-1) begin
    clk_div <= ~clk_div;
    count <= 0;
  end
  else begin
    count <= count + 1;
  end
end

endmodule