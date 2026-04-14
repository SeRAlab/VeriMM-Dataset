module top_module(
  input [n-1:0] data_in,
  input write_en,
  input read_en,
  input clk,           // Added clock input
  output reg [n-1:0] data_out  // Changed to reg to hold value in always block
);parameter n = 8;    // width of the data bus
parameter depth = 16;  // depth of the memory block

reg [n-1:0] memory [0:depth-1];  // stack data structure to store the data elements
reg [4:0] top = 0;  // variable to keep track of the top of the stack

always @ (posedge clk) begin
  if (write_en) begin
    memory[top] <= data_in;  // write data_in to the top of the stack
    top <= top + 1;  // increment the top of the stack
  end
  else if (read_en) begin
    if (top > 0) begin
      top <= top - 1;  // decrement the top of the stack
      data_out <= memory[top];  // read the data from the top of the stack
    end
    else begin
      data_out <= 0;  // if there is no data in the stack, output zeros
    end
  end
end

endmodule