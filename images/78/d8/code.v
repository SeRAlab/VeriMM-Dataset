module top_module(
  input clk,
  input rst,
  input wr_en,
  input rd_en,
  input [7:0] data_in,
  output reg [7:0] data_out,  // Changed from wire to reg
  output empty,
  output full
);reg [7:0] buffer [0:7];
  reg [2:0] write_ptr = 0;    // Changed from reg to an initial value
  reg [2:0] read_ptr = 0;     // Changed from reg to an initial value
  reg [2:0] count = 0;

  always @(posedge clk or negedge rst) begin
    if (~rst) begin
      write_ptr <= 0;
      read_ptr <= 0;
      count <= 0;
      data_out <= 0;            // Initialize data_out on reset
    end else begin
      if (wr_en && ~full) begin
        buffer[write_ptr] <= data_in;
        write_ptr <= (write_ptr + 1) % 8;
        count <= count + 1;
      end
      if (rd_en && ~empty) begin
        data_out <= buffer[read_ptr];
        read_ptr <= (read_ptr + 1) % 8;
        count <= count - 1;
      end
    end
  end

  assign empty = (count == 0);
  assign full = (count == 8);
  
endmodule