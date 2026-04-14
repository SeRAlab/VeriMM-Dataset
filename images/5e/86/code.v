module top_module(
  input wire clk,
  input wire rst,
  input wire [23:0] din,
  output reg [23:0] dout,
  output reg comp
);// Constants
  localparam WIDTH = 24;
  localparam DEPTH = 512;
  localparam ADDR_WIDTH = 9;
  localparam FULL_ADDR = DEPTH - 1;
  localparam EMPTY_ADDR = 0;
  localparam COMP_OFFSET = 24;

  // Registers
  reg [ADDR_WIDTH-1:0] write_ptr;
  reg [ADDR_WIDTH-1:0] read_ptr;
  reg [WIDTH-1:0] fifo [0:DEPTH-1];

  // Wires
  wire [WIDTH-1:0] read_data;
  wire [WIDTH-1:0] comp_data;
  wire full;
  wire empty;

  // Internal logic
  assign full = (write_ptr == FULL_ADDR) && (read_ptr == EMPTY_ADDR);
  assign empty = (write_ptr == read_ptr) && (read_ptr != EMPTY_ADDR);

  assign read_data = empty ? 0 : fifo[read_ptr];
  assign comp_data = (read_ptr >= COMP_OFFSET) ? fifo[read_ptr - COMP_OFFSET] : 0;

  always @(posedge clk) begin
    if (rst) begin
      write_ptr <= EMPTY_ADDR;
      read_ptr <= EMPTY_ADDR;
      dout <= 0;
      comp <= 0;
    end else begin
      if (!full) begin
        fifo[write_ptr] <= din;
        write_ptr <= (write_ptr == FULL_ADDR) ? EMPTY_ADDR : write_ptr + 1;
      end
      if (!empty) begin
        dout <= read_data;
        read_ptr <= (read_ptr == FULL_ADDR) ? EMPTY_ADDR : read_ptr + 1;
      end
      comp <= (comp_data == dout) ? 1 : 0;
    end
  end

endmodule