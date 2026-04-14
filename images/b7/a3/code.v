module top_module(
  input clk,
  input [23:0] din,
  input tmp_ram_rd_en,
  input [0:0] E,
  input [0:0] Q,
  input [8:0] count_d1_reg,
  input [8:0] count_d1_reg_gcc,
  output [23:0] D
);// FIFO memory
  reg [23:0] memory [0:4095];
  reg [11:0] head = 0;
  reg [11:0] tail = 0;
  reg [11:0] count = 0;

  // read and write pointers
  wire [11:0] read_ptr = (count > 0) ? tail : head;
  wire [11:0] write_ptr = head;

  // output data and status signals
  wire [23:0] data_out = memory[read_ptr];
  wire empty = (count == 0);
  wire full = (count == 4096);

  // write data to FIFO
  always @(posedge clk) begin
    if (!Q && tmp_ram_rd_en && !full) begin
      memory[write_ptr] <= din;
      head <= (head == 4095) ? 0 : head + 1;
      count <= count + 1;
    end
  end

  // read data from FIFO
  always @(posedge clk) begin
    if (!E && !empty) begin
      tail <= (tail == 4095) ? 0 : tail + 1;
      count <= count - 1;
    end
  end

  // output data and status signals
  assign D = data_out;
  assign E = empty;
  assign Q = full;
  assign count_d1_reg = count;
  assign count_d1_reg_gcc = count;

endmodule