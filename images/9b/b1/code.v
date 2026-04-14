module top_module(comp1,
   v1_reg,
   din,
   din_en,
   dout,
   dout_en,
   clk,
   rst);parameter DEPTH = 32768;
  parameter WIDTH = 32;

  output comp1;
  input [4:0]v1_reg;
  input [WIDTH-1:0]din;
  input din_en;
  output [WIDTH-1:0]dout;
  output dout_en;
  input clk;
  input rst;

  reg [WIDTH-1:0]mem [0:DEPTH-1];
  reg [14:0]wr_ptr;
  reg [14:0]rd_ptr;
  reg [31:0]count;
  wire [31:0]next_count;
  wire empty;
  wire full;
  wire match;
  wire [WIDTH-1:0]next_fifo_out;
  wire next_dout_en;
  wire [14:0]next_wr_ptr;
  wire [14:0]next_rd_ptr;

  assign comp1 = match;

  // Empty and full flags
  assign empty = (count == 0);
  assign full = (count == DEPTH);

  // FIFO output and output enable
  assign dout = (empty ? {WIDTH{1'b0}} : mem[rd_ptr]);
  assign dout_en = !empty;

  // Next count
  assign next_count = count + (din_en && !full) - (dout_en && !empty);

  // Next read and write pointers
  assign next_wr_ptr = wr_ptr + (din_en && !full);
  assign next_rd_ptr = rd_ptr + (dout_en && !empty);

  // Next FIFO output - use a reg instead of a wire
  reg [WIDTH-1:0] fifo_out;

  // Match flag
  assign match = (count > 0) && (mem[rd_ptr] == v1_reg);

  // Write to memory
  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 0;
      count <= 0;
    end else if (din_en && !full) begin
      mem[wr_ptr] <= din;
      wr_ptr <= next_wr_ptr;
      count <= next_count;
    end
  end

  // Read from memory
  always @(posedge clk) begin
    if (rst) begin
      rd_ptr <= 0;
      fifo_out <= {WIDTH{1'b0}};
    end else if (dout_en && !empty) begin
      rd_ptr <= next_rd_ptr;
      fifo_out <= mem[rd_ptr]; // Assigning the FIFO output within the read block
    end
  end

endmodule