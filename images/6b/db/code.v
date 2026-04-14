module top_module(
  input [n-1:0] addr,
  input [m-1:0] din,
  input we,
  output reg [m-1:0] dout // Change output to reg type
);parameter n = 8; // number of bits in address signal
parameter m = 16; // number of bits in data signals
parameter size = 256; // size of memory (i.e., the number of memory locations)

reg [m-1:0] mem [0:size-1]; // array of memory locations

always @(*) begin
  if (we) begin // write to memory
    mem[addr] <= din;
  end else begin // read from memory
    dout <= mem[addr];
  end
end

endmodule