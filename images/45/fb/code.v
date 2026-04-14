module top_module(
  input clk,
  input rst,
  input [7:0] data,
  input start,
  input stop,
  output reg tx
);parameter BAUD_RATE = 9600;
parameter CLK_FREQ = 50000000;

reg [15:0] count; // Adjusted width to hold the maximum count value
reg [3:0] bit_count;
reg [7:0] shift_reg;

always @ (posedge clk or posedge rst) begin
  if (rst) begin
    count <= 0;
    bit_count <= 0;
    shift_reg <= 0;
    tx <= 1; // Setting idle state for tx
  end
  else begin
    if (start) begin
      count <= CLK_FREQ / BAUD_RATE - 1; // Start counting
      bit_count <= 0;
      shift_reg <= {1'b0, data, 1'b1}; // Start bit, data bits, stop bit
      tx <= 0; // Send start bit
    end
    else if (count == 0) begin
      count <= CLK_FREQ / BAUD_RATE - 1; // Reset count
      bit_count <= bit_count + 1;
      tx <= shift_reg[0]; // Send current bit
      shift_reg <= {1'b1, shift_reg[7:1]}; // Shift bits, sending stop bit when done
      if (bit_count == 8) begin
        tx <= 1; // Send stop bit
        bit_count <= 0; // Reset bit count after sending all bits
      end
    end
    else begin
      count <= count - 1; // Decrement the count
    end
  end
end

endmodule