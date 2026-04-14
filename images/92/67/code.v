module top_module(
  input [3:0] A,
  input [3:0] B,
  output reg [7:0] out // Changed from wire to reg
);reg [7:0] result;
  integer i;

  always @ (A or B) begin
    result = 0;
    for (i = 0; i < 4; i = i + 1) begin
      result = result + (B[i] * {A, 2'b0} << i);
    end
    out = result; // Now this assignment is valid
  end

endmodule