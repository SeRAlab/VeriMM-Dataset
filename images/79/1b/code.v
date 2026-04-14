module top_module(
  input clk,
  input rst,
  input wr_en,
  input [7:0] data_in,
  output reg rd_en,       // Change to reg type
  output reg [7:0] data_out // Change to reg type
);parameter depth = 16; // depth of memory block

reg [7:0] mem [0:depth-1]; // memory block
reg [4:0] write_ptr = 0; // write pointer
reg [4:0] read_ptr = 0; // read pointer
reg [4:0] count = 0; // count of elements in memory block

always @(posedge clk) begin
  if (rst) begin
    write_ptr <= 0;
    read_ptr <= 0;
    count <= 0;
    rd_en <= 0;
    data_out <= 0; // Initialize data_out on reset
  end else begin
    rd_en <= (count > 0); // Update rd_en based on count
    if (wr_en) begin
      mem[write_ptr] <= data_in;
      write_ptr <= write_ptr + 1;
      count <= count + 1;
      if (write_ptr == depth) begin
        write_ptr <= 0;
      end
    end
    if (rd_en) begin
      data_out <= mem[read_ptr];
      read_ptr <= read_ptr + 1;
      count <= count - 1;
      if (read_ptr == depth) begin
        read_ptr <= 0;
      end
    end
  end
end

endmodule