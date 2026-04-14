module top_module(
  input [7:0] num1,
  input [7:0] num2,
  input [1:0] operation,
  output reg [7:0] result,    // Changed to reg
  output reg negative          // Changed to reg
);reg [15:0] temp_result;
  reg signed [7:0] signed_result;

  always @* begin
    case(operation)
      2'b00: temp_result = num1 + num2; // Addition
      2'b01: temp_result = num1 - num2; // Subtraction
      2'b10: temp_result = num1 * num2; // Multiplication
      2'b11: temp_result = num1 / num2; // Division
      default: temp_result = 0;          // Default case to avoid latches
    endcase

    signed_result = temp_result[7:0];
    result = signed_result;  // Now valid l-value

    if(signed_result < 0) begin
      negative = 1;          // Now valid l-value
    end
    else begin
      negative = 0;          // Now valid l-value
    end
  end

endmodule