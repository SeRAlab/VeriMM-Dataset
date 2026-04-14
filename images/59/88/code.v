module top_module(
  input clk,
  input rst,
  input [n-1:0] din,
  output [n-1:0] dout
);parameter n = 8; // width of data input and output signals

reg [n-1:0] stored_data;

always @(posedge clk) begin
  if (!rst) begin
    stored_data <= 0;
  end else begin
    stored_data <= din;
  end
end

assign dout = stored_data;

endmodule