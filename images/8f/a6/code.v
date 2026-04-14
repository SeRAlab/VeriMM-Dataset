module top_module(
  input clk,
  input we,
  input [addr_width-1:0] addr,
  input [data_width-1:0] data_in,
  output reg [data_width-1:0] data_out
);parameter data_width = 8; // width of the data bus in bits
parameter addr_width = 6; // width of the address bus in bits
parameter depth = 64; // depth of the memory block in number of locations

reg [data_width-1:0] mem [0:depth-1]; // memory array

// write operation
always @(posedge clk) begin
  if (we) begin
    mem[addr] <= data_in;
  end
end

// read operation
always @(posedge clk) begin
  if (!we) begin
    data_out <= mem[addr];
  end
end

endmodule