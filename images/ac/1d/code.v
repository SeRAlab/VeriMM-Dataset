module top_module(
  input [n-1:0] data_in,
  input [m-1:0] write_addr,
  input [k-1:0] read_addr,
  input reset,
  input write_en,
  input read_en,
  input clk, // Added clk as input
  output reg [n-1:0] data_out // Changed data_out to output reg
);parameter n = 8; // number of bits in each register
parameter m = 4; // number of write addresses
parameter k = 4; // number of read addresses
parameter r = 16; // number of registers in the file

reg [n-1:0] registers [0:r-1]; // register file

// write operation
integer i;
always @ (posedge clk) begin
  if (reset) begin
    for (i = 0; i < r; i = i + 1) begin
      registers[i] <= 0;
    end
  end else begin
    if (write_en) begin
      registers[write_addr] <= data_in;
    end
  end
end

// read operation
always @ (posedge clk) begin
  if (read_en) begin
    data_out <= registers[read_addr];
  end
end

endmodule