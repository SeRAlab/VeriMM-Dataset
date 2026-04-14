module top_module(
  input clk,
  input rst,
  input we,
  input [n-1:0] data_in,
  output reg re,
  output reg [n-1:0] data_out
);parameter n = 8; // number of bits in the data input and output signals
parameter depth = 16; // depth of the memory block

reg [n-1:0] memory [depth-1:0];
integer top;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    top <= 0;
    re <= 0;
    data_out <= 0;
  end else begin
    if (we && top < depth) begin
      memory[top] <= data_in;
      top <= top + 1;
    end
    if (re && top > 0) begin
      top <= top - 1;
      data_out <= memory[top];
    end
  end
end

endmodule