module top_module(
  input clk_in,
  input reset,
  output reg clk_out
);parameter divide_ratio = 2;

reg [31:0] count;

always @(posedge clk_in or posedge reset) begin
  if (reset) begin
    count <= 0;
    clk_out <= 0;
  end else begin
    count <= count + 1;
    if (count == divide_ratio - 1) begin
      count <= 0;
      clk_out <= ~clk_out;
    end
  end
end

endmodule