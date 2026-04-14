module top_module(
  input clk,
  input reset,
  input [31:0] data,
  input [31:0] shift_amount,
  output reg [31:0] shifted_data
);always @(posedge clk) begin
    if (reset) begin
      shifted_data <= 0;
    end else begin
      if (shift_amount == 0) begin
        shifted_data <= data;
      end else if (shift_amount > 0) begin
        shifted_data <= data << shift_amount;
      end else begin
        shifted_data <= data >> (-shift_amount);
      end
    end
  end

endmodule