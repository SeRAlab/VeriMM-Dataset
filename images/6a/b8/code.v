module top_module(
  input clk,
  input reset,
  input write_en,
  input [data_width-1:0] data_in,
  input read_en,
  output reg [data_width-1:0] data_out // Changed to reg to allow assignment in always block
);parameter depth = 8; // depth of the memory block
parameter data_width = 8; // width of the data

// Function to compute the log base 2 of a number
function integer log2;
  input integer value;
  integer i;
  begin
    log2 = 0;
    for (i = 0; (1 << i) < value; i = i + 1)
      log2 = i + 1;
  end
endfunction

reg [data_width-1:0] mem [0:depth-1]; // data storage array
reg [log2(depth)-1:0] write_ptr = 0; // write pointer
reg [log2(depth)-1:0] read_ptr = 0; // read pointer
reg [log2(depth)-1:0] count = 0; // number of data items in the memory block

always @(posedge clk) begin
  if (reset) begin
    write_ptr <= 0;
    read_ptr <= 0;
    count <= 0;
  end else begin
    if (write_en && count < depth) begin
      mem[write_ptr] <= data_in;
      write_ptr <= write_ptr + 1;
      count <= count + 1;
    end
    if (read_en && count > 0) begin
      data_out <= mem[read_ptr];
      read_ptr <= read_ptr + 1;
      count <= count - 1;
    end
  end
end

endmodule