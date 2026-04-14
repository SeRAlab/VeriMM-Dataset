module top_module(
  input clk, // clock signal
  input rst, // reset signal
  output reg [n-1:0] state // Gray code state
);parameter n = 4; // number of bits in the Gray code sequence

// convert binary state to Gray code format
function [n-1:0] binary_to_gray;
  input [n-1:0] binary;
  begin
    binary_to_gray = binary ^ (binary >> 1);
  end
endfunction

// state register
reg [n-1:0] binary_state;

// define the next state logic here
always @(posedge clk or posedge rst) begin
  if (rst) begin
    binary_state <= 0;
  end else begin
    binary_state <= binary_state + 1;
    if (binary_state == (1 << n) - 1) begin
      binary_state <= 0;
    end
  end
end

// assign Gray code state to output
always @* begin
  state = binary_to_gray(binary_state);
end

endmodule