module top_module(A, B, sum);input [3:0] A, B;
  output reg [3:0] sum;

  always @(*) begin
    sum = A + B;
    
    if (sum > 7 || sum < 0) begin
      sum[2:0] = sum[2:0];  // Retained the lower 3 bits as they are.
    end // This block is likely unnecessary as summation is already stored.

    // No need for additional logic as it already outputs properly.
  end
  
  // Remove multiple driver conflicts for 'sum'
  // No assignment to sum outside the always block
endmodule