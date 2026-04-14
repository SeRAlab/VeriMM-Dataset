module top_module(
  input clk,
  input rst,
  input [67:0] crc,
  input [6:0] amt,
  output reg [67:0] left,
  output reg [67:0] right
);wire [67:0] in = {crc[3:0], crc[63:0]};
  reg [63:0] result; // Change 'wire' to 'reg'

  always @ (posedge clk) begin
    if (rst) begin
      left <= 68'h0;
      right <= 68'h0;
    end else begin
      result = (left[63:0] ^ {60'h0, left[67:64]} ^ right[63:0] ^ {60'h0, right[67:64]});
      result = result << 4;
      result = result ^ (amt << 60) ^ in;
      result = result ^ left[63:0]; // Use left[63:0] to match result bit width
      result = result ^ right[63:0]; // Use right[63:0] to match result bit width
      left <= {result[63:0], left[67:64]}; // Correct bit width for left
      right <= {result[59:0], right[67:64]}; // Correct bit width for right
    end
  end

endmodule