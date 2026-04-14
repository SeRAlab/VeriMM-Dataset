module top_module(
  input clk,
  input reset,
  input [15:0] data,
  output reg [15:0] edge_detected
);reg [15:0] prev_data;

always @(posedge clk) begin
  if (reset) begin
    prev_data <= 16'h0000;
    edge_detected <= 16'h0000;
  end
  else begin
    prev_data <= data;
    edge_detected <= (data & ~prev_data);
  end
end

endmodule