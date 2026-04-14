module top_module( a, b, opcode, result, zero );input [31:0] a, b;
  input [3:0] opcode;
  output [31:0] result;
  output zero;

  reg [31:0] temp_result;
  wire [31:0] temp_a, temp_b;
  wire [4:0] temp_opcode;

  assign temp_a = (opcode[3] == 1'b0) ? a : ~a;
  assign temp_b = (opcode[2] == 1'b0) ? b : ~b;
  assign temp_opcode = (opcode[1:0] == 2'b10) ? 5'b00001 : opcode[1:0];

  always @(*) begin
    case (temp_opcode)
      5'b00000: temp_result = a + b;
      5'b00001: temp_result = b << a[4:0];
      5'b00010: temp_result = temp_a & temp_b;
      5'b00011: temp_result = temp_a | temp_b;
      5'b00100: temp_result = temp_a ^ temp_b;
      5'b00101: temp_result = a - b;
      default: temp_result = 0;
    endcase
  end

  assign result = temp_result;
  assign zero = (temp_result == 0);

endmodule