module top_module(
  input clk,
  input signed [3:0] a,
  input signed [3:0] b,
  output reg signed [7:0] out,
  output reg done
);reg signed [7:0] result;
  reg signed [3:0] ac;
  reg signed [3:0] q;
  reg signed [1:0] q_prev;
  reg signed [3:0] b_neg;

  always @(posedge clk) begin
    // initialize
    if (done == 0) begin
      result <= 0;
      ac <= {a, 4'b0};
      q <= b;
      q_prev <= 2'b00;
      b_neg <= -b;
      done <= 0;
    end
    // Booth's algorithm
    else begin
      case (q[1:0] - q_prev) 
        2'b01: ac <= ac + b_neg;
        2'b10: ac <= ac + b;
      endcase
      q_prev <= q[1:0];
      q[3:1] <= q[2:0];
      q[0] <= ac[0];
      ac[3:1] <= ac[2:0];
      result <= {ac[3], ac[3:0]} + (q[3] ? b_neg : b);
      if (q == 4'b0000) done <= 1;
    end
  end

  assign out = result;

endmodule