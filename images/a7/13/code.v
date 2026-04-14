module top_module(
  input clk,
  input [n-1:0] addr,
  input [m-1:0] write_data,
  input we,
  input re,
  output reg [m-1:0] read_data // Change to reg type
);parameter n = 4; // number of registers in the register file
parameter m = 8; // number of bits in each register

reg [m-1:0] registers [n-1:0];

always @(posedge clk) begin
  if (we) begin
    registers[addr] <= write_data;
  end
  if (re) begin
    read_data <= registers[addr];
  end
end

endmodule