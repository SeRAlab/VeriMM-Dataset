module top_module(
  input clk,
  input rst,
  input [31:0] data_in,
  input valid_in,
  input [31:0] seed_in,
  input enable,
  output reg [31:0] data_out,
  output reg valid_out
);// Declare internal registers
  reg [31:0] a, b, c;
  reg [31:0] v0, v1, v2, v3;
  reg [31:0] k0, k1, k2;
  
  // Declare constants
  parameter [31:0] JHASH_MAGIC = 32'hdeadbeef;
  
  // Initialize internal registers and outputs
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      a <= 0;
      b <= 0;
      c <= 0;
      v0 <= JHASH_MAGIC;
      v1 <= JHASH_MAGIC;
      v2 <= JHASH_MAGIC;
      v3 <= JHASH_MAGIC;
      k0 <= 0;
      k1 <= 0;
      k2 <= 0;
      data_out <= 0;
      valid_out <= 0;
    end else begin
      if (valid_in && enable) begin
        // Mixing phase
        k0 <= data_in;
        k1 <= c;
        k2 <= seed_in;
        a <= a + k0;
        b <= b + k1;
        c <= c + k2;
        v0 <= v0 + data_in;
        v1 <= v1 + (v1 << 9 | v1 >> 23) + c;
        v2 <= v2 + (v2 << 9 | v2 >> 23) + b;
        v3 <= v3 + (v3 << 9 | v3 >> 23) + a;
      end else begin
        // Finalization phase
        v1 <= v1 + (v1 << 9 | v1 >> 23) + c;
        v2 <= v2 + (v2 << 9 | v2 >> 23) + b;
        v3 <= v3 + (v3 << 9 | v3 >> 23) + a;
        v0 <= v0 + (v1 >> 9 | v2 << 23) + (v3 >> 18 | v3 << 14);
        data_out <= v0;
        valid_out <= 1;
      end
    end
  end
  
endmodule