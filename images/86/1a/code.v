module top_module(
  input clk,                  // Added clk input for the clock signal
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of flip-flops
parameter m = 4; // number of output signals

reg [n-1:0] flip_flops;
reg [m-1:0] gray_code;

function [m-1:0] binary_to_gray;
  input [n-1:0] binary_value;
  begin
    binary_to_gray = binary_value ^ (binary_value >> 1);
  end
endfunction

always @(posedge clk) begin
  flip_flops <= in;
  gray_code <= binary_to_gray(flip_flops);
end

assign out = gray_code;

endmodule