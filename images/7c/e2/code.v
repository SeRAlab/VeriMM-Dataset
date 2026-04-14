module top_module(
  input [31:0] in,
  input [4:0] shift_amount,
  input [1:0] shift_type,
  output reg [31:0] out  // Changed to reg to allow assignment in always block
);always @(*) begin
    case (shift_type)
      2'b00: out = in << shift_amount;               // Logical left shift
      2'b01: out = in >> shift_amount;               // Logical right shift
      2'b10: out = (in >> shift_amount) | (32'hFFFFFFFF << (32 - shift_amount)); // Arithmetic left shift
      2'b11: out = (in >> shift_amount) | (in[31] ? ~((1 << shift_amount) - 1) : 0); // Arithmetic right shift
      default: out = 32'b0;                           // Default case to avoid latches
    endcase
  end

endmodule