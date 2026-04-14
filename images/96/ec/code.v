module top_module(
  input [n-1:0] in,
  input [log2_n-1:0] shift,
  output [n-1:0] out
);parameter n = 8; // number of bits in the input and output binary number.
localparam log2_n = $clog2(n); // calculate the base 2 logarithm of n

  reg [n-1:0] shifted; // register to hold the shifted binary number

  always @(*) begin
    if (shift >= 0) begin // logical shift left
      shifted = in << shift;
    end else begin // arithmetic shift right
      if (shift == -1) begin // special case for division by 2
        shifted = in >> 1;
        shifted[n-1] = in[n-2];
      end else begin // general case
        shifted = in >>> -shift;
      end
    end
  end

  assign out = shifted; // assign the shifted binary number to the output

endmodule