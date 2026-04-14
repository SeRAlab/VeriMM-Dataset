module top_module(
  input [n-1:0] addr,
  output [m-1:0] data
);parameter n = 4; // number of bits in the address
parameter m = 8; // number of bits in the data
parameter k = 16; // number of words in the memory

reg [m-1:0] memory [0:k-1];

initial begin
  // Define the memory contents as a set of binary values
  memory[0] = 8'b00000001;
  memory[1] = 8'b00000010;
  memory[2] = 8'b00000011;
  memory[3] = 8'b00000100;
  memory[4] = 8'b00000101;
  memory[5] = 8'b00000110;
  memory[6] = 8'b00000111;
  memory[7] = 8'b00001000;
  memory[8] = 8'b00001001;
  memory[9] = 8'b00001010;
  memory[10] = 8'b00001011;
  memory[11] = 8'b00001100;
  memory[12] = 8'b00001101;
  memory[13] = 8'b00001110;
  memory[14] = 8'b00001111;
  memory[15] = 8'b00010000;
end

assign data = memory[addr];

endmodule