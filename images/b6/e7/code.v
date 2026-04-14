module top_module(
  input clk,
  input rst,
  output reg [n-1:0] count
);parameter n = 4; // number of bits in the counter

always @(posedge clk) begin
  if (rst) begin
    count <= 0;
  end else begin
    count <= count + 1;
  end
end

endmodule