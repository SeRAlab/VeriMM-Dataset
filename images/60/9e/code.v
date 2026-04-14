module top_module(
  input clk,
  input reset,
  input [3:0] A,
  input [3:0] B,
  output [3:0] S
);reg [3:0] carry;
reg [3:0] sum;

always @ (posedge clk or negedge reset) begin
  if (!reset) begin
    carry <= 4'b0;
    sum <= 4'b0;
  end else begin
    carry <= {carry[2:0], A[3]&B[3] | A[3]&carry[3] | B[3]&carry[3]};
    sum <= A + B + carry;
  end
end

assign S = sum;

endmodule