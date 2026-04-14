module top_module(
  input clk,
  input reset,
  input [31:0] set_index_i,
  input [31:0] set_index_j,
  input [31:0] set_value,
  output reg [31:0] get_value // Changed to reg type
);parameter array_size = 10;

  reg [31:0] array [0:array_size-1][0:array_size-1];

  // initialize array to 0
  integer i, j;
  initial begin
    for (i = 0; i < array_size; i = i + 1) begin
      for (j = 0; j < array_size; j = j + 1) begin
        array[i][j] = 0;
      end
    end
  end

  // set value of array element
  always @(posedge clk) begin
    if (reset) begin
      array[set_index_i][set_index_j] <= 0;
    end else begin
      array[set_index_i][set_index_j] <= set_value;
    end
  end

  // get value of array element
  always @(posedge clk) begin
    get_value <= array[set_index_i][set_index_j];
  end

endmodule