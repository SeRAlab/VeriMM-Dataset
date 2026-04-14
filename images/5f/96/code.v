module top_module(
  input [n-1:0] addr,
  output reg [m-1:0] out // Change to reg type
);parameter n = 8; // number of address signals
parameter m = 16; // number of output signals per data word

reg [m-1:0] mem [0:2**n-1]; // Fix range from mem [2**n-1:0] to mem [0:2**n-1] for proper indexing

// initialize memory with data
initial begin
  mem[0] = 16'h0000;
  mem[1] = 16'h1234;
  mem[2] = 16'h5678;
  // add more data words here
end

// decoder logic
always @ (addr) begin
  out = mem[addr];
end

endmodule