module top_module(
  input clk,
  input reset,
  input [7:0] push_data,
  input pop,
  output reg [7:0] top_data, // Change wire to reg
  output empty
);parameter depth = 8; // number of elements in the stack

reg [7:0] stack [depth-1:0]; // stack array
reg [3:0] top = 0; // top of the stack
wire full = (top == depth-1); // full signal

assign empty = (top == 0); // empty signal

always @(posedge clk) begin
  if (reset) begin
    top <= 0;
    top_data <= 0;
  end
  else begin
    if (pop && !empty) begin
      top <= top - 1;
      top_data <= stack[top]; // This is now valid since top_data is reg
    end
    else if (!full) begin
      stack[top] <= push_data;
      top <= top + 1;
      top_data <= push_data; // This is now valid since top_data is reg
    end
  end
end

endmodule