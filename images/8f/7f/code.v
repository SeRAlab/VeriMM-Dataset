module top_module(
  input wire [n-1:0] address,
  input wire [m-1:0] data_in,
  input wire write_en,
  output reg [m-1:0] data_out  // changed wire to reg
);parameter n = 8; // number of address bits
parameter m = 16; // number of data bits
parameter depth = 256; // number of memory locations in the RAM block

reg [m-1:0] mem [0:depth-1];

always @(*) begin
  if (write_en) begin
    mem[address] <= data_in;
  end
  data_out = mem[address]; // changed to blocking assignment
end

endmodule