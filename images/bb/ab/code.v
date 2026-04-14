module top_module(
  input clk,
  input rst_n,
  input fifo_rd,
  input fifo_wr,
  input [7:0] fifo_data_in,
  output fifo_empty,
  output fifo_full,
  output reg [7:0] fifo_data_out,  // Changed from wire to reg
  output reg [3:0] fifo_count
);parameter FIFO_SIZE = 16;
  
  reg [7:0] fifo_buffer [0:FIFO_SIZE-1];
  reg [3:0] read_ptr = 4'b0;
  reg [3:0] write_ptr = 4'b0;
  reg [3:0] next_write_ptr;
  reg [3:0] next_read_ptr;
  
  assign fifo_empty = (fifo_count == 0);
  assign fifo_full = (fifo_count == FIFO_SIZE);
  
  always @(posedge clk) begin
    if (rst_n == 0) begin
      fifo_count <= 0;
      read_ptr <= 0;
      write_ptr <= 0;
      fifo_data_out <= 0; // Initialize output on reset
    end else begin
      if (fifo_wr && !fifo_full) begin
        fifo_buffer[write_ptr] <= fifo_data_in;
        next_write_ptr <= write_ptr + 1;
        if (next_write_ptr == FIFO_SIZE) begin
          next_write_ptr <= 0;
        end
      end else begin
        next_write_ptr <= write_ptr;
      end
      if (fifo_rd && !fifo_empty) begin
        fifo_data_out <= fifo_buffer[read_ptr]; // Correctly assign data_out
        next_read_ptr <= read_ptr + 1;
        if (next_read_ptr == FIFO_SIZE) begin
          next_read_ptr <= 0;
        end
      end else begin
        next_read_ptr <= read_ptr;
      end
      if (fifo_wr != fifo_rd) begin
        fifo_count <= fifo_count + (fifo_wr ? 1 : -1);
      end
      write_ptr <= next_write_ptr;
      read_ptr <= next_read_ptr;
    end
  end
  
endmodule