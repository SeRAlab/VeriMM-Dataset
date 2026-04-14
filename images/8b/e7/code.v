module top_module( input clk, input d, output q );reg q0, q1, q2;

  always @(posedge clk) begin
    q0 <= d;
    q1 <= q0;
    q2 <= q1;
  end

  assign q = q2;

endmodule