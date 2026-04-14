module top_module(
  input clk,
  input reset,
  input read_en,
  input write_en,
  input [31:0] address,
  input [data_width-1:0] write_data,
  output [data_width-1:0] read_data
);parameter data_width = 32; // number of bits in each data word
parameter mem_type = "DDR"; // type of memory to interface with

// Define internal signals
reg [data_width-1:0] memory [0:2**32-1]; // memory array
reg [data_width-1:0] read_data_reg; // read data register

// Synchronize read and write operations with clock
always @(posedge clk) begin
  if (reset) begin
    // Reset memory interface block
    read_data_reg <= 0;
  end else begin
    if (read_en) begin
      // Read data from memory
      read_data_reg <= memory[address];
    end
    if (write_en) begin
      // Write data to memory
      memory[address] <= write_data;
    end
  end
end

// Output read data
assign read_data = read_data_reg;

endmodule