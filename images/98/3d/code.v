module top_module(
  input [n-1:0] din,
  input clk,
  input en,
  output [n-1:0] dout
);parameter n = 8; // number of bits in the digital potentiometer

reg [n-1:0] shift_reg;
reg [n-1:0] resistance;

always @(posedge clk) begin
  if (en) begin
    shift_reg <= din;
  end
end

always @* begin
  resistance = (shift_reg == 0) ? 0 : (1 << (shift_reg - 1));
end

assign dout = resistance;

endmodule