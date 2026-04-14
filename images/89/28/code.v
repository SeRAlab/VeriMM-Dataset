module top_module(
  input [3:0] binary_input,
  input select,
  output [3:0] gray_output,
  output [3:0] gray_and_binary_output
);wire [3:0] gray_code;
  wire [3:0] xor_output;
  wire [3:0] and_output;

  // Binary to Gray code conversion
  assign gray_code[0] = binary_input[0];
  assign gray_code[1] = binary_input[1] ^ binary_input[0];
  assign gray_code[2] = binary_input[2] ^ binary_input[1];
  assign gray_code[3] = binary_input[3] ^ binary_input[2];

  // XOR operation
  assign xor_output = gray_code ^ binary_input;

  // Bitwise-AND operation
  assign and_output = gray_code & binary_input;

  // MUX to select between XOR output and AND output
  assign gray_output = select ? xor_output : and_output;

  // Gray code and binary input AND operation
  assign gray_and_binary_output = gray_code & binary_input;

endmodule