module top_module(
  input [n-1:0] in,
  input reset,
  output reg [n-1:0] checksum, // Change wire to reg since it is assigned in an always block
  output reg error             // Change wire to reg since it is assigned in an always block
);parameter n = 8; // number of bits in the data block

// Function to compute the 1's complement of a binary number
function [n-1:0] ones_complement;
  input [n-1:0] num;
  begin
    ones_complement = ~num;
  end
endfunction

// Function to compute the sum of all bits in a binary number
function [n-1:0] sum_bits;
  input [n-1:0] num;
  integer i;
  reg [n-1:0] sum;
  begin
    sum = 0;
    for (i = 0; i < n; i = i + 1) begin
      sum = sum + num[i];
    end
    sum_bits = sum;
  end
endfunction

// Checksum generator
reg [n-1:0] sum;
always @ (posedge reset) begin
  sum = sum_bits(in);
  checksum = ones_complement(sum);
end

// Checksum checker
reg [n-1:0] sum_check;
always @ (posedge reset) begin
  sum_check = sum_bits(in);
  if (ones_complement(sum_check) == checksum) begin
    error = 0;
  end else begin
    error = 1;
  end
end

endmodule