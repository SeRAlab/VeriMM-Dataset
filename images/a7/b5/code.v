module top_module(
  input clk,
  input rst,
  input wen,
  input [7:0] din,
  output reg ren,
  output reg [7:0] dout,
  output reg full,
  output reg empty
);parameter depth = 16; // depth of the FIFO block

reg [7:0] buffer [0:depth-1];
reg [4:0] write_ptr = 0;
reg [4:0] read_ptr = 0;
reg [4:0] count = 0;

always @(posedge clk) begin
  if (rst) begin
    write_ptr <= 0;
    read_ptr <= 0;
    count <= 0;
    ren <= 0;
    dout <= 0;
    full <= 0;
    empty <= 1;
  end
  else begin
    if (wen && count < depth) begin
      buffer[write_ptr] <= din;
      write_ptr <= write_ptr + 1;
      count <= count + 1;
      empty <= 0;
      if (count == depth) full <= 1;
    end
    if (ren && count > 0) begin
      dout <= buffer[read_ptr];
      read_ptr <= read_ptr + 1;
      count <= count - 1;
      full <= 0;
      if (count == 1) empty <= 1;
    end
    ren <= (count > 0);
  end
end

endmodule