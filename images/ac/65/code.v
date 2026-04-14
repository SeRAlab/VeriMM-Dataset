module top_module(
  input clk,
  input rst,
  input A,
  input B,
  output reg Y
);always @(posedge clk) begin
    if (rst) begin
      Y <= 0;
    end else begin
      Y <= A ^ B;
    end
  end

endmodule