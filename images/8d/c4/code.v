module top_module(
  input [9:0] address,
  input clock,
  output reg [11:0] q
);always @(*) begin
    q = {address, 2'b00}; // Shift address left by 2 bits
    if (clock) begin
      q = ~q; // Invert output if clock is high
    end
  end

endmodule