module top_module(
  input [n-1:0] in,
  input [w-1:0] addr,
  output reg [w-1:0] out
);parameter n = 4; // number of input signals
parameter w = 1; // width of data stored in memory block
parameter d = 16; // depth of memory block

reg [w-1:0] memory [0:d-1];

// Define the lookup table
initial begin
  memory[0] = 1'b0;
  memory[1] = 1'b1;
  memory[2] = 1'b1;
  memory[3] = 1'b0;
  memory[4] = 1'b1;
  memory[5] = 1'b0;
  memory[6] = 1'b0;
  memory[7] = 1'b1;
  memory[8] = 1'b1;
  memory[9] = 1'b0;
  memory[10] = 1'b0;
  memory[11] = 1'b1;
  memory[12] = 1'b0;
  memory[13] = 1'b1;
  memory[14] = 1'b1;
  memory[15] = 1'b0;
end

// Select the appropriate output value from the memory block
always @(*) begin
  out = memory[addr];
end

endmodule