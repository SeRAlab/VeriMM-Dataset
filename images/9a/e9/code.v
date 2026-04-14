module top_module(
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of bits in input signal
parameter m = 2; // number of bits in output signal
parameter k = 3; // number of entries in the look-up table (2^k entries)

reg [m-1:0] lut [0:(2**k)-1]; // declare look-up table

initial begin
  // define values stored in the look-up table
  lut[0] = 2'b00;
  lut[1] = 2'b01;
  lut[2] = 2'b10;
  lut[3] = 2'b11;
end

assign out = lut[in]; // output the corresponding value from the table based on the input address

endmodule