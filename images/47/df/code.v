module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  input [2:0] shift_amount,
  input shift_direction, // 0: right shift, 1: left shift
  output reg [7:0] data_out
);always @ (posedge clk or posedge reset) begin
    if (reset) begin
      data_out <= 8'h00;
    end else begin
      if (shift_direction == 1) begin // left shift
        data_out <= (data_in << shift_amount); // left shift using bitwise left shift
      end else begin // right shift
        data_out <= (data_in >> shift_amount); // right shift using bitwise right shift
      end
    end
  end

endmodule