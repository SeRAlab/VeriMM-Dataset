module top_module(
  input clk,
  input rst,
  input write_en,
  input [width-1:0] write_data,
  input read_en,
  output reg [width-1:0] read_data // changed to reg
);parameter width = 8; // width of the data bus
parameter depth = 16; // depth of the memory block

reg [width-1:0] memory [depth-1:0];
reg [4:0] top; // pointer to the top of the stack
reg [4:0] count; // counter for the number of elements in the stack

always @(posedge clk) begin
  if (rst) begin
    top <= 0;
    count <= 0;
    read_data <= 0; // initialize read_data on reset
  end else begin
    if (write_en && count < depth) begin
      memory[top] <= write_data;
      top <= top + 1;
      count <= count + 1;
    end
    if (read_en && count > 0) begin
      read_data <= memory[top-1];
      top <= top - 1;
      count <= count - 1;
    end
  end
end

endmodule