module top_module(
  input clk,
  input reset,
  input enable,
  output reg [WIDTH-1:0] count
);parameter WIDTH = 8;

always @(posedge clk) begin
  if (reset) begin
    count <= 0;
  end else if (enable) begin
    count <= count + 1;
  end
end

endmodule