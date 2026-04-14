module top_module(
  input [n-1:0] clk,
  input [log2_n-1:0] sel,
  output reg out
);parameter n = 4; // number of clock signals

// Calculate log2 of n
parameter log2_n = (n <= 2) ? 1 :
                    (n <= 4) ? 2 :
                    (n <= 8) ? 3 :
                    (n <= 16) ? 4 :
                    (n <= 32) ? 5 :
                    (n <= 64) ? 6 : 7; // Extend this for larger n if necessary

always @ (sel or clk) begin
  case (sel)
    0: out = clk[0];
    1: out = clk[1];
    2: out = clk[2];
    3: out = clk[3]; // Handle sel = 3 to support n = 4
    default: out = clk[0]; // default case
  endcase
end

endmodule