module top_module(
  input              clk,
  input      [511:0] sbox,
  input      [31:0]  round_key,
  input      [31:0]  n1,
  input      [31:0]  n2,
  output reg [31:0]  out1,
  output reg [31:0]  out2
);reg [31:0] t;

  always @(posedge clk) begin
    t <= (n1 + round_key) & 32'hFFFFFFFF;
    t <= sbox[(t >> 24) & 8'hFF] << 24 |
         sbox[(t >> 16) & 8'hFF] << 16 |
         sbox[(t >>  8) & 8'hFF] <<  8 |
         sbox[t        & 8'hFF];

    out1 <= n2;
    out2 <= n1 ^ t;
  end

endmodule