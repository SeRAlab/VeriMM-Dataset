module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out
);parameter n = 8; // number of input bits
parameter m = 10; // number of output bits (4 bits for each decimal digit)

reg [3:0] bcd [0:(n/4)-1];

integer i;

always @(*) begin
  for (i = 0; i < n/4; i = i + 1) begin
    case (in[i*4 +: 4])
      4'b0000: bcd[i] = 4'b0000;
      4'b0001: bcd[i] = 4'b0001;
      4'b0010: bcd[i] = 4'b0010;
      4'b0011: bcd[i] = 4'b0011;
      4'b0100: bcd[i] = 4'b0100;
      4'b0101: bcd[i] = 4'b0101;
      4'b0110: bcd[i] = 4'b0110;
      4'b0111: bcd[i] = 4'b0111;
      4'b1000: bcd[i] = 4'b1000;
      4'b1001: bcd[i] = 4'b1001;
      default: bcd[i] = 4'b0000;
    endcase
  end
  
  // Concatenating the bcd array into out
  out = {bcd[0], bcd[1]}; // Assuming n is always 8 and m is 10
end

endmodule