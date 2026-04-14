module top_module(
  input clk,
  input reset,
  input shift_in,
  input shift,
  output reg shift_out
);reg [15:0] data;

  always @(posedge clk) begin
    if (reset) begin
      data <= 0;
      shift_out <= 0;
    end
    else if (shift) begin
      shift_out <= data[15];
      data <= {data[14:0], shift_in};
    end
  end

endmodule