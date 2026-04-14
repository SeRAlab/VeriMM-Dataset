module top_module(
  input wire clk,          // Added clk input
  input wire [15:0] data,
  input wire reset,
  output reg [15:0] checksum,
  output reg valid
);reg [15:0] a = 1;
  reg [15:0] b = 0;

  always @(posedge clk) begin
    if (reset) begin
      a <= 1;
      b <= 0;
      checksum <= 0;
      valid <= 0;
    end else begin
      a <= (a + data) % 65521;
      b <= (b + a) % 65521;
      checksum <= (b << 16) | a;
      valid <= 1;
    end
  end

endmodule