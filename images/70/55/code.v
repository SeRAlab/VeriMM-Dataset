module top_module(
  input [31:0] x,
  input [31:0] y,
  output reg [31:0] remainder // Changed to reg type
);// Always block to calculate the remainder
  always @(*) begin
    if (y == 0) begin
      remainder = 0; // Return 0 if y is 0
    end else begin
      remainder = x - (x / y) * y; // Calculate the remainder
    end
  end

endmodule