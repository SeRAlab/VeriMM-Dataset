module top_module(
  input [n-1:0] in,
  output reg [log2_n-1:0] out
);parameter n = 8; // number of input signals
localparam log2_n = $clog2(n); // Calculate the logarithm base 2 of n

always @* begin
  casez(in) // priority encoder logic
    8'b10000000: out = 3'b000; // highest priority input
    8'b01000000: out = 3'b001;
    8'b00100000: out = 3'b010;
    8'b00010000: out = 3'b011;
    8'b00001000: out = 3'b100;
    8'b00000100: out = 3'b101;
    8'b00000010: out = 3'b110;
    8'b00000001: out = 3'b111;
    default: out = 3'b000; // default output
  endcase
end

endmodule