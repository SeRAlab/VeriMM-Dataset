module top_module(input clk,
   input srst,
   input wr_en,
   input rd_en,
   input [9:0] data_in,
   output reg [9:0] data_out,  // Changed output to reg
   output empty,
   output full);reg [9:0] mem [0:9];
  reg [3:0] write_ptr;
  reg [3:0] read_ptr;
  reg [3:0] count;

  assign empty = (count == 0);
  assign full = (count == 10);

  always @(posedge clk) begin
    if (srst) begin
      write_ptr <= 0;
      read_ptr <= 0;
      count <= 0;
      data_out <= 0; // Initialize data_out on reset
    end else begin
      if (wr_en && !full) begin
        mem[write_ptr] <= data_in;
        write_ptr <= write_ptr + 1;
        count <= count + 1;
      end
      if (rd_en && !empty) begin
        data_out <= mem[read_ptr];
        read_ptr <= read_ptr + 1;
        count <= count - 1;
      end
    end
  end
endmodule