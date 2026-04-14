module top_module(
  input clk,              // Added clk input
  input [n-1:0] addr,
  input write_en,
  input [m-1:0] data_in,
  output reg [m-1:0] data_out
);parameter n = 8; // number of registers
parameter m = 16; // number of bits per register

reg [m-1:0] registers [0:n-1];

// Write operation
always @ (posedge clk) begin
  if (write_en) begin
    registers[addr] <= data_in;
  end
end

// Read operation
always @ (*) begin
  data_out = registers[addr];
end

endmodule