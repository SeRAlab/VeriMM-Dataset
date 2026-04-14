module top_module(
  input clk,
  input reset,
  input [15:0] data,
  output reg [3:0] length,
  output reg [3:0] start_index
);reg [3:0] max_length;
reg [3:0] max_start_index;
reg [3:0] curr_length;
reg [3:0] curr_start_index;

always @(posedge clk) begin
  if (reset) begin
    max_length <= 0;
    max_start_index <= 0;
    curr_length <= 0;
    curr_start_index <= 0;
  end else begin
    if (data == 16'hFFFF) begin
      // If all bits are 1, output the max length and start index
      length <= max_length;
      start_index <= max_start_index;
      curr_length <= 0;
      curr_start_index <= 0;
    end else begin
      if (data[0] == 1) begin
        // If the current bit is 1, increment the current length
        curr_length <= curr_length + 1;
        if (curr_length > max_length) begin
          // If the current length is greater than the max length, update the max length and start index
          max_length <= curr_length;
          max_start_index <= curr_start_index;
        end
      end else begin
        // If the current bit is 0, reset the current length and start index
        curr_length <= 0;
        curr_start_index <= curr_start_index + curr_length + 1;
      end
      // Output the current length and start index
      length <= max_length;
      start_index <= max_start_index;
    end
  end
end

endmodule