module top_module(
  input clk,
  input write_en,
  input read_en,
  input [log2_depth-1:0] addr,
  input [data_width-1:0] data_in,
  output reg [data_width-1:0] data_out
);parameter depth = 16; // size of the memory block
parameter data_width = 8; // width of each data element in bits

// Compute log2 of depth for address width
localparam log2_depth = $clog2(depth);

// memory array
reg [data_width-1:0] mem [0:depth-1];

always @(posedge clk) begin
  if (write_en) begin
    mem[addr] <= data_in;
  end
  if (read_en) begin
    data_out <= mem[addr];
  end
end

endmodule