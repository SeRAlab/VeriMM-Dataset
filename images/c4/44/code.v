module add8 (
  input wire clk,
  input wire reset,
  input wire enable,
  input wire [7:0] a,
  input wire [7:0] b,
  output reg [7:0] c
);

  always @(posedge clk) begin
    if (reset) begin
      c <= 8'b0;
    end
    else if (enable) begin
      c <= a + b;
    end
  end

endmodule