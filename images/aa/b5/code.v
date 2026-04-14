module top_module(
  input [31:0] A,
  input [31:0] B,
  input [1:0] op,
  output reg [31:0] out
);// Internal result wire Declarations
  wire [31:0] add_result, sub_result, mul_result, div_result;

  // Simple floating-point operation implementations for demonstration
  assign add_result = A + B;        // Replace with actual fp_add
  assign sub_result = A - B;        // Replace with actual fp_sub
  assign mul_result = A * B;        // Replace with actual fp_mul
  assign div_result = A / B;        // Replace with actual fp_div

  // Select the result based on the operation
  always @(*) begin
    case (op)
      2'b00: out = add_result;
      2'b01: out = sub_result;
      2'b10: out = mul_result;
      2'b11: out = div_result;
      default: out = 32'b0;
    endcase
  end
  
endmodule