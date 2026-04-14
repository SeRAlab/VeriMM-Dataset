module top_module(
  input wire i_clk,
  input wire i_reset,
  input wire [511:0] i_data,
  output reg [255:0] o_digest
);reg [31:0] w[0:63];
  reg [31:0] a, b, c, d, e, f, g, h;
  reg [31:0] t1, t2;

  always @(posedge i_clk) begin
    if (i_reset) begin
      a <= 32'h6a09e667;
      b <= 32'hbb67ae85;
      c <= 32'h3c6ef372;
      d <= 32'ha54ff53a;
      e <= 32'h510e527f;
      f <= 32'h9b05688c;
      g <= 32'h1f83d9ab;
      h <= 32'h5be0cd19;
    end else begin
      // Step 1: Pad message block
      // ...

      // Step 2: Break padded message block into 16 32-bit words
      // ...
      
      // Step 3: Extend 16 32-bit words into 64 32-bit words
      // ...

      // Step 4: Initialize variables
      // ...

      // Step 5: Perform 64 rounds of operations
      // ...

      // Step 6: Output message digest
      // ...
    end
  end

endmodule