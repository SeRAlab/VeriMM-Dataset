module top_module(
  input [3:0] data_in,
  input [1:0] mode,
  output reg [9:0] v_out
);// Define binary constants for the voltage levels
  parameter ZERO_VOLT = 10'b0000000000;
  parameter ONE_POINT_TWO_FIVE_VOLT = 10'b0100000000;
  parameter TWO_POINT_FIVE_VOLT = 10'b1000000000;
  parameter THREE_POINT_SEVEN_FIVE_VOLT = 10'b1100000000;

  // Connect the inputs to an output buffer based on the mode
  always @(*) begin
    case (mode)
      2'b00: v_out = ZERO_VOLT;
      2'b01: v_out = ONE_POINT_TWO_FIVE_VOLT;
      2'b10: v_out = TWO_POINT_FIVE_VOLT;
      2'b11: v_out = THREE_POINT_SEVEN_FIVE_VOLT;
      default: v_out = ZERO_VOLT;
    endcase
  end

endmodule