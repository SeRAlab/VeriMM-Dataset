module top_module(
  input [31:0] a,
  input [31:0] b,
  input [1:0] operation_select,
  input [4:0] shift_amount,
  output reg [31:0] result // Change from wire to reg
);// AND operation
  wire [31:0] and_result;
  assign and_result = a & b;

  // OR operation
  wire [31:0] or_result;
  assign or_result = a | b;

  // XOR operation
  wire [31:0] xor_result;
  assign xor_result = a ^ b;

  // Shift-left operation
  wire [31:0] shift_result;
  assign shift_result = a << shift_amount;

  // Select operation based on operation_select input
  always @* begin
    case (operation_select)
      2'b00: result = and_result;
      2'b01: result = or_result;
      2'b10: result = xor_result;
      2'b11: result = shift_result;
      default: result = 32'b0; // Default case to handle undefined operation_select
    endcase
  end

endmodule