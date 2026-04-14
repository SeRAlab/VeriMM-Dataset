module top_module(
  input [n-1:0] data_in,
  output reg [m-1:0] mem_out // Change to reg type
);parameter n = 8; // number of data bits
parameter m = 16; // number of memory bits
parameter k = 4; // number of check bits

reg [n-1:0] data_bits;
reg [k-1:0] check_bits;
reg [m-1:0] memory_bits;

always @(*) begin
  data_bits = data_in;

  // Calculate check bits
  check_bits[0] = data_bits[0] ^ data_bits[1] ^ data_bits[3] ^ data_bits[4] ^ data_bits[6];
  check_bits[1] = data_bits[0] ^ data_bits[2] ^ data_bits[3] ^ data_bits[5] ^ data_bits[6];
  check_bits[2] = data_bits[1] ^ data_bits[2] ^ data_bits[3] ^ data_bits[7];
  check_bits[3] = data_bits[4] ^ data_bits[5] ^ data_bits[6] ^ data_bits[7];

  // Store data bits and check bits in memory bits
  memory_bits[2:0] = {data_bits[0], data_bits[1], data_bits[3]};
  memory_bits[5:3] = {data_bits[2], data_bits[4], data_bits[5]};
  memory_bits[9:6] = {data_bits[6], data_bits[7], check_bits[0], check_bits[1]};
  memory_bits[15:10] = {check_bits[2], check_bits[3], 2'b00};

  // Output memory bits
  mem_out = memory_bits; // Assign to reg type
end

endmodule