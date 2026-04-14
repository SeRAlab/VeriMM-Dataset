module calculator(
  input clk,
  input reset,
  input [1:0] op,
  input [7:0] a,
  input [7:0] b,
  output reg [7:0] result
);

  always @(posedge clk) begin
    if (reset) begin
      result <= 0;
    end else begin
      case (op)
        2'b00: result <= a + b;
        2'b01: result <= a - b;
        2'b10: result <= a * b;
        2'b11: result <= a / b;
      endcase
    end
  end

endmodule