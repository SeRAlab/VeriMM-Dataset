module top_module(
  input clk,
  input reset,
  input [15:0] data,
  output reg parity_bit
);reg [3:0] ones_count;

always @(posedge clk or negedge reset) begin
  if (reset == 0) begin
    ones_count <= 0;
    parity_bit <= 0;
  end else begin
    ones_count <= ones_count + data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + data[6] + data[7] + data[8] + data[9] + data[10] + data[11] + data[12] + data[13] + data[14] + data[15];
    parity_bit <= ones_count[0];
  end
end

endmodule