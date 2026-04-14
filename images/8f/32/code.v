module top_module(
  input rst,
  input wr_clk,
  input rd_clk,
  input [31:0] din,
  input wr_en,
  input rd_en,
  output reg [31:0] dout, // Changed output to reg type
  output full,
  output empty,
  output [COUNT_WIDTH-1:0] wr_data_count // Adjusted width to COUNT_WIDTH
);// Define FIFO parameters
  parameter WIDTH = 32; // Data width
  parameter DEPTH = 512; // Depth of FIFO (in 32-bit words)
  parameter ADDR_WIDTH = $clog2(DEPTH); // Address width
  parameter COUNT_WIDTH = $clog2(DEPTH+1); // Write data count width

  // Define FIFO memory
  reg [WIDTH-1:0] mem [0:DEPTH-1];
  reg [ADDR_WIDTH-1:0] wr_ptr;
  reg [ADDR_WIDTH-1:0] rd_ptr;
  reg [COUNT_WIDTH-1:0] wr_data_count_reg;
  reg [COUNT_WIDTH-1:0] wr_data_count_next; // Changed from wire to reg
  reg full_reg;

  // Combinational logic for write data count
  assign wr_data_count = wr_data_count_reg;

  // Combinational logic for empty
  assign empty = (wr_ptr == rd_ptr) ? 1'b1 : 1'b0;

  // Sequential logic for write data count
  always @(posedge wr_clk) begin
    if (rst) begin
      wr_data_count_reg <= 0;
    end else begin
      wr_data_count_reg <= wr_data_count_next;
    end
  end

  // Sequential logic for FIFO write operation
  always @(posedge wr_clk) begin
    if (rst) begin
      wr_ptr <= 0;
      full_reg <= 1'b0;
      wr_data_count_reg <= 0;
    end else if (wr_en && !full_reg) begin
      mem[wr_ptr] <= din;
      wr_ptr <= wr_ptr + 1;
      wr_data_count_next <= wr_data_count_reg + 1;
      if (wr_data_count_next == DEPTH) begin // Correct check for full
        full_reg <= 1'b1;
      end
    end else begin
      wr_data_count_next <= wr_data_count_reg;
    end
  end

  // Sequential logic for FIFO read operation
  always @(posedge rd_clk) begin
    if (rst) begin
      rd_ptr <= 0;
      full_reg <= 1'b0;
    end else if (rd_en && !empty) begin
      dout <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
      full_reg <= 1'b0;
    end
  end

  // Output full and empty signals
  assign full = full_reg;

endmodule