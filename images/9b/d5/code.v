module top_module(
  input clk,
  output reg [n-1:0] out
);parameter n = 4; // number of output signals

reg [n-1:0] count;

always @(posedge clk) begin
  count <= count + 1;
  if (count == 2**n) begin
    count <= 0;
  end
end

assign out[0] = count[0];
generate
  genvar i;
  for (i = 1; i < n; i = i + 1) begin
    assign out[i] = out[i-1];
  end
endgenerate

endmodule