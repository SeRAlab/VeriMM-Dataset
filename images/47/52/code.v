module top_module(
  input clk,
  input rst,
  input wr_en,
  input rd_en,
  input [addr_width-1:0] addr,
  input [width-1:0] data_in,
  output reg [width-1:0] data_out
);parameter depth = 1024; // depth of the scratchpad memory block
parameter width = 32; // width of each memory location in bits
localparam addr_width = $clog2(depth); // Calculate address width using $clog2

// dual-port RAM with separate read and write ports
reg [width-1:0] memory [0:depth-1];

// write data to memory block at specified address
always @(posedge clk) begin
  if (wr_en) begin
    memory[addr] <= data_in;
  end
end

// read data from memory block at specified address
always @(posedge clk) begin
  if (rd_en) begin
    data_out <= memory[addr];
  end else begin
    data_out <= 0; // Output zero when not reading
  end
end

// reset memory block to zero
integer i; // Declare the iterator i
always @(posedge clk) begin
  if (rst) begin
    for (i = 0; i < depth; i = i + 1) begin
      memory[i] <= 0;
    end
  end
end

endmodule