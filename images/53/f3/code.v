module top_module(
  input clk,
  input rst,
  input wr_en,
  input [7:0] data_in,
  output reg [7:0] data_out
);parameter depth = 8; // depth of the LIFO memory block

reg [7:0] stack [depth-1:0];
reg [3:0] top;

always @(posedge clk) begin
  if (rst) begin
    top <= 0;
  end else if (wr_en) begin
    stack[top] <= data_in;
    top <= top + 1;
  end else if (top > 0) begin
    top <= top - 1;
  end
end

assign data_out = stack[top];

endmodule