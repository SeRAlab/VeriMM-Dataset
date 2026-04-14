module top_module(
  input clk,
  input reset,
  input write_en,
  input [7:0] data_in,
  input pop_en,
  output reg [7:0] data_out
);parameter depth = 16; // number of data elements the memory block can store

reg [7:0] memory [0:depth-1]; // array to store the data elements
reg [3:0] top; // pointer to the top data element

always @(posedge clk) begin
  if (reset) begin
    top <= 0;
  end else begin
    if (write_en) begin
      memory[top] <= data_in;
      if (top == depth-1) begin
        top <= 0;
      end else begin
        top <= top + 1;
      end
    end else if (pop_en) begin
      if (top == 0) begin
        data_out <= memory[top];
        top <= depth-1;
      end else begin
        data_out <= memory[top-1];
        top <= top - 1;
      end
    end else begin
      data_out <= memory[top];
    end
  end
end

endmodule