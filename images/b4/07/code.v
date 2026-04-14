module top_module(
  input rst,
  input wr_clk,
  input rd_clk,
  input [35:0] din,
  input wr_en,
  input rd_en,
  output reg [71:0] dout,  // Changed to reg type
  output full,
  output empty,
  output prog_full
);reg [35:0] fifo_mem [0:1023];
  reg [10:0] wr_ptr = 0;
  reg [10:0] rd_ptr = 0;
  reg [10:0] fifo_count = 0;

  assign empty = (fifo_count == 0);
  assign full = (fifo_count == 1024);

  always @(posedge wr_clk or negedge rst) begin
    if (!rst) begin
      wr_ptr <= 0;
      fifo_count <= 0;
    end else if (wr_en && !full) begin
      fifo_mem[wr_ptr] <= din;
      wr_ptr <= (wr_ptr == 1023) ? 0 : wr_ptr + 1;
      fifo_count <= fifo_count + 1;
    end
  end

  always @(posedge rd_clk or negedge rst) begin
    if (!rst) begin
      rd_ptr <= 0;
      dout <= 0; // Initialize dout during reset
    end else if (rd_en && !empty) begin
      dout <= {fifo_mem[rd_ptr], fifo_mem[rd_ptr+1]};
      rd_ptr <= (rd_ptr == 1023) ? 0 : rd_ptr + 1;
      fifo_count <= fifo_count - 1;
    end
  end

  assign prog_full = (fifo_count >= 900);

endmodule