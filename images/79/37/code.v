module top_module(output reg [93:0] dout, // Change to reg type
   input clk,
   input wr_en,
   input rd_en,
   input [93:0] din);// Define constants
  parameter WIDTH = 94; // Data width
  parameter DEPTH = 64; // Depth of FIFO
  parameter ADDR_WIDTH = $clog2(DEPTH); // Address width
  parameter MEM_WIDTH = WIDTH + ADDR_WIDTH; // Width of memory
  parameter MEM_DEPTH = DEPTH + 1; // Depth of memory

  // Define signals
  reg [MEM_WIDTH-1:0] memory [0:MEM_DEPTH-1]; // Memory
  reg [ADDR_WIDTH-1:0] wr_ptr = 0; // Write pointer
  reg [ADDR_WIDTH-1:0] rd_ptr = 0; // Read pointer
  reg [ADDR_WIDTH-1:0] next_wr_ptr = 0; // Next write pointer
  reg [ADDR_WIDTH-1:0] next_rd_ptr = 0; // Next read pointer
  wire [MEM_WIDTH-1:0] rd_data = memory[rd_ptr]; // Data read from memory

  // Write logic
  always @(posedge clk) begin
    if (wr_en) begin
      memory[wr_ptr] <= {din, wr_ptr}; // Write data to memory
      next_wr_ptr <= wr_ptr + 1; // Update next write pointer
    end
  end

  // Read logic
  always @(posedge clk) begin
    if (rd_en) begin
      dout <= rd_data[WIDTH-1:0]; // Output data
      next_rd_ptr <= rd_ptr + 1; // Update next read pointer
    end
  end

  // Update pointers
  always @(posedge clk) begin
    wr_ptr <= next_wr_ptr;
    rd_ptr <= next_rd_ptr;
  end

endmodule