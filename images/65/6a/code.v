module top_module(din,
   dout,
   wr_clk,
   rd_clk,
   reset,
   empty,
   full);parameter MEM_DEPTH = 2048;
  parameter MEM_WIDTH = 32;

  input [MEM_WIDTH-1:0] din;
  output reg [MEM_WIDTH-1:0] dout; // Changed to "reg" as dout is driven from an always block
  input wr_clk;
  input rd_clk;
  input reset;
  output reg empty; // Changed to "reg" to be driven from an always block
  output reg full;  // Changed to "reg" to be driven from an always block

  reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1]; // Memory array
  reg [MEM_WIDTH-1:0] wr_ptr = 0;
  reg [MEM_WIDTH-1:0] rd_ptr = 0;
  
  reg [MEM_WIDTH-1:0] next_wr_ptr;
  reg [MEM_WIDTH-1:0] next_rd_ptr;

  always @(posedge wr_clk) begin
    if (reset) begin
      wr_ptr <= 0;
    end else if (!full) begin
      mem[wr_ptr] <= din; // Write data to memory
      wr_ptr <= next_wr_ptr;
    end
  end

  always @(posedge rd_clk) begin
    if (reset) begin
      rd_ptr <= 0;
    end else if (!empty) begin
      dout <= mem[rd_ptr]; // Read data from memory
      rd_ptr <= next_rd_ptr;
    end
  end

  always @* begin
    next_wr_ptr = (wr_ptr + 1) % MEM_DEPTH;
    next_rd_ptr = (rd_ptr + 1) % MEM_DEPTH;
    full = (next_wr_ptr == rd_ptr); // Update full status
    empty = (wr_ptr == rd_ptr);     // Update empty status
  end

endmodule