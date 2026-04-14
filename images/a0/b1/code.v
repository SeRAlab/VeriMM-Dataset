module top_module(
  input [3:0] A,
  input [3:0] B,
  output reg [1:0] result
);always @* begin
    result = 2'b00; // Default output is 00
    if (A > B) begin
      result = 2'b01; // A is greater than B
    end else if (A < B) begin
      result = 2'b10; // A is less than B
    end
  end

endmodule