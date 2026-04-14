module top_module(
  input [n-1:0] addr,
  output [m-1:0] out
);parameter n = 4; // number of address signals
parameter m = 2; // number of output signals
parameter w = 8; // width of each output signal
parameter depth = 16; // number of words in the memory

reg [w-1:0] memory [0:depth-1]; // define the memory contents as a lookup table

initial begin
  // initialize the memory contents
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

assign out[0] = memory[addr][7:0]; // output the contents of the memory at the specified address for out[0]
assign out[1] = memory[addr][15:8]; // output the contents of the memory at the specified address for out[1]

endmodule