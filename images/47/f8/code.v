module top_module(
  input clk,
  output reg [N-1:0] out
);parameter N = 4; // number of bits in the counter

reg [N-1:0] count;

always @(posedge clk) begin
  if (count == 9) begin
    count <= 0;
  end else begin
    count <= count + 1;
  end
end

assign out = count;

endmodule