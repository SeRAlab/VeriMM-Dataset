module top_module(
  input clk, rst,
  input signed [31:0] A, B,
  input [1:0] op,
  output reg signed [31:0] C
);always @(posedge clk, negedge rst) begin
    if (!rst) begin
      C <= 0;
    end else begin
      case (op)
        2'b00: C <= A + B; // addition
        2'b01: C <= A - B; // subtraction
        2'b10: C <= A * B; // multiplication
        2'b11: C <= A / B; // division
      endcase
    end
  end

endmodule