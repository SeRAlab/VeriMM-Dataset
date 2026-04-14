module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  input [1:0] op,
  output reg [n-1:0] c // Change to reg type for c
);parameter n = 16; // number of bits for fixed point representation

// define the integer and fractional bits
parameter int_bits = 8;
parameter frac_bits = n - int_bits;

// define scaling factor for fixed-point representation
parameter scaling_factor = 2 ** frac_bits;

// define maximum and minimum values for fixed-point representation
parameter max_value = (2 ** (n - 1)) - 1;
parameter min_value = -max_value;

// define two's complement representation for negative numbers
function [n-1:0] twos_complement;
  input [n-1:0] num;
  begin
    if (num[n-1] == 1) begin // Check the sign bit for negative numbers
      twos_complement = ~num + 1; // Proper two's complement conversion
    end else begin
      twos_complement = num;
    end
  end
endfunction

// perform fixed-point arithmetic operations based on control signal (op)
always @(*) begin
  case (op)
    2'b00: c = twos_complement(a) + twos_complement(b);
    2'b01: c = twos_complement(a) - twos_complement(b);
    2'b10: c = twos_complement(a) * twos_complement(b) / scaling_factor;
    2'b11: begin
      if (twos_complement(b) == 0) begin
        c = max_value;
      end else begin
        c = (twos_complement(a) * scaling_factor) / twos_complement(b);
      end
    end
  endcase
end

endmodule