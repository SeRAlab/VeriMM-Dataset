module top_module(
  input clk,
  input en,
  input wr_en,
  input rd_en,
  input [addr_width-1:0] wr_addr,
  input [addr_width-1:0] rd_addr,
  input [data_width-1:0] wr_data,
  output reg [data_width-1:0] rd_data // Change wire to reg to allow assignment in always block
);parameter data_width = 8; // number of bits in each data word
parameter depth = 64; // number of words in the RAM
parameter num_ports = 2; // number of read/write ports

localparam addr_width = $clog2(depth); // Use $clog2 to calculate address width

reg [data_width-1:0] ram [0:depth-1];

// Write port logic
always @(posedge clk) begin
  if (en && wr_en) begin
    ram[wr_addr] <= wr_data;
  end
end

// Read port logic
always @(posedge clk) begin
  if (en && rd_en) begin
    rd_data <= ram[rd_addr];
  end
end

endmodule