module top_module(
  input [n-1:0] input1,
  input [n-1:0] input2,
  input [1:0] ctrl,
  output [n-1:0] result
);parameter n = 4; // number of bits in input and output signals

  // Bitwise AND operation
  assign result = (ctrl == 2'b00) ? (input1 & input2) :
  
  // Bitwise OR operation
                   (ctrl == 2'b01) ? (input1 | input2) :
                   
  // Bitwise XOR operation
                   (ctrl == 2'b10) ? (input1 ^ input2) :
                   
  // Bitwise NOT operation
                   (~input1);
  
endmodule