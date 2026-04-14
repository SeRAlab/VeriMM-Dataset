module top_module(
  input clk,
  input reset,
  input [31:0] data,
  input [4:0] shift_amount,
  output reg [31:0] shifted_data
);always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      shifted_data <= 0;
    end else if (shift_amount >= 32) begin
      shifted_data <= 0;
    end else begin
      shifted_data <= data << shift_amount;
    end
  end

endmodule