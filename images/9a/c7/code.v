module top_module(
  input clk,
  input reset,
  input operation,
  input [3:0] A,
  input [3:0] B,
  output reg [3:0] result
);always @(posedge clk or negedge reset) begin
  if (reset == 0) begin
    result <= 4'b0000;
  end else begin
    if (operation == 0) begin
      result <= A + B;
    end else begin
      result <= A - B;
    end
  end
end

endmodule