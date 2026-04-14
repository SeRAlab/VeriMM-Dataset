module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  input valid_a,
  input ready_b,
  output reg ready_a,   // Changed from wire to reg
  output reg valid_b,
  output reg [15:0] data_out
);parameter THRESHOLD = 256; // configurable threshold value
  
  reg [15:0] accumulator = 0;
  reg [3:0] count = 0;
  reg [15:0] temp_data = 0;
  wire [15:0] next_accumulator = accumulator + temp_data;
  
  always @(posedge clk) begin
    if (reset) begin
      accumulator <= 0;
      count <= 0;
      valid_b <= 0;
      ready_a <= 1; // Set ready_a to 1 on reset
    end
    else if (valid_a) begin
      temp_data <= data_in << (count * 8);
      accumulator <= next_accumulator;
      count <= count + 1;
      if (count == 1) begin
        ready_a <= 0;
      end
      else if (count == 2) begin
        ready_a <= 1;
      end
      if (accumulator >= THRESHOLD) begin
        valid_b <= 1;
      end
    end
    else if (ready_b && valid_b) begin
      accumulator <= 0;
      count <= 0;
      valid_b <= 0;
      ready_a <= 1;
    end
  end
  
  assign data_out = accumulator;

endmodule