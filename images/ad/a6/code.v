module top_module(
  input clk,
  input reset,
  input signed [3:0] A,
  input signed [3:0] B,
  output reg signed [4:0] C,
  output reg overflow
);reg signed [3:0] sum;
reg carry;

always @(posedge clk, posedge reset) begin
  if (reset) begin
    sum <= 4'b0;
    carry <= 1'b0;
    C <= 5'b0;
    overflow <= 1'b0;
  end else begin
    sum <= A + B + carry;
    carry <= (sum[4] == 1);
    C <= {carry, sum};
    overflow <= ((A[3] == B[3]) && (A[3] != C[4]));
  end
end

endmodule