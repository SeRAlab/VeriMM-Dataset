module top_module(
  input [n-1:0] addr,
  input [m-1:0] data_in,
  input we,
  output [m-1:0] data_out
);parameter n = 8; // number of registers
parameter m = 16; // number of bits in each register

reg [m-1:0] registers [0:n-1];

assign data_out = (addr < n) ? registers[addr] : 0;

always @ (posedge we) begin
  if (addr < n) begin
    registers[addr] <= data_in;
  end
end

endmodule