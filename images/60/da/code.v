module top_module(
  input [n-1:0] in,
  output reg [n-1:0] min,
  output reg [n-1:0] max
);parameter n = 8; // number of input signals

integer i;

always @(*) begin
  min = in[0];
  max = in[0];
  for (i = 1; i < n; i = i + 1) begin
    if (in[i] < min) begin
      min = in[i];
    end
    if (in[i] > max) begin
      max = in[i];
    end
  end
end

endmodule