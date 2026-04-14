module top_module(
  input signed [31:0] dividend,
  input signed [31:0] divisor,
  input start,
  input clk,
  output reg signed [31:0] quotient,
  output reg signed [31:0] remainder,
  output reg done
);reg signed [31:0] temp_dividend;
  reg signed [31:0] temp_remainder;
  reg signed [31:0] temp_quotient;
  reg [5:0] counter; // Changed to 6 bits to handle values from 0 to 32
  reg signed [31:0] temp_subtract; // Changed to signed

  always @(posedge clk) begin
    if (start) begin
      // Initialize values
      temp_dividend <= dividend;
      temp_remainder <= dividend;
      temp_quotient <= 0;
      counter <= 32; // Maximum number of iterations
      done <= 0;
    end else if (counter > 0) begin
      // Shift remainder left and set LSB to next bit of dividend
      temp_remainder <= {temp_remainder[30:0], temp_dividend[counter-1]}; // Correct left-shift usage
      temp_subtract <= temp_remainder - divisor;
      if (temp_subtract >= 0) begin
        // If remainder is greater than or equal to divisor, subtract divisor and set quotient bit to 1
        temp_remainder <= temp_subtract;
        temp_quotient <= {temp_quotient[30:0], 1'b1}; // Specify bit width
      end else begin
        // If remainder is less than divisor, set quotient bit to 0
        temp_quotient <= {temp_quotient[30:0], 1'b0}; // Specify bit width
      end
      counter <= counter - 1;
    end else begin
      // If most significant bit of quotient is 1, add divisor to remainder and subtract 1 from quotient
      if (temp_quotient[31] == 1) begin
        temp_remainder <= temp_remainder + divisor;
        temp_quotient <= temp_quotient - 1;
      end
      quotient <= temp_quotient;
      remainder <= temp_remainder;
      done <= 1;
    end
  end

endmodule