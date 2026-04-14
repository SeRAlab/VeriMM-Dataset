module top_module(
  input [n-1:0] in,
  input [log2_n-1:0] ctl,
  input dir,
  output reg [n-1:0] out
);parameter n = 8; // number of bits in the binary number

// Calculating log2(n)
localparam log2_n = (n == 1) ? 1 : (n <= 2) ? 1 : (n <= 4) ? 2 : 
                    (n <= 8) ? 3 : (n <= 16) ? 4 : (n <= 32) ? 5 : 
                    (n <= 64) ? 6 : (n <= 128) ? 7 : 8;

// Shift logic
always @(*) begin
  if (dir == 0) begin
    // Left shift
    out = (in << ctl);
  end else begin
    // Right shift
    out = (in >> ctl);
  end
end

endmodule